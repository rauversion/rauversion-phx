defmodule RauversionWeb.PageController do
  use RauversionWeb, :controller

  def index(conn, _params) do
    conn =
      conn
      |> assign(:tracks, list_tracks(1))
      |> assign(:playlists, list_playlists(1))

    render(conn, "index.html")
  end

  defp list_tracks(page) do
    Rauversion.Tracks.list_public_tracks()
    |> Rauversion.Tracks.with_processed()
    |> Rauversion.Repo.paginate(page: page, page_size: 5)
  end

  defp list_playlists(page) do
    Rauversion.Playlists.list_public_playlists()
    |> Rauversion.Repo.paginate(page: page, page_size: 5)
  end
end
