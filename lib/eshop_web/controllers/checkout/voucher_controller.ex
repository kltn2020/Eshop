defmodule EshopWeb.Checkout.VoucherController do
  use EshopWeb, :controller

  alias Eshop.Checkout
  alias Eshop.Checkout.Voucher
  alias Eshop.Checkout.VoucherRepo

  action_fallback EshopWeb.FallbackController

  def index(conn, params) do
    role = conn.private[:role]
    paging = VoucherRepo.list_voucher_with_paging(params, role)

    entries =
      paging.entries
      |> Eshop.Repo.preload([:category])
      |> Eshop.Utils.StructHelper.to_map()

    conn |> json(%{status: "OK", data: %{paging | entries: entries}})
  end

  def create(conn, params) do
    case Checkout.create_voucher(params) do
      {:ok, voucher} ->
        voucher = voucher |> Eshop.Utils.StructHelper.to_map()

        conn
        |> put_status(:ok)
        |> json(%{status: "OK", data: voucher})

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
    voucher = Checkout.get_voucher!(id) |> Eshop.Utils.StructHelper.to_map()

    conn
    |> put_status(:ok)
    |> json(%{status: "OK", data: voucher})
  end

  def update(conn, %{"id" => id} = params) do
    voucher = Checkout.get_voucher!(id)

    case Checkout.update_voucher(voucher, params) do
      {:ok, voucher} ->
        conn
        |> put_status(:ok)
        |> json(%{status: "OK", data: Eshop.Utils.StructHelper.to_map(voucher)})

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
    voucher = Checkout.get_voucher!(id)

    with {:ok, %Voucher{}} <- Checkout.delete_voucher(voucher) do
      conn |> json(%{status: "OK"})
    end
  end

  def check(conn, %{"code" => code}) do
    voucher = Checkout.get_voucher_by(%{code: code}) |> Eshop.Utils.StructHelper.to_map()

    conn |> json(%{status: "OK", data: voucher})
  end
end
