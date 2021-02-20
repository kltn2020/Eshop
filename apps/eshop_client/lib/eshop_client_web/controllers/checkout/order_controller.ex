defmodule EshopClientWeb.Checkout.OrderController do
  use EshopClientWeb, :controller

  alias EshopCore.Checkout
  alias EshopCore.Shopping
  alias EshopCore.Repo
  alias EshopCore.Checkout.Voucher

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
    user_id = conn.private[:user_id]
    params = Map.put(params, "user_id", user_id)

    with cart <- Shopping.find_cart(user_id),
         {:ok} <- check_cart(cart),
         {:ok, voucher} <- get_voucher(params),
         {:ok, _order} <- Checkout.create_order(cart.id, voucher, params) do
      Shopping.clear_my_cart(cart.id)

      conn
      |> put_status(:ok)
      |> json(%{status: "OK"})
    else
      {:error, :code_not_found} ->
        conn
        |> put_status(:bad_request)
        |> json(%{
          status: "ERROR",
          code: "CREATE_ERROR",
          message: "VOUCHER NOT FOUND"
        })

      {:error, :is_used} ->
        conn
        |> put_status(:bad_request)
        |> json(%{
          status: "ERROR",
          code: "CREATE_ERROR",
          message: "VOUCHER IS USED"
        })

      {:error, :cart_item} ->
        conn
        |> put_status(:bad_request)
        |> json(%{
          status: "ERROR",
          code: "CREATE_ERROR",
          message: "Empty Cart"
        })

      err ->
        err
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

  defp get_voucher(params) do
    code = Map.get(params, "voucher_code")

    with true <- code not in [nil, ""],
         %Voucher{} = voucher <- Checkout.get_voucher_by(%{code: code}),
         {:is_used, false} <- {:is_used, voucher.is_used} do
      {:ok, voucher}
    else
      {:is_used, true} ->
        {:error, :is_used}

      nil ->
        {:error, :code_not_found}

      # not have code or can find code
      _ ->
        {:ok, nil}
    end
  end
end
