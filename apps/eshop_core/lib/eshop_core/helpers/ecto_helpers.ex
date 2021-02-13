defmodule EshopCore.EctoHelpers do
  defmacro defenum(enum) do
    quote bind_quoted: [enum: enum] do
      def enum do
        unquote(enum)
      end

      for item <- enum do
        def unquote(:"#{item}")() do
          unquote(item)
        end
      end
    end
  end

  def cast_date_range([min, max] = _input) do
    {:ok,
     [
       Timex.parse!(min, "{YYYY}-{0M}-{0D}"),
       Timex.parse!(max, "{YYYY}-{0M}-{0D}")
     ]}
  end

  def cast_date_range(_), do: {:error, "Invalid date range params"}

  def cast_array_integer(input) do
    cast_string_array(input, :integer, ",")
  end

  def cast_array_string(input) do
    cast_string_array(input, :string)
  end

  def cast_string_array(input, type, separator \\ ",") do
    cond do
      is_binary(input) ->
        parts = String.split(input, separator)
        Ecto.Type.cast({:array, type}, parts)

      is_list(input) ->
        Ecto.Type.cast({:array, type}, input)

      true ->
        {:error, :invalid_params}
    end
  end
end
