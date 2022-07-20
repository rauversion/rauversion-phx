defmodule RauversionWeb.EmbedController do
  use RauversionWeb, :controller

  def show(conn, %{"track_id" => track_id}) do
    track = Rauversion.Tracks.get_public_track!(track_id)

    conn =
      conn
      |> assign(:track, track)
      |> delete_resp_header("x-frame-options")

    case track do
      nil -> conn |> send_resp(404, "This track is private or not found")
      _ -> render(conn, "show.html")
    end
  end

  def private(conn, %{"track_id" => signed_track_id}) do
    track = Rauversion.Tracks.find_by_signed_id!(signed_track_id)

    conn =
      conn
      |> assign(:track, track)
      |> delete_resp_header("x-frame-options")

    case track do
      nil -> conn |> send_resp(404, "This track is private or not found")
      _ -> render(conn, "show.html")
    end
  end

  def show(conn, %{"playlist_id" => playlist_id}) do
    playlist = Rauversion.Playlists.get_public_playlist!(playlist_id)

    conn =
      conn
      |> assign(:playlist, playlist)
      |> delete_resp_header("x-frame-options")

    case playlist do
      nil -> conn |> send_resp(404, "This playlist is private or not found")
      _ -> render(conn, "show.html")
    end
  end

  def private(conn, %{"playlist_id" => playlist_id}) do
    playlist = Rauversion.Playlists.find_by_signed_id!(playlist_id)

    conn =
      conn
      |> assign(:playlist, playlist)
      |> delete_resp_header("x-frame-options")

    case playlist do
      nil -> conn |> send_resp(404, "This playlist is private or not found")
      _ -> render(conn, "show.html")
    end
  end
end
