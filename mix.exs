defmodule Escher.Mixfile do
  use Mix.Project

  def project do
    [
      app: :escher,
      version: "0.3.0",
      elixir: ">= 1.4.0",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package(),
      description: description()
    ]
  end

  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    # [extra_applications: [:logger]]
    []
  end

  defp deps do
    [
      {:ex_doc, "~> 0.16", only: :dev}
    ]
  end

  defp description do
    """
    Elixir implementation of Escher Auth
    """
  end

  defp package do
    [
      maintainers: ["István Demeter"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/qw3r/escher-elixir"}
    ]
  end
end
