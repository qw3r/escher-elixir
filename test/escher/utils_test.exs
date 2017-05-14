defmodule EscherTest.UtilsTest do
  use ExUnit.Case
  doctest Escher.Utils

  describe "Escher.Utils.format_datetime/1" do
    test "returns the formatted date and time" do
      assert Escher.Utils.format_datetime(~N[2017-05-12 23:34:45.5678]) == "20170512T233445Z"
    end
  end


  describe "Escher.Utils.format_date/1" do
    test "returns the formatted date" do
      assert Escher.Utils.format_date(~N[2017-05-12 23:34:45.5678]) == "20170512"
    end
  end


  describe "Escher.Utils.build_canonical_request/" do

#      {:in=>["GET", "/", [], "", [["Host", "host.foo.com"], ["Date", "Mon, 09 Sep 2011 23:36:00 GMT"], ["Authorization", "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20110909/us-east-1/host/aws4_request, SignedHeaders=date;host, Signature=b27ccfbfa7df52a200ff74193ca6e32d4b48b8856fab7ebf1c595d0670a7e470"]], ["date", "host"]]}
#      {:out=>["GET", "/", "", "date:Mon, 09 Sep 2011 23:36:00 GMT\nhost:host.foo.com", "", "date;host", "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"]}
#      {:in=>["GET", "/", [], "", [["Host", "host.foo.com"], ["Date", "Mon, 09 Sep 2011 23:36:00 GMT"], ["Authorization", "AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20110909/us-east-1/host/aws4_request, SignedHeaders=date;host, Signature=ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"]], ["date", "host"]]}
#      {:out=>["GET", "/", "", "date:Mon, 09 Sep 2011 23:36:00 GMT\nhost:host.foo.com", "", "date;host", "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"]}
#      {:in=>["POST", "/", [["@\#$%^", nil], ["+", "/,?><`\";:\\|][{}"]], "", [["Date", "Mon, 09 Sep 2011 23:36:00 GMT"], ["Host", "host.foo.com"]], ["date", "host"]]}
#      {:out=>["POST", "/", "%20=%2F%2C%3F%3E%3C%60%22%3B%3A%5C%7C%5D%5B%7B%7D&%40%23%24%25%5E=", "date:Mon, 09 Sep 2011 23:36:00 GMT\nhost:host.foo.com", "", "date;host", "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"]}
    @tag :skip
    test "returns canonical request" do
      actual = Escher.Utils.build_canonical_request()

      expected  = [
        "GET",
        "/",
        "",
        "date:Mon, 09 Sep 2011 23:36:00 GMT",
        "host:host.foo.com",
        "",
        "date;host",
        "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
      ]

      assert actual == expected
    end
  end
end
