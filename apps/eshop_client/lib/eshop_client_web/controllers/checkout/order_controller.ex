defmodule EshopClientWeb.Checkout.OrderController do
  use EshopClientWeb, :controller

  alias EshopCore.Checkout
  alias EshopCore.Shopping
  alias EshopCore.Repo

  action_fallback EshopClientWeb.FallbackController

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

  def create(conn, params) do
    with user_id <- conn.private[:user_id],
         cart <- Shopping.find_cart(user_id),
         {:ok} <- check_cart(cart),
         voucher_id <- get_voucher_id(params),
         params <- Map.put(params, "user_id", user_id),
         {:ok, order} <- Checkout.create_order(cart.id, voucher_id, params) do
      Shopping.clear_my_cart(cart.id)

      order =
        order
        |> EshopCore.Repo.preload(:voucher)
        |> EshopCore.Utils.StructHelper.to_map()

      conn
      |> put_status(:ok)
      |> json(%{status: "OK", data: order})
    else
      {:error, :cart_item} ->
        conn
        |> put_status(:bad_request)
        |> json(%{
          status: "ERROR",
          code: "CREATE_ERROR",
          message: "Empty Cart"
        })

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
            |> EshopClientWeb.ChangesetView.translate_errors()
            |> EshopCore.Utils.Validator.get_validation_error_message()
        })
    end
  end

  defp check_cart(cart) do
    cart = cart |> Repo.preload(:items)

    items = cart.items |> Enum.filter(fn item -> item.active end)

    case length(items) != 0 do
      true -> {:ok}
      false -> {:error, :cart_item}
    end
  end

  defp get_voucher_id(params) do
    with code <- Map.get(params, "voucher_code"),
         true <- code not in [nil, ""],
         voucher <- Checkout.get_voucher_by(%{code: code}),
         false <- is_nil(voucher) do
      voucher.id
    else
      _ -> nil
    end
  end
end
