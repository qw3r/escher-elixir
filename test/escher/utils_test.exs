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

end
