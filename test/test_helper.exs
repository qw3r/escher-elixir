ExUnit.start()

defmodule Escher.TestCase do
  defstruct [:name, :request, :canonical_request, :signed_request, :string_to_sign]
end


defmodule Escher.TestHelper do
  @path "test/fixtures"

  def aws_test_cases do
    Path.wildcard(Path.join(@path, "aws4_test_suite/*.req"))
    |> Enum.map(&build_test_case/1)
  end


  defp build_test_case(req_file_name) do
    test_case = Path.rootname(req_file_name)

    %Escher.TestCase{
      name: test_case,
      request: read_file(test_case, "req"),
      canonical_request: read_file(test_case, "creq"),
      string_to_sign: read_file(test_case, "sts"),
      signed_request: read_file(test_case, "sreq")
    }
  end


  defp read_file(name, ext) do
    case File.read("#{name}.#{ext}") do
      {:ok, body} -> body
      {:error, _reason} -> nil
    end
  end
end
