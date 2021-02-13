defmodule EshopClientWeb.Ecom.ProductController do
  use EshopClientWeb, :controller

  alias EshopCore.Ecom
  alias EshopCore.Settings
  alias EshopCore.Ecom.Product
  alias EshopCore.ES.Product.Store, as: ESStore

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

  def create(conn, params) do
    case Ecom.create_product(params) do
      {:ok, product} ->
        ESStore.update_product_to_es(product, :create)

        conn
        |> put_status(:ok)
        |> json(%{status: "OK", data: EshopCore.Utils.StructHelper.to_map(product)})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{
          status: "ERROR",
          code: "VALIDATION_FAILED",
          message:
            changeset
            |> EshopClientWeb.ChangesetView.translate_errors()
            |> EshopCore.Utils.Validator.get_validation_error_message()
        })
    end
  end

  def show(conn, %{"id" => id}) do
    product = Ecom.get_product!(id)

    user_id = conn.private[:user_id]

    EshopCore.Tracking.create_user_view_product(%{product_id: id, user_id: user_id})

    conn |> json(%{status: "OK", data: EshopCore.Utils.StructHelper.to_map(product)})
  end

  def update(conn, %{"id" => id} = params) do
    product = Ecom.get_product!(id)

    case Ecom.update_product(product, params) do
      {:ok, product} ->
        ESStore.update_product_to_es(product, :update)

        conn
        |> put_status(:ok)
        |> json(%{status: "OK", data: EshopCore.Utils.StructHelper.to_map(product)})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{
          status: "ERROR",
          code: "VALIDATION_FAILED",
          message:
            changeset
            |> EshopClientWeb.ChangesetView.translate_errors()
            |> EshopCore.Utils.Validator.get_validation_error_message()
        })
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Ecom.get_product!(id)

    with {:ok, %Product{}} <- Ecom.delete_product(product) do
      ESStore.update_product_to_es(product, :delete)

      conn |> json(%{status: "OK"})
    end
  end
end
