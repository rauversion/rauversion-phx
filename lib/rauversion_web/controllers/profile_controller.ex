defmodule RauversionWeb.ProfileController do
  use RauversionWeb, :controller

  def show(conn, _params) do
    menu = [
      %{name: "All", url: "all_users_tracks_path(slug: name)"},
      %{name: "Popular tracks", url: "popular_users_tracks_path(slug: name)"},
      %{name: "Tracks", url: "users_track_path(name, tracks)"},
      %{name: "Albums", url: "users_albums_path(name)"},
      %{name: "Playlists", url: "users_playlists_path(name)"},
      %{name: "Reposts", url: "users_reposts_path(name)"}
    ]

    conn = conn |> assign(:data, menu)
    render(conn, "show.html")
  end
end
