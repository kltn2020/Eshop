defmodule Eshop.Checkout do
  import Ecto.Query, warn: false
  alias Eshop.Repo

  alias Eshop.Checkout.Voucher

  def list_vouchers do
    Repo.all(Voucher)
  end

  def get_voucher!(id), do: Repo.get!(Voucher, id)

  def get_voucher_by(params), do: Repo.get_by(Voucher, params)

  def create_voucher(attrs \\ %{}) do
    %Voucher{}
    |> Voucher.changeset(attrs)
    |> Repo.insert()
  end

  def update_voucher(%Voucher{} = voucher, attrs) do
    voucher
    |> Voucher.changeset(attrs)
    |> Repo.update()
  end

  def delete_voucher(%Voucher{} = voucher) do
    Repo.delete(voucher)
  end

  def change_voucher(%Voucher{} = voucher, attrs \\ %{}) do
    Voucher.changeset(voucher, attrs)
  end

  def list_voucher_with_paging(params) do
    from(v in Voucher)
    |> Eshop.Utils.Filter.apply(params)
    |> Eshop.Utils.Paginator.new(Repo, params)
  end
end
