defmodule Papersist.Mixfile do
  use Mix.Project

  def project do
    [app: :papersist,
     version: "0.3.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :exirc, :ibrowse, :gen_stage, :poison, :tesla, :conform],
     mod: {Papersist, []}]
  end

  defp deps do
    [
      { :exirc, github: "bitwalker/exirc" },
      { :tesla, "~> 0.5.0" },
      { :ibrowse, "~> 4.2" },
      { :poison, ">= 1.0.0" },
      { :gen_stage, "~> 0.4" },
      { :distillery, github: "bitwalker/distillery" },
      { :conform, github: "bitwalker/conform" }
    ]
  end
end
