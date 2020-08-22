defmodule Eshop.Ecom.Category do
  use Ecto.Schema

  schema "categories" do
    field :name, :string

    timestamps()

    has_many(:product, Eshop.Ecom.Product)
  end
end
