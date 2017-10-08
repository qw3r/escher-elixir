defmodule Escher.Utils do
  @moduledoc false

  def format_datetime(datetime) do
    datetime
    |> NaiveDateTime.to_iso8601
    |> String.replace(~r/[:-]/, "")
    |> String.replace(~r/\.\d*$/, "Z")
  end


  def format_date(datetime) do
    datetime
    |> format_datetime
    |> String.replace(~r/T.*$/, "")
  end


  def build_string_to_sign(canonical_request, datetime, scope) do
    timestamp = format_datetime(datetime)
    date = format_date(datetime)
    hashed_canonical_request = hash_sha256(canonical_request)

    "AWS4-HMAC-SHA256\n#{timestamp}\n#{date}/#{scope}\n#{hashed_canonical_request}"
  end


  defp hash_sha256(data) do
    :sha256
    |> :crypto.hash(data)
    |> Base.encode16(case: :lower)
  end

end
