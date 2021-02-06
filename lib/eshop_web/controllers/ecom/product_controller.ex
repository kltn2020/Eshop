defmodule EshopWeb.Ecom.ProductController do
  use EshopWeb, :controller

  alias Eshop.Ecom
  alias Eshop.Ecom.Product
  alias Eshop.ES.Product.Store, as: ESStore

  action_fallback EshopWeb.FallbackController

  def index(conn, params) do
    paging = Ecom.list_products_with_paging(params)

    entries =
      paging.entries
      |> Eshop.Repo.preload([:category, :brand])
      |> Eshop.Utils.StructHelper.to_map()

    conn |> json(%{status: "OK", data: %{paging | entries: entries}})
  end

  def content_based_recommend(conn, %{"product_id" => product_id}) do
    user_id = conn.private[:user_id]
    paging = Ecom.content_based_recommend(user_id, product_id)

    entries =
      paging.entries
      |> Eshop.Repo.preload([:category, :brand])
      |> Eshop.Utils.StructHelper.to_map()

    conn |> json(%{status: "OK", data: %{paging | entries: entries}})
  end

  def collaborative_recommend(conn, %{"product_id" => product_id}) do
    user_id = conn.private[:user_id]
    paging = Ecom.collaborative_recommend(user_id, product_id)

    entries =
      paging.entries
      |> Eshop.Repo.preload([:category, :brand])
      |> Eshop.Utils.StructHelper.to_map()

    conn |> json(%{status: "OK", data: %{paging | entries: entries}})
  end

  def create(conn, params) do
    case Ecom.create_product(params) do
      {:ok, product} ->
        ESStore.update_product_to_es(product, :create)

        conn
        |> put_status(:ok)
        |> json(%{status: "OK", data: Eshop.Utils.StructHelper.to_map(product)})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{
          status: "ERROR",
          code: "VALIDATION_FAILED",
          message:
            changeset
            |> EshopWeb.ChangesetView.translate_errors()
            |> Eshop.Utils.Validator.get_validation_error_message()
        })
    end
  end

  def show(conn, %{"id" => id}) do
    product = Ecom.get_product!(id)

    user_id = conn.private[:user_id]

    Eshop.Tracking.create_user_view_product(%{product_id: id, user_id: user_id})

    conn |> json(%{status: "OK", data: Eshop.Utils.StructHelper.to_map(product)})
  end

  def update(conn, %{"id" => id} = params) do
    product = Ecom.get_product!(id)

    case Ecom.update_product(product, params) do
      {:ok, product} ->
        ESStore.update_product_to_es(product, :update)

        conn
        |> put_status(:ok)
        |> json(%{status: "OK", data: Eshop.Utils.StructHelper.to_map(product)})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{
          status: "ERROR",
          code: "VALIDATION_FAILED",
          message:
            changeset
            |> EshopWeb.ChangesetView.translate_errors()
            |> Eshop.Utils.Validator.get_validation_error_message()
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
