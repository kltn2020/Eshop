defmodule EshopClientWeb.Ecom.BrandView do
  use EshopClientWeb, :view

  @fields [
    :id,
    :name
  ]

  @custom_fields []

  @relationships []

  def render("brand.json", %{brand: brand}) do
    render_json(brand, @fields, @custom_fields, @relationships)
  end
end
