defmodule EshopClientWeb.Ecom.ProductController do
  use EshopClientWeb, :controller

  alias EshopCore.Ecom
  alias EshopCore.Settings

  action_fallback EshopClientWeb.FallbackController

  def index(conn, params) do
    paging = Ecom.list_products_with_paging(params)

    entries =
      paging.entries
      |> EshopCore.Repo.preload([:category, :brand])
      |> EshopCore.Utils.StructHelper.to_map()

    conn |> json(%{status: "OK", data: %{paging | entries: entries}})
  end

  def content_based_recommend(conn, %{"product_id" => product_id}) do
    user_id = conn.private[:user_id]
    setting = Settings.get_setting()
    paging = Ecom.content_based_recommend(user_id, product_id, setting.limit)

    entries =
      paging.entries
      |> EshopCore.Repo.preload([:category, :brand])
      |> EshopCore.Utils.StructHelper.to_map()

    conn |> json(%{status: "OK", data: %{paging | entries: entries}})
  end

  def collaborative_recommend(conn, %{"product_id" => product_id}) do
    user_id = conn.private[:user_id]
    setting = Settings.get_setting()
    paging = Ecom.collaborative_recommend(user_id, product_id, setting.limit)

    entries =
      paging.entries
      |> EshopCore.Repo.preload([:category, :brand])
      |> EshopCore.Utils.StructHelper.to_map()

    conn |> json(%{status: "OK", data: %{paging | entries: entries}})
  end

  def show(conn, %{"id" => id}) do
    product = Ecom.get_product!(id)

    user_id = conn.private[:user_id]

    EshopCore.Tracking.create_user_view_product(%{product_id: id, user_id: user_id})

    conn |> json(%{status: "OK", data: EshopCore.Utils.StructHelper.to_map(product)})
  end
end
