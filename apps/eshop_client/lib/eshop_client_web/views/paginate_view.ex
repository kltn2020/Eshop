defmodule EshopClientWeb.PaginateView do
  use EshopClientWeb, :view

  @fields [:page, :size, :total, :total_entries, :total_pages]

  def render("paginate.json", %{paginate: paginate}) do
    render_json(paginate, @fields, [], [])
  end
end
