defmodule Eshop.Rating.Review do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reviews" do
    field :content, :string
    field :point, :integer

    timestamps()

    has_many(:replies, Eshop.Rating.Reply)

    belongs_to(:user, Eshop.Identity.User)
    belongs_to(:product, Eshop.Ecom.Product)
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
  def changeset(review, attrs) do
    review
    |> cast(attrs, __MODULE__.__schema__(:fields) -- @default_fields)
    |> validate_required(@required_fields)
  end
end
