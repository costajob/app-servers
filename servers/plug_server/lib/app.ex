defmodule App do
  use Application

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(scheme: :http, plug: Server, options: [port: 9292])
    ]

    opts = [strategy: :one_for_one, name: App.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
