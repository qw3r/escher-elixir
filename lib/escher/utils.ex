defmodule Escher.Utils do

  def format_datetime(datetime) do
    NaiveDateTime.to_iso8601(datetime)
    |> String.replace(~r/[:-]/, "")
    |> String.replace(~r/\.\d*$/, "Z")
  end


  def format_date(time) do
    format_datetime(time)
    |> String.replace(~r/T.*$/, "")
  end

end