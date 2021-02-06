defmodule EshopWeb.Shopping.CartController do
  use EshopWeb, :controller

  alias Eshop.Shopping

  action_fallback EshopWeb.FallbackController

  def my_cart(conn, _params) do
    user_id = conn.private[:user_id]

    cart =
      Shopping.find_cart(user_id)
      |> Eshop.Repo.preload(items: :product)
      |> Eshop.Utils.StructHelper.to_map()

    conn
    |> json(%{status: "OK", data: cart})
  end

  def clear_my_cart(conn, _params) do
    user_id = conn.private[:user_id]

    cart = Shopping.find_cart(user_id)

    Shopping.clear_my_cart(cart.id)

    conn |> json(%{status: "OK"})
  end

  def update_quantity(conn, %{"product_id" => product_id} = params) do
    user_id = conn.private[:user_id]

    cart = Shopping.find_cart(user_id)

    Shopping.update_quantity_cart(cart.id, product_id, params)

    conn |> json(%{status: "OK"})
  end

  def toggle_cart_product(conn, %{"product_id" => product_id}) do
    user_id = conn.private[:user_id]

    cart = Shopping.find_cart(user_id)

    Shopping.toggle_cart_product(cart.id, product_id)

    conn |> json(%{status: "OK"})
  end
end
