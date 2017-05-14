defmodule EscherTest.RequestTest do
  use ExUnit.Case

  describe "Escher.Utils.from_url/1" do
    test "returns an Escher.Request struct" do
      actual_request = Escher.Request.from_url("https://www.google.com/maps?zoom=1")

      expected_request = %Escher.Request{
        method: "GET",
        path: "/maps",
        params: %{"zoom" => "1"},
        headers: %{"host" => "www.google.com"},
        scheme: "https"
      }

      assert actual_request == expected_request
    end
  end


  describe "Escher.Utils.canonicalize/1" do
    test "returns the canonicalized request" do

# {:in=>["GET", "/", [], "", [["Host", "host.foo.com"], ["Date", "Mon, 09 Sep 2011 23:36:00 GMT"], ["Authorization", "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20110909/us-east-1/host/aws4_request, SignedHeaders=date;host, Signature=b27ccfbfa7df52a200ff74193ca6e32d4b48b8856fab7ebf1c595d0670a7e470"]], ["date", "host"]]}
# {:out=>["GET", "/", "", "date:Mon, 09 Sep 2011 23:36:00 GMT\nhost:host.foo.com", "", "date;host", "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"]}

      request = %Escher.Request{
        method: "GET",
        path: "/maps",
        params: %{"zoom" => "1"},
        headers: %{"host" => "www.google.com"},
        scheme: "https"
      }

      canonical_request = Escher.Request.canonicalize(request)

      assert canonical_request == "GET\n/maps\nzoom=1\nhost:www.google.com\n"
    end
  end
end
