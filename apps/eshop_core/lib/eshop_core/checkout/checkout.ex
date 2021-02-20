defmodule EshopCore.Checkout do
  import Ecto.Query, warn: false
  alias EshopCore.Repo

  alias EshopCore.Checkout.Voucher
  alias EshopCore.Checkout.Address
  alias EshopCore.Checkout.Order

  def list_vouchers do
    Repo.all(Voucher)
  end

  def get_voucher!(id), do: Repo.get!(Voucher, id)

  def get_voucher_by(params), do: Repo.get_by(Voucher, params)

  def create_voucher(attrs \\ %{}) do
    %Voucher{}
    |> Voucher.changeset(attrs)
    |> Repo.insert()
  end

  def update_voucher(%Voucher{} = voucher, attrs) do
    voucher
    |> Voucher.changeset(attrs)
    |> Repo.update()
  end

  def delete_voucher(%Voucher{} = voucher) do
    Repo.delete(voucher)
  end

  def change_voucher(%Voucher{} = voucher, attrs \\ %{}) do
    Voucher.changeset(voucher, attrs)
  end

  def list_addresses(params) do
    from(address in Address, order_by: [desc: :is_primary])
    |> EshopCore.Utils.Filter.apply(params)
    |> Repo.all()
  end

  def get_address!(id), do: Repo.get!(Address, id)

  def create_address(attrs \\ %{}) do
    is_primary = Map.get(attrs, "is_primary")

    if is_primary do
      user_id = Map.get(attrs, "user_id")

      from(address in Address,
        where: address.user_id == ^user_id,
        update: [set: [is_primary: false]]
      )
      |> Repo.update_all([])
    end

    %Address{}
    |> Address.changeset(attrs)
    |> Repo.insert()
  end

  def update_address(%Address{} = address, attrs) do
    is_primary = Map.get(attrs, "is_primary")

    if is_primary do
      user_id = Map.get(attrs, "user_id")

      from(address in Address,
        where: address.user_id == ^user_id,
        update: [set: [is_primary: false]]
      )
      |> Repo.update_all([])
    end

    address
    |> Address.changeset(attrs)
    |> Repo.update()
  end

  def delete_address(%Address{} = address) do
    Repo.delete(address)
  end

  def list_orders do
    Repo.all(Order)
  end

  def get_order!(id), do: Repo.get!(Order, id)

  def create_order(cart_id, voucher_id, attrs \\ %{}) do
    voucher =
      if voucher_id do
        EshopCore.Checkout.get_voucher!(voucher_id)
      end

    lines =
      from(
        cp in EshopCore.Shopping.CartProduct,
        where: cp.active == true,
        where: cp.cart_id == ^cart_id,
        join: p in EshopCore.Ecom.Product,
        on: cp.product_id == p.id,
        select: %{
          product_id: cp.product_id,
          quantity: cp.quantity,
          discount_price: p.discount_price,
          category_id: p.category_id
        }
      )
      |> Repo.all()
      |> Enum.map(fn line ->
        price = line[:quantity] * line[:discount_price]

        discount =
          with false <- is_nil(voucher),
               true <- line[:category_id] == voucher.category_id do
            (price * voucher.value / 100) |> trunc()
          else
            _ -> 0
          end

        Map.merge(line, %{
          price: price,
          discount: discount,
          total: price - discount
        })
      end)

    total =
      lines
      |> Enum.map(fn line -> line.total end)
      |> Enum.sum()

    discount =
      lines
      |> Enum.map(fn line -> line.discount end)
      |> Enum.sum()

    attrs =
      attrs
      |> Map.put("lines", lines)
      |> Map.put("total", total)
      |> Map.put("discount", discount)
      |> Map.put("voucher_id", voucher_id)

    update_voucher(voucher, %{is_used: true})

    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  def update_order(%Order{} = order, attrs) do
    order
    |> Order.update_changeset(attrs)
    |> Repo.update()
  end

  def list_orders_with_paging("user", user_id, params) do
    from(o in Order, where: o.user_id == ^user_id)
    |> EshopCore.Utils.Filter.apply(params)
    |> EshopCore.Utils.Paginator.new(Repo, params)
  end

  def list_orders_with_paging("admin", _user_id, params) do
    from(o in Order)
    |> EshopCore.Utils.Filter.apply(params)
    |> EshopCore.Utils.Paginator.new(Repo, params)
  end
end
