defmodule Escher do

  @doc """
  Signs the `url` using the `%Escher.Credentials`
  
      iex> Escher.sign_url!("https://my.service.api/", %Escher.Credentials{key_id: 'th3K3y', secret: 'very_secure'})
      "https://my.service.api/"
  """

  def sign_url!(url, %Escher.Credentials{key_id: _key_id, secret: _secret}, _expire \\ 86400) do
    # Escher.Request.from_url(url)
    url
  end

end
