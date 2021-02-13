defmodule EshopClientWeb.Ecom.CategoryController do
  use EshopClientWeb, :controller

  alias EshopCore.Ecom

  action_fallback EshopClientWeb.FallbackController

  def index(conn, _params) do
    categories =
      Ecom.list_categories()
      |> EshopCore.Utils.StructHelper.to_map()

    conn |> json(%{status: "OK", data: categories})
  end
end
