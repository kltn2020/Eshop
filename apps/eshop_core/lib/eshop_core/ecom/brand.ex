defmodule EshopCore.Ecom.Brand do
  use EshopCore, :model

  schema "brands" do
    field :name, :string

    timestamps()

    has_many(:products, EshopCore.Ecom.Product)
  end
end
