defmodule Escher.Credentials do
  @enforce_keys [:key_id, :secret]
  defstruct [:key_id, :secret]
end