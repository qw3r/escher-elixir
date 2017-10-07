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


  describe "Escher.Utils.build_string_to_sign/3" do
    test_case_runner = fn(test_case) ->
      if test_case.string_to_sign == nil do
        @tag :skip
      end
      test "returns the for #{test_case.name}" do
        expected = unquote(test_case.string_to_sign)
        actual = unquote(test_case.canonical_request)
          |> Escher.Utils.build_string_to_sign(~N[2011-09-09 23:36:00.5678], 'us-east-1/host/aws4_request')

        assert actual == expected
      end
    end

    Escher.TestHelper.aws_test_cases |> Enum.each(test_case_runner)
  end
end
