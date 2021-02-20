defmodule EshopCore.Shopping do
  use EshopCore, :domain

  alias EshopCore.Shopping.Cart
  alias EshopCore.Shopping.CartProduct

  def get_cart(user_id), do: Repo.get_by(Cart, user_id: user_id)

  def create_cart(user_id) do
    %Cart{}
    |> Cart.changeset(%{user_id: user_id})
    |> Repo.insert()
  end

  def create_cart_product(cart_id, product_id, quantity) do
    %CartProduct{}
    |> CartProduct.changeset(%{cart_id: cart_id, product_id: product_id, quantity: quantity})
    |> Repo.insert()
  end

  def update_cart_product(%CartProduct{} = cart_product, attrs) do
    cart_product
    |> CartProduct.changeset(attrs)
    |> Repo.update()
  end

  def find_cart_product(cart_id, product_id) do
    cart_product = Repo.get_by(CartProduct, %{cart_id: cart_id, product_id: product_id})

    with true <- is_nil(cart_product),
         {:ok, cart_product} <- create_cart_product(cart_id, product_id, 1) do
      cart_product
    else
      false ->
        cart_product
    end
  end

  def delete_cart_product(%CartProduct{} = cart_product) do
    Repo.delete(cart_product)
  end

  def find_cart(user_id) do
    user = user_id |> EshopCore.Identity.get_user!() |> Repo.preload(:cart)

    case user.cart do
      nil ->
        {:ok, cart} = create_cart(user_id)
        cart

      cart ->
        cart
    end
  end

  def update_quantity_cart(cart_id, product_id, quantity) do
    cart_product = find_cart_product(cart_id, product_id)

    if quantity == 0 do
      delete_cart_product(cart_product)
    else
      update_cart_product(cart_product, %{quantity: quantity})
    end
  end

  def clear_my_cart(cart_id) do
    from(
      cp in CartProduct,
      where: cp.cart_id == ^cart_id,
      where: cp.active == true
    )
    |> Repo.delete_all()
  end

  def toggle_cart_product(cart_id, product_id) do
    cart_product = find_cart_product(cart_id, product_id)

    update_cart_product(cart_product, %{active: !cart_product.active})
  end
end
