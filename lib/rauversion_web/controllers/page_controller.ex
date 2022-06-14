defmodule RauversionWeb.PageController do
  use RauversionWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
