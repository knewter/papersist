defmodule Papersist.Mixfile do
  use Mix.Project

  def project do
    [app: :papersist,
     version: "0.2.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :exirc, :ibrowse, :gen_stage, :poison, :tesla],
     mod: {Papersist, []}]
  end

  defp deps do
    [
      { :exirc, github: "bitwalker/exirc" },
      { :tesla, "~> 0.5.0" },
      { :ibrowse, "~> 4.2" },
      { :poison, ">= 1.0.0" },
      { :gen_stage, "~> 0.4" },
      { :distillery, "~> 0.10" }
    ]
  end
end
