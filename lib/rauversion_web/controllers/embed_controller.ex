defmodule RauversionWeb.EmbedController do
  use RauversionWeb, :controller

  def show(conn, %{"track_id" => track_id}) do
    track = Rauversion.Tracks.get_public_track!(track_id) |> Rauversion.Repo.preload(:user)

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

  def oembed_show(conn, %{"track_id" => track_id, "format" => "json"}) do
    track = Rauversion.Tracks.get_public_track!(track_id) |> Rauversion.Repo.preload(:user)

    conn =
      conn
      |> assign(:track, track)

    case track do
      nil ->
        conn |> send_resp(404, "This track is private or not found")

      _ ->
        json(conn, data_for_oembed_track(conn, track))
    end
  end

  def oembed_private_show(conn, %{"track_id" => track_id, "format" => "json"}) do
    track = Rauversion.Tracks.find_by_signed_id!(track_id) |> Rauversion.Repo.preload(:user)

    conn =
      conn
      |> assign(:track, track)

    case track do
      nil ->
        conn |> send_resp(404, "This track is private or not found")

      _ ->
        json(conn, data_for_oembed_track(conn, track))
    end
  end

  def private(conn, %{"track_id" => signed_track_id}) do
    track =
      Rauversion.Tracks.find_by_signed_id!(signed_track_id) |> Rauversion.Repo.preload(:user)

    conn =
      conn
      |> assign(:track, track)
      |> delete_resp_header("x-frame-options")

    case track do
      nil -> conn |> send_resp(404, "This track is private or not found")
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

  defp data_for_oembed_track(conn, track) do
    url =
      Application.get_env(:rauversion, :domain) <>
        Routes.embed_path(conn, :private, Rauversion.Tracks.signed_id(track))

    %{
      version: 1,
      type: "rich",
      provider_name: "Rauversion",
      provider_url: Application.get_env(:rauversion, :domain),
      height: 450,
      width: "100%",
      title: "#{track.title} by #{track.user.username}",
      description: "",
      thumbnail_url: Rauversion.Tracks.variant_url(track, "cover", %{resize_to_limit: "360x360"}),
      html: "#{Rauversion.Tracks.iframe_code_string(url, track)}",
      # "<iframe width=\"100%\" height=\"450\" scrolling=\"no\" frameborder=\"no\" src=\"https://w.soundcloud.com/player/?visual=true&url=https%3A%2F%2Fapi.soundcloud.com%2Fplaylists%2F1002882931&show_artwork=true\"></iframe>",
      author_name: track.user.username,
      author_url: Routes.profile_index_path(conn, :index, track.user)
    }
  end
end
