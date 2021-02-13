defmodule EshopAdminWeb.Ecom.ProductController do
  use EshopAdminWeb, :controller

  alias EshopCore.Ecom
  alias EshopCore.Ecom.Product
  alias EshopCore.ES.Product.Store, as: ESStore

  action_fallback EshopAdminWeb.FallbackController

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
            |> EshopAdminWeb.ChangesetView.translate_errors()
            |> EshopCore.Utils.Validator.get_validation_error_message()
        })
    end
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
            |> EshopAdminWeb.ChangesetView.translate_errors()
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
