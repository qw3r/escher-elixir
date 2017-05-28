defmodule Escher.Request do

  defstruct method: "GET", path: '/', params: [], headers: [], body: ""


  def from_url(url) do
    uri = URI.parse(url)
    params = URI.decode_query(uri.query)
    headers = %{"host" => uri.host}

    %Escher.Request{path: uri.path, params: params, headers: headers}
  end


  def from_raw_request(message) when is_binary(message) do
    lines = String.split(message, "\n")

    [method, path_with_query | _ ] = List.first(lines) |> String.split
    headers = Enum.slice(lines, 1..-3) |> Enum.map(&String.split(&1, ":", parts: 2) |> List.to_tuple)
    body = Enum.slice(lines, -1..-1) |> Enum.join

    %URI{path: path, query: query, fragment: fragment} = URI.parse("//" <> path_with_query)

    %Escher.Request{method: method, path: parse_path(path), params: parse_params(query, fragment), headers: headers, body: body}
  end


  def canonicalize(%Escher.Request{method: method, path: path, params: params, headers: headers, body: body}) do
    query_sorted = Enum.sort(params) |> URI.encode_query |> String.replace("+", "%20")
    headers_groupped = Enum.group_by(headers, fn {k, _} -> String.downcase(k) end, fn {_, v} -> String.trim(v) end)
    headers_signed = Map.keys(headers_groupped) |> Enum.join(";")
    headers_sorted = Enum.map(headers_groupped, fn {k, v} -> "#{k}:#{Enum.sort(v) |> Enum.join(",")}" end) |> Enum.join("\n")
    hashed_payload = Base.encode16(:crypto.hash(:sha256, body), case: :lower)

    "#{method}\n#{path}\n#{query_sorted}\n#{headers_sorted}\n\n#{headers_signed}\n#{hashed_payload}"
  end


  defp parse_params(nil), do: []
  defp parse_params(query), do: URI.encode(query) |> URI.query_decoder |> Enum.to_list
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