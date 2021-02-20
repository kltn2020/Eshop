defmodule EshopCore.Ecom.Product do
  use EshopCore, :model

  schema "products" do
    field :battery_capacity, :string
    field :bluetooth, :string
    field :camera, :string
    field :cpu, :string
    field :description, :string
    field :discount_price, :integer
    field :display, :string
    field :display_resolution, :string
    field :display_screen, :string
    field :gpu, :string
    field :material, :string
    field :name, :string
    field :new_feature, :string
    field :os, :string
    field :ports, :string
    field :price, :integer
    field :ram, :string
    field :rating_avg, :float
    field :rating_count, :integer
    field :size, :string
    field :sku, :string
    field :sold, :integer
    field :storage, :string
    field :video, :string
    field :weight, :string
    field :wifi, :string
    field :is_available, :boolean
    field :images, {:array, :map}

    timestamps()

    belongs_to(:category, EshopCore.Ecom.Category)
    belongs_to(:brand, EshopCore.Ecom.Brand)
  end

  @default_fields [
    :id,
    :inserted_at,
    :updated_at
  ]

  @required_fields [
    :sku,
    :category_id,
    :brand_id,
    :images
  ]

  def changeset(product, attrs) do
    product
    |> cast(attrs, __MODULE__.__schema__(:fields) -- @default_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:sku)
  end
end
