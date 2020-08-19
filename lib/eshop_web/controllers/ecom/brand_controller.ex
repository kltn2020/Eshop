defmodule EshopWeb.Controllers.Ecom.BrandController do
  use EshopWeb, :controller

  alias Eshop.Ecom

  action_fallback EshopWeb.FallbackController

  def index(conn, _params) do
    brands =
      Ecom.list_brands()
      |> Eshop.Utils.StructHelper.to_map()

    conn |> json(%{status: "OK", data: brands})
  end
end
