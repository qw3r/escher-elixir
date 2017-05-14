defmodule Escher do

  def sign_url!(url, %Escher.Credentials{key_id: key_id, secret: secret}, expire \\ 86400) when is_binary(url) do
    IO.puts([key_id, secret, expire])
    url
  end

end
