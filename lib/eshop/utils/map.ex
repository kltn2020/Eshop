defmodule Eshop.Map do
  @moduledoc """
  obj =
    %{
      name: "abc",
      address: %{
        province: "1",
        ward: 2
      },
      email: [
        "a.com",
        "b.com"
      ]
    }

  query_map(obj, [:email, 0], "HCM")
  query_map(obj, [:address, province], "HCM")
  """
  def query_map(object, paths, default \\ nil) when is_map(object) or is_list(object) do
    Enum.reduce(paths, object, fn item, acc ->
      cond do
        is_nil(acc) -> nil
        is_integer(item) -> Enum.at(acc, item)
        is_atom(item) or is_binary(item) -> Map.get(acc, item)
        true -> raise ArgumentError, message: "Bad path"
      end
    end)
    |> Kernel.||(default)
  end
end
