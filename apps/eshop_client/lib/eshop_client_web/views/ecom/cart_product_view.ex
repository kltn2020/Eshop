defmodule EshopClientWeb.Shopping.CartProductView do
  use EshopClientWeb, :view

  @fields [
    :id,
    :quantity,
    :active
  ]

  @custom_fields []

  @relationships [
    product: EshopClientWeb.Ecom.ProductView
  ]

  def render("cart_product.json", %{cart_product: cart_product}) do
    render_json(cart_product, @fields, @custom_fields, @relationships)
  end
end
