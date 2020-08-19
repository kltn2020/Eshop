defmodule Eshop.Utils.StructHelper do
  def to_map(structs) when is_list(structs) do
    Enum.map(structs, &to_map/1)
  end

  def to_map(struct) when is_struct(struct) do
    struct
    |> Map.from_struct()
    |> to_map()
  end

  def to_map(map) when is_map(map) do
    map
    |> Enum.filter(fn
      # Skip association not loaded field
      {:__meta__, _value} -> false
      {_k, %Ecto.Association.NotLoaded{}} -> false
      _ -> true
    end)
    |> Enum.into(%{}, fn
      {key, %{__struct__: struct} = value} when struct in [Date, Time] ->
        {key, value}

      {key, %{__struct__: struct} = value} when struct in [DateTime] ->
        {key, Eshop.Utils.DateTime.local_default(value)}

      {key, %{__struct__: struct} = value} when struct in [NaiveDateTime] ->
        {key, value |> DateTime.from_naive!("Etc/UTC") |> Eshop.Utils.DateTime.local_default()}

      {key, %MapSet{map: map}} ->
        {key, Map.keys(map)}

      {key, values} when is_list(values) ->
        {key, to_map(values)}

      {key, value} when is_map(value) ->
        {key, to_map(value)}

      {key, value} ->
        {key, value}
    end)
  end

  def to_map(term) do
    term
  end
end
