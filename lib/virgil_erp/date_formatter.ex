defmodule VirgilErp.DateFormatter do
  def generate_date_array(selected_date, week_offset) do
    selected_date = Date.add(selected_date, week_offset * 7)

    Enum.map(-3..3, fn offset ->
      selected_date
      |> Date.add(offset)
      |> format_date()
    end)
  end

  def generate_date_array(selected_date) do
    Enum.map(-3..3, fn offset ->
      selected_date
      |> Date.add(offset)
      |> format_date()
    end)
  end

  defp format_date(date) do
    day_abbr = Date.day_of_week(date) |> day_abbr()
    day_ordinal = date.day

    %{
      day: "#{day_abbr}",
      number: day_ordinal,
      day_number: day_abbr <> " " <> ordinal_suffix(day_ordinal),
      date: date
    }
  end

  defp day_abbr(1), do: "Mon"
  defp day_abbr(2), do: "Tue"
  defp day_abbr(3), do: "Wed"
  defp day_abbr(4), do: "Thu"
  defp day_abbr(5), do: "Fri"
  defp day_abbr(6), do: "Sat"
  defp day_abbr(7), do: "Sun"

  defp ordinal_suffix(day) when day in 11..13, do: "#{day}th"

  defp ordinal_suffix(day) do
    suffix =
      case rem(day, 10) do
        1 -> "st"
        2 -> "nd"
        3 -> "rd"
        _ -> "th"
      end

    "#{day}#{suffix}"
  end

  def get_month_and_year(date) do
    month_name = month_name(date.month)
    "#{month_name} #{date.year}"
  end

  defp month_name(1), do: "January"
  defp month_name(2), do: "February"
  defp month_name(3), do: "March"
  defp month_name(4), do: "April"
  defp month_name(5), do: "May"
  defp month_name(6), do: "June"
  defp month_name(7), do: "July"
  defp month_name(8), do: "August"
  defp month_name(9), do: "September"
  defp month_name(10), do: "October"
  defp month_name(11), do: "November"
  defp month_name(12), do: "December"

  def format_date_to_short(nil) do
  end

  def format_date_to_short(date) do
    Timex.format!(date, "{WDshort}, {Mshort} {D}, {YYYY}")
  end
end
