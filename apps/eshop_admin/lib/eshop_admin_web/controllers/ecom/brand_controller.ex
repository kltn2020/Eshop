defmodule EshopAdminWeb.Ecom.BrandController do
  use EshopAdminWeb, :controller

  alias EshopCore.Ecom

  action_fallback EshopAdminWeb.FallbackController

  def index(conn, _params) do
    brands =
      Ecom.list_brands()
      |> EshopCore.Utils.StructHelper.to_map()

    conn |> json(%{status: "OK", data: brands})
  end
end
