defmodule Escher do

  @doc ~S"""
  Signs the `url` using the `%Escher.Credentials`

      iex> Escher.sign_url!("https://my.service.api/", %Escher.Credentials{key_id: 'muu_key', secret: '42'})
      "https://my.service.api/"
  """

  def sign_url!(url, %Escher.Credentials{key_id: _key_id, secret: _secret}, _expire \\ 86400) do
#    Escher.Request.from_url(url)
    url
  end

end
