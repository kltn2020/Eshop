defmodule Eshop.Checkout.OrderStatus do
  def processing, do: "processing"
  def shipping, do: "shipping"
  def completed, do: "completed"
  def cancelled, do: "cancelled"

  def enum,
    do: [
      "processing",
      "shipping",
      "completed",
      "cancelled"
    ]
end

defmodule Eshop.Checkout.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :discount, :integer
    field :order_date, :naive_datetime
    field :status, :string, default: Eshop.Checkout.OrderStatus.processing()
    field :total, :integer

    timestamps()

    belongs_to(:user, Eshop.Identity.User)
    belongs_to(:voucher, Eshop.Checkout.Voucher)
    belongs_to(:address, Eshop.Checkout.Address)
    has_many(:lines, Eshop.Checkout.OrderLine)
  end

  @default_fields [
    :id,
    :inserted_at,
    :updated_at
  ]

  @required_fields [
    :lines,
    :user_id,
    :address_id
  ]

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, __MODULE__.__schema__(:fields) -- @default_fields)
    |> validate_required(@required_fields)
    |> put_change(:order_date, NaiveDateTime.local_now())
    |> cast_assoc(:lines, required: true)
  end

  def update_changeset(order, attrs) do
    order
    |> cast(attrs, __MODULE__.__schema__(:fields) -- @default_fields)
    |> validate_required([:status])
  end
end
