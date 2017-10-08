defmodule Escher.Request do
  @moduledoc """
  Provides methods to convert URLs and raw-requests into %Escher.Request{} structs
  """

  defstruct method: "GET", path: '/', params: [], headers: [], body: "", scheme: nil


  def from_url(url) do
    uri = URI.parse(url)
    params = URI.decode_query(uri.query || "")
    headers = %{"host" => uri.host}

    %Escher.Request{path: uri.path, params: params, headers: headers, scheme: uri.scheme}
  end


  def from_raw_request(message) when is_binary(message) do
    lines = String.split(message, "\n")

    [method, path_with_query | _] = lines |> List.first |> String.split
    {path, params} = path_with_params(path_with_query)
    headers = lines |> Enum.slice(1..-3) |> Enum.map(&List.to_tuple(String.split(&1, ":", parts: 2)))
    body = lines |> Enum.slice(-1..-1) |> Enum.join

    %Escher.Request{method: method, path: path, params: params, headers: headers, body: body
    }
  end


  def canonicalize(%Escher.Request{method: method, path: path, params: params, headers: headers, body: body}) do
    query_sorted = params |> Enum.sort |> URI.encode_query |> String.replace("+", "%20")
    headers_groupped = Enum.group_by(headers, fn {k, _} -> String.downcase(k) end, fn {_, v} -> String.trim(v) end)
    headers_signed = headers_groupped |> Map.keys |> Enum.join(";")
    headers_sorted = headers_groupped
      |> Enum.map(fn {k, v} -> "#{k}:" <> Enum.join(Enum.sort(v), ",") end)
      |> Enum.join("\n")
    hashed_payload = Base.encode16(:crypto.hash(:sha256, body), case: :lower)

    "#{method}\n#{path}\n#{query_sorted}\n#{headers_sorted}\n\n#{headers_signed}\n#{hashed_payload}"
  end


  def build_string_to_sign(canonical_request) when is_binary(canonical_request) do
    canonical_request
  end


  defp path_with_params(path_with_query) do
    %URI{path: path, query: query, fragment: fragment} = URI.parse("//" <> path_with_query)

    {parse_path(path), parse_params(query, fragment)}
  end


  defp parse_params(nil), do: []
  defp parse_params(query), do: query |> URI.encode |> URI.query_decoder |> Enum.to_list
  defp parse_params(query, nil), do: parse_params(query)
  defp parse_params(query, fragment), do: parse_params("#{query}##{fragment}")


  defp parse_path(path) do
    normalized_path = Path.expand(path, "/")

    cond do
      normalized_path == "/" -> normalized_path
      String.ends_with?(path, "/") -> normalized_path <> "/"
      true -> normalized_path
    end
  end

end
