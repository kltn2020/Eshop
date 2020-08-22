defmodule Eshop.Utils.Paginator do
  @moduledoc """
  Eshop.Utils.Paginator
  """
  import Ecto.Query, only: [from: 2]

  @default_values %{page: 1, size: 20}
  def default_values, do: @default_values

  @default_types %{
    page: :integer,
    size: :integer
  }
  def default_types, do: @default_types

  defstruct Map.to_list(@default_values)

  def __changeset__, do: @default_types

  def validate(changeset) do
    changeset
    |> Ecto.Changeset.validate_number(:page, greater_than_or_equal_to: 1)
    |> Ecto.Changeset.validate_number(:size, less_than_or_equal_to: 100)
    |> Ecto.Changeset.validate_number(:size, greater_than_or_equal_to: 1)
  end

  def changeset(model, params \\ %{}) do
    model
    |> Ecto.Changeset.cast(params, Map.keys(@default_values))
    |> validate()
  end

  def cast(params \\ %{}) do
    changeset(%__MODULE__{}, params) |> validate()
  end

  def new(query, repo, params) do
    changesetz = changeset(%__MODULE__{}, params)

    with {:ok, data} <- Eshop.Utils.Validator.check_and_apply_changes(changesetz) do
      total_entries = repo.aggregate(query, :count, :id)
      offset = data.size * (data.page - 1)
      entries = from(i in query, limit: ^data.size, offset: ^offset) |> repo.all()

      %{
        entries: entries,
        page: data.page,
        size: data.size,
        total_entries: total_entries,
        total_pages: Float.ceil(total_entries / data.size) |> round()
      }
    end
  end
end
