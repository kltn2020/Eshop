defmodule EshopClientWeb.Shopping.CartView do
  use EshopClientWeb, :view

  @fields [
    :id
  ]

  @custom_fields []

  @relationships []

  def render("cart.json", %{cart: cart}) do
    %{
      data: render_json(cart, @fields, @custom_fields, @relationships),
      status: "OK"
    }
  end
end
