defmodule EscherTest do
  @moduledoc false
  use ExUnit.Case
  doctest Escher

  describe "Escher.sign_url/2" do

    @tag :skip
    test "moo" do
#      credential_scope = "us-east-1/host/aws4_request"
#      now = ~N[2011-05-11 12:00:00]
      credentials = %Escher.Credentials{key_id: "th3K3y", secret: "very_secure"}
      url = "http://example.com/something?foo=bar&baz=barbaz"

      expected_query_parts = [
        {"foo", "bar"},
        {"baz", "barbaz"},
        {"X-Amz-Algorithm", "EMS-HMAC-SHA256"},
        {"X-EMS-Credentials", "th3K3y/20110511/us-east-1/host/aws4_request"},
        {"X-EMS-Date", "20110511T120000Z"},
        {"X-EMS-Expires", "123456"},
        {"X-EMS-SignedHeaders", "host"},
        {"X-EMS-Signature", "fbc9dbb91670e84d04ad2ae7505f4f52ab3ff9e192b8233feeae57e9022c2b67"},
      ]

      signed_uri = url |> Escher.sign_url!(credentials, 123_456) |> URI.parse
      query_parts = signed_uri.query |> URI.query_decoder |> Enum.to_list

      assert signed_uri.scheme == "http"
      assert signed_uri.host == "example.com"
      assert signed_uri.path == "/something"
      assert query_parts == expected_query_parts
    end
  end
end
