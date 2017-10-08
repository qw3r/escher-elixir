defmodule Escher.Credentials do
  @moduledoc """
  Provides %Escher.Credentials{} struct for.. well.. Escher credentials
  """

  @enforce_keys [:key_id, :secret]
  defstruct [:key_id, :secret]
end
