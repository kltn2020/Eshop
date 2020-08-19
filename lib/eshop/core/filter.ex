defmodule Eshop.Core.Filter do
  @moduledoc """
  Filters Ecto query results by params provided.

  Author: Vince Urag
  www.codesforbreakfast.com
  """

  import Ecto.Query

  @doc """
  Apply filter on multiple column

  if value is an array, filter will apply or condition. To use and condition, use `filter_and` instead
  """
  def apply(query, filters) when is_list(filters) or is_map(filters) do
    filters
    |> Enum.into(%{})
    |> Map.delete(:keyword)
    |> Enum.reduce(query, fn {key, val}, acc ->
      filter(acc, key, val)
    end)
  end

  @doc """
  Apply not filter on multiple column

  if value is an array, filter will apply or condition. To use and condition, use `filter_and` instead
  """
  @spec apply(Ecto.Query.t(), keyword() | map()) :: Ecto.Query.t()
  def filter_not(query, filters) when is_list(filters) or is_map(filters) do
    filters = Enum.into(filters, %{}) |> Map.delete(:keyword)

    dynamic_query =
      Enum.reduce(filters, false, fn {key, val}, acc ->
        d = _not(key, val)

        if d != false do
          dynamic([p], ^acc or ^d)
        else
          acc
        end
      end)

    dynamic_query = dynamic_query || true
    where(query, [q], ^dynamic_query)
  end

  @doc """
  Apply filter on single column

  If filter value is list, filter row that match any value in the list
  """
  @spec filter(Ecto.Query.t(), atom, list) :: Ecto.Query.t()
  def filter(query, fieldname, value) when is_binary(fieldname) do
    filter(query, String.to_atom(fieldname), value)
  end

  def filter(query, fieldname, values) when is_list(values) do
    dynamic_query = dynamic([q], field(q, ^fieldname) in ^values)

    query |> where(^dynamic_query)
  end

  def filter(query, fieldname, _value)
      when fieldname in [
             :load_with,
             :entries,
             :page,
             :size,
             :total,
             :limit,
             :max_id,
             :keyword,
             :q
           ] do
    query
  end

  def filter(query, fieldname, value) do
    dynamic_query = dynamic([q], field(q, ^fieldname) == ^value)
    query |> where(^dynamic_query)
  end

  defp _not(fieldname, values) when is_list(values) do
    dynamic([q], not (field(q, ^fieldname) in ^values))
  end

  defp _not(fieldname, value) do
    dynamic([q], field(q, ^fieldname) != ^value)
  end

  @doc """
  filter array columns which contains one of input value
  """
  def search_array(query, fieldname, values) when is_list(values) do
    dynamic_query =
      Enum.reduce(values, false, fn value, d_query ->
        dynamic([q], ^value in field(q, ^fieldname) or ^d_query)
      end)

    query |> where(^dynamic_query)
  end

  def search_array(query, fieldname, value) do
    search_array(query, fieldname, [value])
  end

  @doc """
  Search text on multiple column
  """
  def search(query, columns, value) when is_list(columns) do
    search_str = "%#{value}%"

    dynamic_query =
      Enum.reduce(columns, false, fn fieldname, d_query ->
        dynamic([q], ilike(field(q, ^fieldname), ^search_str) or ^d_query)
      end)

    query |> where(^dynamic_query)
  end

  def search(query, fieldname, value) do
    search(query, [fieldname], value)
  end

  def ft_search(query, fieldname, text) do
    dynamic_query = dynamic([q], fragment("? @@ to_tsquery(?)", field(q, ^fieldname), ^text))
    query |> where(^dynamic_query)
  end
end
