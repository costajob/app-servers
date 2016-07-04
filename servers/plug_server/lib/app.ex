defmodule App do
  use Application

  def start(_type, _args) do
    port = Application.get_env(:app, :cowboy_port, 9292)

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Server, [], port: port)
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
