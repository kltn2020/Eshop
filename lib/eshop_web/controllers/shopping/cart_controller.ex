defmodule EshopWeb.Shopping.CartController do
  use EshopWeb, :controller

  action_fallback EshopWeb.FallbackController

  def my_cart(conn, _params) do
    user_id = conn.private[:user_id]

    cart =
      Eshop.Shopping.find_cart(user_id)
      |> Eshop.Repo.preload(items: :product)
      |> Eshop.Utils.StructHelper.to_map()

    conn
    |> json(%{status: "OK", data: cart})
  end

  def clear_my_cart(conn, _params) do
    user_id = conn.private[:user_id]

    Eshop.Shopping.clear_my_cart(user_id)

    conn |> json(%{status: "OK"})
  end

  def increase_item(conn, %{"product_id" => product_id}) do
    user_id = conn.private[:user_id]

    Eshop.Shopping.increase_quantity_item(user_id, product_id)

    conn |> json(%{status: "OK"})
  end

  def decrease_item(conn, %{"product_id" => product_id}) do
    user_id = conn.private[:user_id]

    Eshop.Shopping.decrease_quantity_item(user_id, product_id)

    conn |> json(%{status: "OK"})
  end
end
