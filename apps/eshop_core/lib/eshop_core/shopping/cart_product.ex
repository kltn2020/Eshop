defmodule EshopCore.Shopping.CartProduct do
  use EshopCore, :model

  schema "cart_products" do
    field :quantity, :integer
    field :active, :boolean

    timestamps()

    belongs_to(:product, EshopCore.Ecom.Product)
    belongs_to(:cart, EshopCore.Shopping.Cart)
  end

  @default_fields [
    :inserted_at,
    :updated_at
  ]

  @required_fields [
    :product_id,
    :cart_id
  ]

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, __MODULE__.__schema__(:fields) -- @default_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:cart_id, :product_id])
  end
end
