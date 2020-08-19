defmodule Eshop.Ecom.Brand do
  use Ecto.Schema

  schema "brands" do
    field :name, :string

    timestamps()

    has_many(:products, Eshop.Ecom.Product)
  end
end
