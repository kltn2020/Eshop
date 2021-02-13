defmodule EshopClientWeb.Ecom.BrandController do
  use EshopClientWeb, :controller

  alias EshopCore.Ecom

  action_fallback EshopClientWeb.FallbackController

  def index(conn, _params) do
    brands =
      Ecom.list_brands()
      |> EshopCore.Utils.StructHelper.to_map()

    conn |> json(%{status: "OK", data: brands})
  end
end
