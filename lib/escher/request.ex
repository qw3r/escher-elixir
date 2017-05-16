defmodule Escher.Request do

  defstruct method: "GET", path: nil, params: %{}, headers: %{}, payload: nil


  def from_url(url) do
    uri = URI.parse(url)
    params = URI.decode_query(uri.query)
    headers = %{"host" => uri.host}

    %Escher.Request{path: uri.path, params: params, headers: headers}
  end

  def from_message(message) when is_binary(message) do
    lines = String.split(message, "\n")

    [method, path_with_query | _ ] = List.first(lines) |> String.split
    headers = Enum.slice(lines, 1..-3) |> Enum.map(&String.split(&1, ":", parts: 2) |> List.to_tuple) |> Map.new
    %URI{path: path, query: query} = URI.parse(path_with_query)
    params = URI.decode_query(query)

    %Escher.Request{method: method, path: path, params: params, headers: headers}
  end


  def canonicalize(%Escher.Request{method: method, path: path, params: params, headers: headers}) do
    sorted_query = params |> Enum.sort |> URI.encode_query
    sorted_headers = headers |> Enum.sort |> Enum.map(&Tuple.to_list(&1) |> Enum.join(":")) |> Enum.join("\n")

    "#{method}\n#{path}\n#{sorted_query}\n#{sorted_headers}\n"
  end

end