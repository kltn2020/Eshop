defmodule EshopCore.Checkout.VoucherRepo do
  alias EshopCore.Repo
  alias EshopCore.Checkout.VoucherQuery

  def list_voucher_with_paging(params, "admin") do
    VoucherQuery.query()
    |> VoucherQuery.is_used()
    |> EshopCore.Utils.Filter.apply(params)
    |> EshopCore.Utils.Paginator.new(Repo, params)
  end

  def list_voucher_with_paging(params, _role) do
    VoucherQuery.query()
    |> VoucherQuery.is_running()
    |> VoucherQuery.is_used(false)
    |> EshopCore.Utils.Filter.apply(params)
    |> EshopCore.Utils.Paginator.new(Repo, params)
  end
end
