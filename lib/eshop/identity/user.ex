defmodule Eshop.Identity.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    field :role, :string, default: "user"

    pow_user_fields()

    has_one(:cart, Eshop.Shopping.Cart)
    has_many(:addresses, Eshop.Checkout.Address)

    timestamps()
  end
end
