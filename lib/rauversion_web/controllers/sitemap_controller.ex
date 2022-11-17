defmodule RauversionWeb.SitemapController do
  use RauversionWeb, :controller
  plug :put_layout, false
  alias Rauversion.{Repo, Tracks}

  def index(conn, _params) do
    tracks =
      Tracks.list_public_tracks()
      |> Tracks.latests()
      |> Tracks.limit_records(60)
      |> Repo.all()

    conn
    |> put_resp_content_type("text/xml")
    |> render("index.xml", tracks: tracks)
  end
end
