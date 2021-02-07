defmodule Eshop.Settings.GeneralSetting do
  use Ecto.Schema
  import Ecto.Changeset

  schema "general_settings" do
    field :limit, :integer
    field :sender_email, :string

    timestamps()
  end

  @default_fields [
    :id,
    :inserted_at,
    :updated_at
  ]

  @required_fields []

  def changeset(setting, attrs) do
    setting
    |> cast(attrs, __MODULE__.__schema__(:fields) -- @default_fields)
    |> validate_required(@required_fields)
  end
end
