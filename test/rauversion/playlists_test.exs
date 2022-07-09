defmodule Rauversion.PlaylistsTest do
  use Rauversion.DataCase

  alias Rauversion.Playlists

  describe "playlists" do
    alias Rauversion.Playlists.Playlist

    import Rauversion.PlaylistsFixtures
    import Rauversion.AccountsFixtures
    import Rauversion.TracksFixtures

    @invalid_attrs %{description: nil, metadata: nil, slug: nil, title: nil}

    setup do
      user = user_fixture(%{username: "miki"})
      {:ok, %{user: user}}
    end

    test "list_playlists/0 returns all playlists", %{user: user} do
      playlist = playlist_fixture(%{user_id: user.id})

      list = Playlists.list_playlists() |> Rauversion.Repo.preload([:user, :track_playlists])
      assert list == [playlist]
    end

    test "get_playlist!/1 returns the playlist with given id", %{user: user} do
      playlist = playlist_fixture(%{user_id: user.id})

      record =
        Playlists.get_playlist!(playlist.id) |> Rauversion.Repo.preload([:user, :track_playlists])

      assert record == playlist
    end

    test "create_playlist/1 with valid data creates a playlist", %{user: user} do
      valid_attrs = %{
        user_id: user.id,
        description: "some description",
        metadata: %{},
        slug: "some slug",
        title: "some title"
      }

      assert {:ok, %{playlist_with_tracks: playlist}} = Playlists.create_playlist(valid_attrs)
      assert playlist.description == "some description"
      assert %Rauversion.Playlists.PlaylistMetadata{} = playlist.metadata
      assert playlist.slug == "some-title"
      assert playlist.title == "some title"
    end

    test "create_playlist/1 with invalid data returns error changeset" do
      assert {:error, :playlist, %Ecto.Changeset{}, %{}} =
               Playlists.create_playlist(@invalid_attrs)
    end

    test "update_playlist/2 with valid data updates the playlist", %{user: user} do
      playlist = playlist_fixture(%{user_id: user.id})

      update_attrs = %{
        description: "some updated description",
        metadata: %{},
        title: "some updated title"
      }

      assert {:ok, %Playlist{} = playlist} = Playlists.update_playlist(playlist, update_attrs)
      assert playlist.description == "some updated description"
      assert %Rauversion.Playlists.PlaylistMetadata{} = playlist.metadata
      assert playlist.slug == "some-title"
      assert playlist.title == "some updated title"
    end

    test "update_playlist/2 with invalid data returns error changeset", %{user: user} do
      playlist = playlist_fixture(%{user_id: user.id})
      assert {:error, %Ecto.Changeset{}} = Playlists.update_playlist(playlist, @invalid_attrs)
      assert playlist.id == Playlists.get_playlist!(playlist.id).id
    end

    test "delete_playlist/1 deletes the playlist", %{user: user} do
      playlist = playlist_fixture(%{user_id: user.id})
      assert {:ok, %Playlist{}} = Playlists.delete_playlist(playlist)
      assert_raise Ecto.NoResultsError, fn -> Playlists.get_playlist!(playlist.id) end
    end

    test "change_playlist/1 returns a playlist changeset", %{user: user} do
      playlist = playlist_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = Playlists.change_playlist(playlist)
    end

    test "create_tracks with track_playlists", %{user: user} do
      track = track_fixture(%{user_id: user.id})

      {:ok, result} =
        Playlists.create_playlist(%{
          title: "foo",
          user_id: user.id,
          track_playlists: [%{track_id: track.id}]
        })

      length(result.playlist_with_tracks.track_playlists) == 1
    end
  end
end
