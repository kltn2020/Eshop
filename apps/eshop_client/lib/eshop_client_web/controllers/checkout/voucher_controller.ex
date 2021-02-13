defmodule EshopClientWeb.Checkout.VoucherController do
  use EshopClientWeb, :controller

  alias EshopCore.Checkout
  alias EshopCore.Checkout.VoucherRepo

  action_fallback EshopClientWeb.FallbackController

  def index(conn, params) do
    role = conn.private[:role]
    paging = VoucherRepo.list_voucher_with_paging(params, role)

    entries =
      paging.entries
      |> EshopCore.Repo.preload([:category])
      |> EshopCore.Utils.StructHelper.to_map()

    conn |> json(%{status: "OK", data: %{paging | entries: entries}})
  end

  def check(conn, %{"code" => code}) do
    voucher = Checkout.get_voucher_by(%{code: code}) |> EshopCore.Utils.StructHelper.to_map()

    conn |> json(%{status: "OK", data: voucher})
  end
end
