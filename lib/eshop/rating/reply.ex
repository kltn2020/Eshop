defmodule Eshop.Rating.Reply do
  use Ecto.Schema
  import Ecto.Changeset

  schema "replies" do
    field :content, :string

    timestamps()

    belongs_to(:user, Eshop.Identity.User)
    belongs_to(:review, Eshop.Rating.Review)
  end

  @default_fields [
    :id,
    :inserted_at,
    :updated_at
  ]

  @required_fields [
    :user_id,
    :review_id,
    :content
  ]
  @doc false
  def changeset(reply, attrs) do
    reply
    |> cast(attrs, __MODULE__.__schema__(:fields) -- @default_fields)
    |> validate_required(@required_fields)
  end
end