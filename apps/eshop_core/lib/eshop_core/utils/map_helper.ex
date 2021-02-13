defmodule EshopCore.Utils.MapHelper do
  def clean_nil_values(m) when is_list(m) do
    m |> Enum.map(&clean_nil_values/1)
  end

  def clean_nil_values(m) when is_map(m) do
    Enum.reduce(m, %{}, fn
      {key, value}, acc when is_list(value) -> Map.put(acc, key, clean_nil_values(value))
      {_key, nil}, acc -> acc
      {key, value}, acc -> Map.put(acc, key, value)
    end)
  end

  def clean_nil_values(m), do: m

  def clean_empty_values(m) do
    Enum.reduce(m, %{}, fn
      {_key, ""}, acc -> acc
      {key, value}, acc -> Map.put(acc, key, value)
    end)
  end

  def to_db_map(items, model) when is_list(items) do
    Enum.map(items, &to_db_map(&1, model))
  end

  def to_db_map(item, model) when is_map(item) do
    Enum.reduce(item, [], fn {key, value}, acc ->
      key = key |> Phoenix.Naming.underscore() |> String.to_atom()
      if key in model.__schema__(:fields), do: [{key, value} | acc], else: acc
    end)
    |> Map.new()
  end

  def to_db_map(item, _model), do: item
end
