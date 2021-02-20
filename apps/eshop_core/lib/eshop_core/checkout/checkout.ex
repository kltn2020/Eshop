defmodule EshopCore.Checkout do
  use EshopCore, :domain

  alias EshopCore.Checkout.Voucher
  alias EshopCore.Checkout.Address
  alias EshopCore.Checkout.Order

  alias EshopCore.Checkout.OrderRepo

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

  def create_order(cart_id, voucher, attrs \\ %{}),
    do: OrderRepo.create_order(cart_id, voucher, attrs)

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
