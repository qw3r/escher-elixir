defmodule Escher.Utils do

  def format_datetime(datetime) do
    NaiveDateTime.to_iso8601(datetime)
    |> String.replace(~r/[:-]/, "")
    |> String.replace(~r/\.\d*$/, "Z")
  end


  def format_date(datetime) do
    format_datetime(datetime)
    |> String.replace(~r/T.*$/, "")
  end


  def build_string_to_sign(canonical_request, datetime, scope) do
    timestamp = format_datetime(datetime)
    date = format_date(datetime)
    hashed_canonical_request = hash_sha256(canonical_request)

    "AWS4-HMAC-SHA256\n#{timestamp}\n#{date}/#{scope}\n#{hashed_canonical_request}"
  end


  defp hash_sha256(data) do
    :crypto.hash(:sha256, data) |> Base.encode16(case: :lower)
  end

end
