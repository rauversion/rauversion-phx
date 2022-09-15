defmodule RauversionWeb.ProfileController do
  use RauversionWeb, :controller

  def show(conn, _params) do
    render(conn, "show.html")
  end
end
