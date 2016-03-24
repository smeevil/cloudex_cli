defmodule CloudexCli.Mixfile do
  use Mix.Project

  def project do
    [app: :cloudex_cli,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: [main_module: CloudexCli],
     deps: deps]
  end

  def application do
    [applications: [:logger, :httpoison, :tzdata]]
  end

  defp deps do
    [
      {:cloudex, ">0.0.0"},
      {:tzdata, "== 0.1.8", override: true}, #need this specific version for ebuild, see https://github.com/bitwalker/timex/issues/86
    ]
  end
end
