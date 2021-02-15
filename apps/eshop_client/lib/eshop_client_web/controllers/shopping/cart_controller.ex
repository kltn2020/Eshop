defmodule EshopClientWeb.Shopping.CartController do
  use EshopClientWeb, :controller

  alias EshopCore.Shopping
  alias EshopCore.Repo

  action_fallback EshopClientWeb.FallbackController

  def my_cart(conn, _params) do
    with user_id <- conn.private[:user_id],
         cart <- Shopping.find_cart(user_id),
         cart <- Repo.preload(cart, items: :product) do
      render(conn, "cart.json", cart: cart)
    end
  end

  def clear_my_cart(conn, _params) do
    user_id = conn.private[:user_id]

    cart = Shopping.find_cart(user_id)

    Shopping.clear_my_cart(cart.id)

    conn |> json(%{status: "OK"})
  end

  def update_quantity(conn, %{"product_id" => product_id, "quantity" => quantity}) do
    user_id = conn.private[:user_id]

    cart = Shopping.find_cart(user_id)

    Shopping.update_quantity_cart(cart.id, product_id, quantity)

    conn |> json(%{status: "OK"})
  end

  def toggle_cart_product(conn, %{"product_id" => product_id}) do
    user_id = conn.private[:user_id]

    cart = Shopping.find_cart(user_id)

    Shopping.toggle_cart_product(cart.id, product_id)

    conn |> json(%{status: "OK"})
  end
end
