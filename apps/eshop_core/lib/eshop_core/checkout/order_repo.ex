defmodule EshopCore.Checkout.OrderRepo do
  import Ecto.Query, warn: false
  alias EshopCore.Repo
  alias EshopCore.Checkout.Order
  alias EshopCore.Checkout

  defp get_lines(cart_id, voucher \\ nil) do
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
      quantity = Map.get(line, :quantity) || 1
      discount_price = Map.get(line, :discount_price) || 0
      price = quantity * discount_price

      # discount by voucher
      discount = calcu_discount(line, voucher, price)

      Map.merge(line, %{
        price: price,
        discount: discount,
        total: price - discount
      })
    end)
  end

  defp calcu_discount(_, nil, _), do: 0

  defp calcu_discount(line, voucher, price) do
    if line[:category_id] == voucher.category_id do
      (price * voucher.value / 100) |> trunc()
    else
      0
    end
  end

  def calcu_price(lines) do
    total =
      lines
      |> Enum.map(& &1.total)
      |> Enum.sum()

    discount =
      lines
      |> Enum.map(& &1.discount)
      |> Enum.sum()

    {total, discount}
  end

  # create order without voucher
  def create_order(cart_id, nil, attrs) do
    lines = get_lines(cart_id)

    {total, discount} = calcu_price(lines)

    attrs =
      Map.merge(attrs, %{
        "lines" => lines,
        "total" => total,
        "discount" => discount
      })

    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  # create order with voucher
  def create_order(cart_id, voucher, attrs) do
    lines = get_lines(cart_id, voucher)

    {total, discount} = calcu_price(lines)

    attrs =
      Map.merge(attrs, %{
        "lines" => lines,
        "total" => total,
        "discount" => discount,
        "voucher_id" => voucher.id
      })

    Checkout.update_voucher(voucher, %{is_used: true})

    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end
end
