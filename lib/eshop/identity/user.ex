defmodule Eshop.Identity.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    field :role, :string, default: "user"

    pow_user_fields()

    timestamps()
  end
end
