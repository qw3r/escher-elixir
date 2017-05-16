defmodule EscherTest.RequestTest do
  use ExUnit.Case

  describe "Escher.Utils.from_url/1" do
    test "returns an Escher.Request struct" do
      actual_request = Escher.Request.from_url("https://www.google.com/maps?zoom=1")

      expected_request = %Escher.Request{
        method: "GET",
        path: "/maps",
        params: %{"zoom" => "1"},
        headers: %{"host" => "www.google.com"}
      }

      assert actual_request == expected_request
    end
  end


  describe "Escher.Utils.from_message/1" do
    test "returns an Escher.Request struct" do
      req = "GET /maps?zoom=1 HTTP/1.1\nDate:Mon, 09 Sep 2011 23:36:00 GMT\nHost:www.google.com\n\n"
      actual_request = Escher.Request.from_message(req)

      expected_request = %Escher.Request{
        method: "GET",
        path: "/maps",
        params: %{"zoom" => "1"},
        headers: %{"Host" => "www.google.com", "Date" => "Mon, 09 Sep 2011 23:36:00 GMT"}
      }

      assert actual_request == expected_request
    end
  end


  describe "Escher.Utils.canonicalize/1" do
    test "returns the canonicalized request" do
      request = %Escher.Request{
        method: "GET",
        path: "/maps",
        params: %{"zoom" => "1"},
        headers: %{"host" => "www.google.com"},
      }

      canonical_request = Escher.Request.canonicalize(request)

      assert canonical_request == "GET\n/maps\nzoom=1\nhost:www.google.com\n"

    end
  end


#  Escher.TestHelper.aws_test_cases
#  |> Enum.each(fn(%Escher.TestCase{}) ->
#    test "for #{input}" do
#      assert Mymodule.myfunction(unquote(input)) == unquote(expected_output)
#    end
#  end
#
#
#  defp test_case(%Escher.TestCase{name: name}) do
#    describe name do
#      test "canonicalize" do
#
#        asset Escher.Request.
#      end
#    end
#  end


end
