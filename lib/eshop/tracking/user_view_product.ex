defmodule Eshop.Tracking.UserViewProduct do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_view_products" do
    field :view_at, :naive_datetime

    belongs_to(:viewer, Eshop.Identity.User, foreign_key: :user_id)
    belongs_to(:product, Eshop.Ecom.Product)

    timestamps()
  end

    @default_fields [
    :id,
    :inserted_at,
    :updated_at
  ]

  @required_fields [
    :user_id,
    :product_id
  ]

  @doc false
  def changeset(user_view_product, attrs) do
    user_view_product
    |> cast(attrs, __MODULE__.__schema__(:fields) -- @default_fields)
    |> validate_required(@required_fields)
  end
end
