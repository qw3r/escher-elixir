defmodule EscherTest.RequestTest do
  @moduledoc false
  use ExUnit.Case
  doctest Escher.Request


  describe "Escher.Request.from_url/1" do
    data = [
      {
        "https://google.com/maps?zoom=1",
        %Escher.Request{
          method: "GET", path: "/maps", params: %{"zoom" => "1"},
          headers: %{"host" => "google.com"}, scheme: "https"
        }
      },
      {
        "http://google.com/maps",
        %Escher.Request{
          method: "GET", path: "/maps", params: %{},
          headers: %{"host" => "google.com"}, scheme: "http"}
      }
    ]
    for {url, expected_request} <- data do
      @url url
      @expected_request expected_request

      test "returns proper %Escher.Request{} for URL: #{@url}" do
        assert Escher.Request.from_url(@url) == @expected_request
      end
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


  describe "Escher.Request.canonicalize/1" do
    test_case_runner = fn(test_case) ->
      test "returns with the canonicalized request (#{test_case.name})" do
        expected = unquote(test_case.canonical_request)
        actual = unquote(test_case.request) |> Escher.Request.from_raw_request |> Escher.Request.canonicalize

        assert actual == expected
      end
    end

    Escher.TestHelper.aws_test_cases |> Enum.each(test_case_runner)
  end
end
