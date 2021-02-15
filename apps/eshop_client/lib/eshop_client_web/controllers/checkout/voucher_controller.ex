defmodule EshopClientWeb.Checkout.VoucherController do
  use EshopClientWeb, :controller

  alias EshopCore.Checkout
  alias EshopCore.Checkout.VoucherRepo

  action_fallback EshopClientWeb.FallbackController

  def index(conn, params) do
    role = conn.private[:role]
    paginate = VoucherRepo.list_voucher_with_paging(params, role)

    entries =
      paginate.entries
      |> EshopCore.Repo.preload([:category])

    render(conn, "index.json", vouchers: entries, paginate: paginate)
  end

  def check(conn, %{"code" => code}) do
    voucher = Checkout.get_voucher_by(%{code: code})

    render(conn, "show.json", voucher: voucher)
  end
end
