defmodule EshopCore.Ecom.Brand do
  use Ecto.Schema

  schema "brands" do
    field :name, :string

    timestamps()

    has_many(:products, EshopCore.Ecom.Product)
  end
end
