defmodule EshopClientWeb.Ecom.CategoryView do
  use EshopClientWeb, :view

  @fields [
    :id,
    :name
  ]

  @custom_fields []

  @relationships []

  def render("category.json", %{category: category}) do
    render_json(category, @fields, @custom_fields, @relationships)
  end
end
