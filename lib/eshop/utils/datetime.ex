defmodule Eshop.Utils.DateTime do
  def local_default(datetime \\ nil)

  def local_default(%DateTime{} = datetime) do
    DateTime.shift_zone!(
      datetime,
      Eshop.Core.Constants.get_default_timezone(),
      Tzdata.TimeZoneDatabase
    )
  end

  def local_default(%NaiveDateTime{} = naive_datetime) do
    naive_datetime
    |> DateTime.from_naive!("Etc/UTC")
    |> local_default()
  end

  def local_default(nil) do
    DateTime.utc_now() |> local_default()
  end

  def format_default(datetime, format \\ "{0D}-{0M}-{YYYY} {h24}:{m}:{s}")

  def format_default(nil, _format), do: nil

  def format_default(datetime, format) do
    datetime
    |> local_default()
    |> Timex.format!(format)
  end

  def naive_to_iso8601(nil), do: nil

  def naive_to_iso8601(date) do
    date
    |> DateTime.from_naive!("Etc/UTC")
    |> DateTime.to_iso8601()
  end

  def day_begin_of_week(week_number, _year)
      when week_number < 0 or week_number > 51,
      do: {:error, "invalid week_number: #{inspect(week_number)}"}

  @doc """
  This function get date begining of week number

  Date.add(first_day_of_year, (week_number - 1) * 7 - 1 - 1)
  (week_number - 1) * 7 is number days of week
  Sub 1 is select begin week

  Example:
    Eshop.Utils.DateTime.day_begin_of_week(1, 2020) -> result: ~D[2019-12-30]
  """
  def day_begin_of_week(week_number, year) do
    case Date.new(year, 1, 1) do
      {:ok, first_day_of_year} ->
        Date.add(first_day_of_year, (week_number - 1) * 7 - 2)

      {:error, error} ->
        {:error, error}
    end
  end
end
