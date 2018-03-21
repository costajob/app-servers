defmodule PlugServer.Mixfile do
  use Mix.Project

  def project do
    [app: :server,
     version: "1.1.0",
     elixir: "~> 1.5",
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:cowboy, :plug],
     mod: {App, []},
     env: [cowboy_port: 9292]]
  end

  defp deps do
   [{:cowboy, "~> 1.1.0"},
    {:plug, "~> 1.5"}]
  end
end
