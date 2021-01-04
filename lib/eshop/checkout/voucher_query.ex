defmodule Eshop.Checkout.VoucherQuery do
  import Ecto.Query
  alias Eshop.Checkout.Voucher

  def query do
    Voucher
  end

  def is_running(query) do
    now = DateTime.utc_now()

    query
    |> where([v], fragment("? between ? and ?", ^now, v.valid_from, v.valid_to))
  end

  def is_used(query) do
    query
  end

  def is_used(query, used?) do
    query
    |> where([v], v.is_used == ^used?)
  end
end
