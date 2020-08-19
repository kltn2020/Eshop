defmodule Eshop.Ecom.Brand do
  use Ecto.Schema

  schema "brands" do
    field :name, :string

    timestamps()
  end
end
