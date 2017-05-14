defmodule Escher.Request do

  defstruct method: "GET", path: nil, params: %{}, headers: %{}, payload: nil, scheme: nil


  def from_url(url) do
    uri = URI.parse(url)
    params = URI.decode_query(uri.query)
    headers = %{"host" => uri.host}

    %Escher.Request{path: uri.path, scheme: uri.scheme, params: params, headers: headers}
  end


  def canonicalize(%Escher.Request{method: method, path: path, params: params, headers: headers}) do
    sorted_query = params |> Enum.sort |> URI.encode_query
    sorted_headers = headers |> Enum.sort |> Enum.map(&Tuple.to_list(&1) |> Enum.join(":")) |> Enum.join("\n")

    "#{method}\n#{path}\n#{sorted_query}\n#{sorted_headers}\n"
  end

end