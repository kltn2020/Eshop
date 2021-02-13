defmodule EshopCore.Checkout.Address do
  use Ecto.Schema
  import Ecto.Changeset

  schema "addresses" do
    field :is_primary, :boolean, default: false
    field :locate, :string
    field :phone_number, :string

    timestamps()

    belongs_to(:user, EshopCore.Identity.User)
  end

  @default_fields [
    :id,
    :inserted_at,
    :updated_at
  ]

  @required_fields [
    :user_id,
    :locate
  ]

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, __MODULE__.__schema__(:fields) -- @default_fields)
    |> validate_required(@required_fields)
  end
end
