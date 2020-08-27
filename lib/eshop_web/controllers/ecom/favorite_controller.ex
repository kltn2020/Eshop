defmodule EshopWeb.Ecom.FavoriteController do
  use EshopWeb, :controller

  alias Eshop.Ecom
  alias Eshop.Ecom.Favorite

  action_fallback EshopWeb.FallbackController

  def index(conn, _params) do
    user_id = conn.private[:user_id]

    products =
      Ecom.list_favorite_products(user_id)
      |> Eshop.Repo.preload([:category, :brand])
      |> Eshop.Utils.StructHelper.to_map()

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
            |> EshopWeb.ChangesetView.translate_errors()
            |> Eshop.Utils.Validator.get_validation_error_message()
        })
    end
  end

  def delete(conn, %{"product_id" => product_id}) do
    user_id = conn.private[:user_id]

    Ecom.delete_favorite(user_id, product_id)

    conn |> json(%{status: "OK"})
  end
end
