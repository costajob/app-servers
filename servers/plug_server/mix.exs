defmodule PlugServer.Mixfile do
  use Mix.Project

  def project do
    [app: :server,
     version: "1.2.0",
     elixir: "~> 1.8",
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:cowboy, :plug],
     mod: {App, []},
     env: [cowboy_port: 9292]]
  end

  defp deps do
   [{:cowboy, "~> 2.6"},
    {:plug, "~> 1.7"},
    {:plug_cowboy, "~> 2.0"}]
  end
end
