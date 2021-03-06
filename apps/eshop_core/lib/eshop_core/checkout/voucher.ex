defmodule EshopCore.Checkout.Voucher do
  use EshopCore, :model

  schema "vouchers" do
    field :code, :string
    field :is_used, :boolean, default: false
    field :valid_from, :naive_datetime
    field :valid_to, :naive_datetime
    field :value, :integer

    timestamps()

    belongs_to(:category, EshopCore.Ecom.Category)
  end

  @default_fields [
    :id,
    :inserted_at,
    :updated_at
  ]

  @required_fields [
    :category_id,
    :valid_from,
    :valid_to
  ]

  @doc false
  def changeset(voucher, attrs) do
    voucher
    |> cast(attrs, __MODULE__.__schema__(:fields) -- @default_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:code)
  end
end
