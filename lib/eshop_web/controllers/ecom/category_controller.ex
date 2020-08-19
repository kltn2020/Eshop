defmodule EshopWeb.Controllers.Ecom.CategoryController do
  use EshopWeb, :controller

  alias Eshop.Ecom

  action_fallback EshopWeb.FallbackController

  def index(conn, _params) do
    categories =
      Ecom.list_categories()
      |> Eshop.Utils.StructHelper.to_map()

    conn |> json(%{status: "OK", data: categories})
  end
end
