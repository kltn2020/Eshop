defmodule EshopCore.Ecom.Favorite do
  use EshopCore, :model

  schema "favorites" do
    timestamps()

    belongs_to(:user, EshopCore.Identity.User)
    belongs_to(:product, EshopCore.Ecom.Product)
  end

  @default_fields [
    :id,
    :inserted_at,
    :updated_at
  ]

  @required_fields [
    :product_id,
    :user_id
  ]
  @doc false
  def changeset(favorite, attrs) do
    favorite
    |> cast(attrs, __MODULE__.__schema__(:fields) -- @default_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:product_id, :user_id])
  end
end
