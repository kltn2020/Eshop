defmodule Eshop.Checkout.OrderLine do
  use Ecto.Schema
  import Ecto.Changeset

  schema "order_lines" do
    field :quantity, :integer
    field :price, :integer
    field :discount, :integer
    field :total, :integer

    timestamps()

    belongs_to(:product, Eshop.Ecom.Product)
    belongs_to(:order, Eshop.Checkout.Order)
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
