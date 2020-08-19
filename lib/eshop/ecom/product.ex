defmodule Eshop.Ecom.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :battery_capacity, :string
    field :bluetooth, :string
    field :camera, :string
    field :content, :string
    field :cpu, :string
    field :description, :string
    field :discount, :float
    field :display, :string
    field :display_resolution, :string
    field :display_screen, :string
    field :gpu, :string
    field :material, :string
    field :name, :string
    field :new_feature, :string
    field :os, :string
    field :ports, :string
    field :price, :float
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

    timestamps()

    belongs_to(:category, Eshop.Ecom.Category)
    belongs_to(:brand, Eshop.Ecom.Brand)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [
      :sku,
      :name,
      :price,
      :discount,
      :cpu,
      :gpu,
      :os,
      :ram,
      :storage,
      :new_feature,
      :display,
      :display_resolution,
      :display_screen,
      :camera,
      :video,
      :wifi,
      :bluetooth,
      :ports,
      :size,
      :weight,
      :material,
      :battery_capacity,
      :description,
      :content,
      :brand_id,
      :category_id
    ])
    |> validate_required([
      :sku,
      :name,
      :price,
      :discount,
      :cpu,
      :gpu,
      :os,
      :ram,
      :storage,
      :new_feature,
      :display,
      :display_resolution,
      :display_screen,
      :camera,
      :video,
      :wifi,
      :bluetooth,
      :ports,
      :size,
      :weight,
      :material,
      :battery_capacity,
      :description,
      :content,
      :brand_id,
      :category_id
    ])
  end
end
