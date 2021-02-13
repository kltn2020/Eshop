defmodule EshopAdminWeb.Checkout.VoucherController do
  use EshopAdminWeb, :controller

  alias EshopCore.Checkout
  alias EshopCore.Checkout.Voucher
  alias EshopCore.Checkout.VoucherRepo

  action_fallback EshopAdminWeb.FallbackController

  def index(conn, params) do
    role = conn.private[:role]
    paging = VoucherRepo.list_voucher_with_paging(params, role)

    entries =
      paging.entries
      |> EshopCore.Repo.preload([:category])
      |> EshopCore.Utils.StructHelper.to_map()

    conn |> json(%{status: "OK", data: %{paging | entries: entries}})
  end

  def create(conn, params) do
    case Checkout.create_voucher(params) do
      {:ok, voucher} ->
        voucher = voucher |> EshopCore.Utils.StructHelper.to_map()

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
            |> EshopAdminWeb.ChangesetView.translate_errors()
            |> EshopCore.Utils.Validator.get_validation_error_message()
        })
    end
  end

  def show(conn, %{"id" => id}) do
    voucher = Checkout.get_voucher!(id) |> EshopCore.Utils.StructHelper.to_map()

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
        |> json(%{status: "OK", data: EshopCore.Utils.StructHelper.to_map(voucher)})

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
    voucher = Checkout.get_voucher!(id)

    with {:ok, %Voucher{}} <- Checkout.delete_voucher(voucher) do
      conn |> json(%{status: "OK"})
    end
  end

  def check(conn, %{"code" => code}) do
    voucher = Checkout.get_voucher_by(%{code: code}) |> EshopCore.Utils.StructHelper.to_map()

    conn |> json(%{status: "OK", data: voucher})
  end
end
