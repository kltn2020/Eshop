defmodule EshopCore.Ecom.Category do
  use EshopCore, :model

  schema "categories" do
    field :name, :string

    timestamps()

    has_many(:product, EshopCore.Ecom.Product)
  end
end
