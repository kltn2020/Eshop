defmodule EshopCore.Checkout.OrderLine do
  use EshopCore, :model

  schema "order_lines" do
    field :quantity, :integer
    field :price, :integer
    field :discount, :integer
    field :total, :integer

    timestamps()

    belongs_to(:product, EshopCore.Ecom.Product)
    belongs_to(:order, EshopCore.Checkout.Order)
  end

  @default_fields [
    :id,
    :inserted_at,
    :updated_at
  ]

  @required_fields [
    # :product_id
    # :order_id
  ]

  @doc false
  def changeset(line, attrs) do
    line
    |> cast(attrs, __MODULE__.__schema__(:fields) -- @default_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:order)
  end
end
