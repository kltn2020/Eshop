defmodule Eshop.Checkout.VoucherRepo do
  alias Eshop.Repo
  alias Eshop.Checkout.VoucherQuery

  def list_voucher_with_paging(params, "admin") do
    VoucherQuery.query()
    |> VoucherQuery.is_used()
    |> Eshop.Utils.Filter.apply(params)
    |> Eshop.Utils.Paginator.new(Repo, params)
  end

  def list_voucher_with_paging(params, _role) do
    VoucherQuery.query()
    |> VoucherQuery.is_running()
    |> VoucherQuery.is_used(false)
    |> Eshop.Utils.Filter.apply(params)
    |> Eshop.Utils.Paginator.new(Repo, params)
  end
end
