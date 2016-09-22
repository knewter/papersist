defmodule Papersist.Mixfile do
  use Mix.Project

  def project do
    [app: :papersist,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :exirc],
     mod: {Papersist, []}]
  end

  defp deps do
    [
      #{ :exirc, "~> 0.11.0" }
      { :exirc, github: "knewter/exirc", branch: "feature/parse_rpl_topic" }
    ]
  end
end
