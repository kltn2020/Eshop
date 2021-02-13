defmodule EshopCore.Identity.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :role, :string
    field :verify, :boolean
    field :token, :string
    field :token_expired_at, :naive_datetime

    pow_user_fields()

    has_one(:cart, EshopCore.Shopping.Cart)
    has_many(:addresses, EshopCore.Checkout.Address)

    timestamps()
  end

  @default_fields [
    :id,
    :inserted_at,
    :updated_at
  ]

  def changeset(user, attrs) do
    user
    |> cast(attrs, __MODULE__.__schema__(:fields) -- @default_fields)
    |> pow_changeset(attrs)
    |> put_verify_data()
  end

  def verify_changeset(user, attrs) do
    user
    |> cast(attrs, __MODULE__.__schema__(:fields) -- @default_fields)
  end

  defp put_verify_data(%Ecto.Changeset{valid?: true} = changeset) do
    changeset
    |> put_change(:token, EshopCore.Utils.Nanoid.gen_nano_id(6))
    |> put_change(
      :token_expired_at,
      NaiveDateTime.local_now() |> NaiveDateTime.add(1 * 24 * 3600)
    )
  end

  defp put_verify_data(changeset), do: changeset
end
