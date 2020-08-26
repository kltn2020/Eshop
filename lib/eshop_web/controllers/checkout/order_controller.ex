defmodule EshopWeb.Checkout.OrderController do
  use EshopWeb, :controller

  alias Eshop.Checkout
  alias Eshop.Shopping

  action_fallback EshopWeb.FallbackController

  def index(conn, params) do
    user_id = conn.private[:user_id]
    role = conn.private[:role]

    paging = Checkout.list_orders_with_paging(role, user_id, params)

    entries =
      paging.entries
      |> Eshop.Utils.StructHelper.to_map()

    conn |> json(%{status: "OK", data: %{paging | entries: entries}})
  end

  def create(conn, params) do
    user_id = conn.private[:user_id]

    cart = Eshop.Shopping.find_cart(user_id) |> Eshop.Repo.preload(:items)

    if Enum.count(cart.items) == 0 do
      conn
      |> put_status(:bad_request)
      |> json(%{
        status: "ERROR",
        code: "CREATE_ERROR",
        message: "Empty Cart"
      })
    else
      params = Map.put(params, "user_id", user_id)

      voucher_id = Map.get(params, "voucher_id")

      case Checkout.create_order(cart.id, voucher_id, params) do
        {:ok, order} ->
          Shopping.clear_my_cart(cart.id)

          order = order |> Eshop.Utils.StructHelper.to_map()

          conn
          |> put_status(:ok)
          |> json(%{status: "OK", data: order})

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
  end

  def show(conn, %{"id" => id}) do
    order =
      Checkout.get_order!(id)
      |> Eshop.Repo.preload([:address, :user, :voucher, lines: :product])

    order =
      order
      |> Eshop.Utils.StructHelper.to_map()
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
        |> json(%{status: "OK", data: Eshop.Utils.StructHelper.to_map(order)})

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
end
