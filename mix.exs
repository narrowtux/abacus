defmodule Abacus.Mixfile do
  use Mix.Project

  def project do
    [app: :abacus,
     version: "0.4.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end
  
  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description do
    """
    Mathematical expression parser and evaluator in Elixir.






    Tags: math, parse, parser, eval
    """
  end

  defp package do
    [# These are the default files included in the package
     name: :abacus,
     files: ["lib", "mix.exs", "README*", "LICENSE*", "src"],
     maintainers: ["Moritz Schmale"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/narrowtux/abacus"}]
  end
end
