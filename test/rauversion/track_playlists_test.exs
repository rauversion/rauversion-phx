defmodule Rauversion.TrackPlaylistsTest do
  use Rauversion.DataCase

  alias Rauversion.TrackPlaylists

  describe "track_playlists" do
    alias Rauversion.TrackPlaylists.TrackPlaylist

    import Rauversion.TrackPlaylistsFixtures
    import Rauversion.TracksFixtures
    import Rauversion.PlaylistsFixtures
    import Rauversion.AccountsFixtures

    @invalid_attrs %{}

    setup do
      user = user_fixture()
      playlist = playlist_fixture(%{user_id: user.id})
      track = track_fixture(%{user_id: user.id})
      {:ok, %{track: track, playlist: playlist}}
    end

    test "list_track_playlists/0 returns all track_playlists", %{track: track, playlist: playlist} do
      track_playlist = track_playlist_fixture(%{track_id: track.id, playlist_id: playlist.id})
      assert TrackPlaylists.list_track_playlists() == [track_playlist]
    end

    test "get_track_playlist!/1 returns the track_playlist with given id", %{
      track: track,
      playlist: playlist
    } do
      track_playlist = track_playlist_fixture(%{track_id: track.id, playlist_id: playlist.id})
      assert TrackPlaylists.get_track_playlist!(track_playlist.id) == track_playlist
    end

    test "create_track_playlist/1 with valid data creates a track_playlist", %{
      track: track,
      playlist: playlist
    } do
      valid_attrs = %{track_id: track.id, playlist_id: playlist.id}

      assert {:ok, %TrackPlaylist{}} = TrackPlaylists.create_track_playlist(valid_attrs)
    end

    test "create_track_playlist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TrackPlaylists.create_track_playlist(@invalid_attrs)
    end

    test "update_track_playlist/2 with valid data updates the track_playlist", %{
      track: track,
      playlist: playlist
    } do
      track_playlist = track_playlist_fixture(%{track_id: track.id, playlist_id: playlist.id})
      update_attrs = %{}

      assert {:ok, %TrackPlaylist{}} =
               TrackPlaylists.update_track_playlist(track_playlist, update_attrs)
    end

    test "update_track_playlist/2 with invalid data returns error changeset", %{
      track: track,
      playlist: playlist
    } do
      track_playlist = track_playlist_fixture(%{track_id: track.id, playlist_id: playlist.id})

      assert {:error, %Ecto.Changeset{}} =
               TrackPlaylists.update_track_playlist(track_playlist, %{track_id: nil})

      assert track_playlist == TrackPlaylists.get_track_playlist!(track_playlist.id)
    end

    test "delete_track_playlist/1 deletes the track_playlist", %{track: track, playlist: playlist} do
      track_playlist = track_playlist_fixture(%{track_id: track.id, playlist_id: playlist.id})
      assert {:ok, %TrackPlaylist{}} = TrackPlaylists.delete_track_playlist(track_playlist)

      assert_raise Ecto.NoResultsError, fn ->
        TrackPlaylists.get_track_playlist!(track_playlist.id)
      end
    end

    test "change_track_playlist/1 returns a track_playlist changeset", %{
      track: track,
      playlist: playlist
    } do
      track_playlist = track_playlist_fixture(%{track_id: track.id, playlist_id: playlist.id})
      assert %Ecto.Changeset{} = TrackPlaylists.change_track_playlist(track_playlist)
    end
  end
end
