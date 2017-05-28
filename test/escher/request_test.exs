defmodule EscherTest.RequestTest do
  use ExUnit.Case
  doctest Escher.Utils

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


  describe "Escher.Utils.from_raw_request/1" do
    test "returns an Escher.Request struct" do
      req = "GET /maps?zoom=1 HTTP/1.1\nDate:Mon, 09 Sep 2011 23:36:00 GMT\nHost:www.google.com\n\n"
      actual_request = Escher.Request.from_raw_request(req)

      expected_request = %Escher.Request{
        method: "GET",
        path: "/maps",
        params: [{"zoom", "1"}],
        headers: [{"Date", "Mon, 09 Sep 2011 23:36:00 GMT"}, {"Host", "www.google.com"}]
      }

      assert actual_request == expected_request
    end
  end


  test_case_runner = fn(test_case) ->
#    if String.ends_with?(test_case.name, ["get-slashes"]) do
#      @tag :skip
#    end
    test "Escher.Request.canonicalize/1 for #{test_case.name}" do
      expected = unquote(test_case.canonical_request)
      actual = unquote(test_case.request) |> Escher.Request.from_raw_request |> Escher.Request.canonicalize

      assert actual == expected
    end
  end

  Escher.TestHelper.aws_test_cases |> Enum.each(test_case_runner)

end
