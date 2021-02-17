defmodule EshopClientWeb.Ecom.FavoriteController do
  use EshopClientWeb, :controller

  alias EshopCore.Ecom

  action_fallback EshopClientWeb.FallbackController

  def index(conn, _params) do
    user_id = conn.private[:user_id]

    products =
      Ecom.list_favorite_products(user_id)
      |> EshopCore.Repo.preload([:category, :brand])
      |> EshopCore.Utils.StructHelper.to_map()

    conn |> json(%{status: "OK", data: products})
  end

  def create(conn, %{"product_id" => product_id}) do
    user_id = conn.private[:user_id]

    case Ecom.create_favorite(user_id, product_id) do
      {:ok, _} ->
        conn
        |> put_status(:ok)
        |> json(%{status: "OK"})

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

  def show(conn, %{"product_id" => product_id}) do
    user_id = conn.private[:user_id]

    case Ecom.find_favourite(user_id, product_id) do
      nil ->
        conn
        |> put_status(:bad_request)
        |> json(%{status: "you didn't like this product"})

      _ ->
        conn |> json(%{status: "OK"})
    end
  end

  def delete(conn, %{"product_id" => product_id}) do
    user_id = conn.private[:user_id]

    Ecom.delete_favorite(user_id, product_id)

    conn |> json(%{status: "OK"})
  end
end
