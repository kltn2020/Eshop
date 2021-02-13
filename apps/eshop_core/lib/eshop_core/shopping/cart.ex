defmodule EshopCore.Shopping.Cart do
  use Ecto.Schema
  import Ecto.Changeset

  schema "carts" do
    timestamps()

    has_many(:items, EshopCore.Shopping.CartProduct)

    belongs_to(:customer, EshopCore.Identity.User, foreign_key: :user_id)
  end

  @default_fields [
    :id,
    :inserted_at,
    :updated_at
  ]

  @required_fields [
    :user_id
  ]

  @doc false
  def changeset(cart, attrs) do
    cart
    |> cast(attrs, __MODULE__.__schema__(:fields) -- @default_fields)
    |> validate_required(@required_fields)
  end
end
