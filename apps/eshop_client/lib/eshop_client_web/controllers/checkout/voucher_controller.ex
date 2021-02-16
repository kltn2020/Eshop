defmodule EshopClientWeb.Checkout.VoucherController do
  use EshopClientWeb, :controller

  alias EshopCore.Checkout
  alias EshopCore.Checkout.VoucherRepo
  alias EshopCore.Repo

  @default_preload [
    :category
  ]

  action_fallback EshopClientWeb.FallbackController

  def index(conn, params) do
    role = conn.private[:role]
    paginate = VoucherRepo.list_voucher_with_paging(params, role)

    entries =
      paginate.entries
      |> Repo.preload(@default_preload)

    render(conn, "index.json", vouchers: entries, paginate: paginate)
  end

  def check(conn, %{"code" => code}) do
    with voucher <- Checkout.get_voucher_by(%{code: code}),
         false <- is_nil(voucher),
         voucher <- Repo.preload(voucher, @default_preload) do
      render(conn, "show.json", voucher: voucher)
    end
  end
end
