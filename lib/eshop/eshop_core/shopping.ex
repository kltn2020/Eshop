defmodule EshopCore.Shopping do
  import Ecto.Query, warn: false
  alias Eshop.Repo

  alias EshopCore.Shopping.{Cart, CartProduct}

  def get_cart(user_id), do: Repo.get_by(Cart, user_id: user_id)

  def create_cart(user_id) do
    %Cart{}
    |> Cart.changeset(%{user_id: user_id})
    |> Repo.insert()
  end

  def get_cart_product(cart_id, product_id),
    do: Repo.get_by(CartProduct, cart_id: cart_id, product_id: product_id)

  def create_cart_product(cart_id, product_id) do
    %CartProduct{}
    |> CartProduct.changeset(%{cart_id: cart_id, product_id: product_id})
    |> Repo.insert()
  end

  def update_cart_product(%CartProduct{} = cart_product, attrs) do
    cart_product
    |> CartProduct.changeset(attrs)
    |> Repo.update()
  end

  def delete_cart_product(%CartProduct{} = cart_product) do
    Repo.delete(cart_product)
  end

  def find_cart(user_id) do
    case get_cart(user_id) do
      nil ->
        {:ok, cart} = create_cart(user_id)
        cart

      cart ->
        cart
    end
  end

  defp update_quantity_cart(cart, product_id, number) do
    case get_cart_product(cart.id, product_id) do
      nil ->
        number > 0 && create_cart_product(cart.id, product_id)

      cart_product ->
        if cart_product.quantity == 1 && number == -1 do
          delete_cart_product(cart_product)
        else
          update_cart_product(cart_product, %{quantity: cart_product.quantity + number})
        end
    end
  end

  def increase_quantity_item(user_id, product_id) do
    cart = find_cart(user_id)

    update_quantity_cart(cart, product_id, 1)
  end

  def decrease_quantity_item(user_id, product_id) do
    cart = find_cart(user_id)

    update_quantity_cart(cart, product_id, -1)
  end

  def clear_my_cart(user_id) do
    cart = find_cart(user_id)

    from(cp in CartProduct, where: cp.cart_id == ^cart.id) |> Repo.delete_all()
  end
end
