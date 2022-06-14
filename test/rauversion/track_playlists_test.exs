defmodule Rauversion.TrackPlaylistsTest do
  use Rauversion.DataCase

  alias Rauversion.TrackPlaylists

  describe "track_playlists" do
    alias Rauversion.TrackPlaylists.TrackPlaylist

    import Rauversion.TrackPlaylistsFixtures

    @invalid_attrs %{}

    test "list_track_playlists/0 returns all track_playlists" do
      track_playlist = track_playlist_fixture()
      assert TrackPlaylists.list_track_playlists() == [track_playlist]
    end

    test "get_track_playlist!/1 returns the track_playlist with given id" do
      track_playlist = track_playlist_fixture()
      assert TrackPlaylists.get_track_playlist!(track_playlist.id) == track_playlist
    end

    test "create_track_playlist/1 with valid data creates a track_playlist" do
      valid_attrs = %{}

      assert {:ok, %TrackPlaylist{} = track_playlist} = TrackPlaylists.create_track_playlist(valid_attrs)
    end

    test "create_track_playlist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TrackPlaylists.create_track_playlist(@invalid_attrs)
    end

    test "update_track_playlist/2 with valid data updates the track_playlist" do
      track_playlist = track_playlist_fixture()
      update_attrs = %{}

      assert {:ok, %TrackPlaylist{} = track_playlist} = TrackPlaylists.update_track_playlist(track_playlist, update_attrs)
    end

    test "update_track_playlist/2 with invalid data returns error changeset" do
      track_playlist = track_playlist_fixture()
      assert {:error, %Ecto.Changeset{}} = TrackPlaylists.update_track_playlist(track_playlist, @invalid_attrs)
      assert track_playlist == TrackPlaylists.get_track_playlist!(track_playlist.id)
    end

    test "delete_track_playlist/1 deletes the track_playlist" do
      track_playlist = track_playlist_fixture()
      assert {:ok, %TrackPlaylist{}} = TrackPlaylists.delete_track_playlist(track_playlist)
      assert_raise Ecto.NoResultsError, fn -> TrackPlaylists.get_track_playlist!(track_playlist.id) end
    end

    test "change_track_playlist/1 returns a track_playlist changeset" do
      track_playlist = track_playlist_fixture()
      assert %Ecto.Changeset{} = TrackPlaylists.change_track_playlist(track_playlist)
    end
  end
end
