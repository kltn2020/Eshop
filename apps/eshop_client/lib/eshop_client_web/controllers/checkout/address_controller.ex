defmodule EshopClientWeb.Checkout.AddressController do
  use EshopClientWeb, :controller

  alias EshopCore.Checkout
  alias EshopCore.Checkout.Address

  action_fallback EshopClientWeb.FallbackController

  def index(conn, _params) do
    user_id = conn.private[:user_id]

    addresses =
      Checkout.list_addresses(%{user_id: user_id}) |> EshopCore.Utils.StructHelper.to_map()

    conn |> json(%{status: "OK", data: addresses})
  end

  def create(conn, params) do
    user_id = conn.private[:user_id]

    params = Map.put(params, "user_id", user_id)

    case Checkout.create_address(params) do
      {:ok, address} ->
        address = address |> EshopCore.Utils.StructHelper.to_map()

        conn
        |> put_status(:ok)
        |> json(%{status: "OK", data: address})

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

  def update(conn, %{"id" => id} = params) do
    address = Checkout.get_address!(id)
    user_id = conn.private[:user_id]

    if address.user_id != user_id do
      conn |> put_status(:bad_request) |> json(%{status: "ERROR", data: "NO PERMISSION"})
    else
      params = Map.put(params, "user_id", user_id)

      case Checkout.update_address(address, params) do
        {:ok, address} ->
          conn
          |> put_status(:ok)
          |> json(%{status: "OK", data: EshopCore.Utils.StructHelper.to_map(address)})

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
  end

  def delete(conn, %{"id" => id}) do
    address = Checkout.get_address!(id)
    user_id = conn.private[:user_id]

    if address.user_id != user_id do
      conn |> put_status(:bad_request) |> json(%{status: "ERROR", data: "NO PERMISSION"})
    else
      with {:ok, %Address{}} <- Checkout.delete_address(address) do
        conn |> json(%{status: "OK"})
      end
    end
  end
end
