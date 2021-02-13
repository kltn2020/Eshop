defmodule EshopAdminWeb.Checkout.OrderController do
  use EshopAdminWeb, :controller

  alias EshopCore.Checkout

  action_fallback EshopAdminWeb.FallbackController

  def index(conn, params) do
    user_id = conn.private[:user_id]
    role = conn.private[:role]

    paging = Checkout.list_orders_with_paging(role, user_id, params)

    entries =
      paging.entries
      |> EshopCore.Repo.preload(:voucher)
      |> EshopCore.Utils.StructHelper.to_map()

    conn |> json(%{status: "OK", data: %{paging | entries: entries}})
  end

  def show(conn, %{"id" => id}) do
    order =
      Checkout.get_order!(id)
      |> EshopCore.Repo.preload([:address, :user, :voucher, lines: :product])

    order =
      order
      |> EshopCore.Utils.StructHelper.to_map()
      |> Map.merge(%{
        user: order.user && Map.take(order.user, [:id, :email])
      })

    conn
    |> put_status(:ok)
    |> json(%{status: "OK", data: order})
  end

  def update(conn, %{"id" => id} = params) do
    order = Checkout.get_order!(id)

    case Checkout.update_order(order, params) do
      {:ok, order} ->
        conn
        |> put_status(:ok)
        |> json(%{status: "OK", data: EshopCore.Utils.StructHelper.to_map(order)})

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
end
