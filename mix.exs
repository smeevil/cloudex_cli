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
      {:cloudex, git: "git@bitbucket.org:govannon/cloudex.git"}
    ]
  end
end
