defmodule Server do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/", do: send_resp(conn, 200, "Hello World!")
  match _, do: send_resp(conn, 404, "Opps!")
end
