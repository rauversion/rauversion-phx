defmodule RauversionWeb.HlsController do
  use RauversionWeb, :controller

  alias Plug

  def index(conn, %{"filename" => filename}) do
    path = "output/#{filename}"

    if File.exists?(path) do
      conn |> Plug.Conn.send_file(200, path)
    else
      conn |> Plug.Conn.send_resp(404, "File not found")
    end
  end
end
