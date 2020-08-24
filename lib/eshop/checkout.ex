defmodule Eshop.Checkout do
  import Ecto.Query, warn: false
  alias Eshop.Repo

  alias Eshop.Checkout.Voucher
  alias Eshop.Checkout.Address

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

  def list_addresses(params) do
    from(address in Address, order_by: [desc: :is_primary])
    |> Eshop.Utils.Filter.apply(params)
    |> Repo.all()
  end

  def get_address!(id), do: Repo.get!(Address, id)

  def create_address(attrs \\ %{}) do
    is_primary = Map.get(attrs, "is_primary")

    if is_primary do
      user_id = Map.get(attrs, "user_id")

      from(address in Address,
        where: address.user_id == ^user_id,
        update: [set: [is_primary: false]]
      )
      |> Repo.update_all([])
    end

    %Address{}
    |> Address.changeset(attrs)
    |> Repo.insert()
  end

  def update_address(%Address{} = address, attrs) do
    is_primary = Map.get(attrs, "is_primary")

    if is_primary do
      user_id = Map.get(attrs, "user_id")

      from(address in Address,
        where: address.user_id == ^user_id,
        update: [set: [is_primary: false]]
      )
      |> Repo.update_all([])
    end

    address
    |> Address.changeset(attrs)
    |> Repo.update()
  end

  def delete_address(%Address{} = address) do
    Repo.delete(address)
  end

  def change_address(%Address{} = address, attrs \\ %{}) do
    Address.changeset(address, attrs)
  end
end
