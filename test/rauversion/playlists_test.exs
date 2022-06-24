defmodule Rauversion.PlaylistsTest do
  use Rauversion.DataCase

  alias Rauversion.Playlists

  describe "playlists" do
    alias Rauversion.Playlists.Playlist

    import Rauversion.PlaylistsFixtures
    import Rauversion.AccountsFixtures

    @invalid_attrs %{description: nil, metadata: nil, slug: nil, title: nil}

    setup do
      user = user_fixture()
      {:ok, %{user: user}}
    end

    test "list_playlists/0 returns all playlists", %{user: user} do
      playlist = playlist_fixture(%{user_id: user.id})
      assert Playlists.list_playlists() == [playlist]
    end

    test "get_playlist!/1 returns the playlist with given id", %{user: user} do
      playlist = playlist_fixture(%{user_id: user.id})
      assert Playlists.get_playlist!(playlist.id) == playlist
    end

    test "create_playlist/1 with valid data creates a playlist", %{user: user} do
      valid_attrs = %{
        user_id: user.id,
        description: "some description",
        metadata: %{},
        slug: "some slug",
        title: "some title"
      }

      assert {:ok, %Playlist{} = playlist} = Playlists.create_playlist(valid_attrs)
      assert playlist.description == "some description"
      assert playlist.metadata == %{}
      assert playlist.slug == "some slug"
      assert playlist.title == "some title"
    end

    test "create_playlist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Playlists.create_playlist(@invalid_attrs)
    end

    test "update_playlist/2 with valid data updates the playlist", %{user: user} do
      playlist = playlist_fixture(%{user_id: user.id})

      update_attrs = %{
        description: "some updated description",
        metadata: %{},
        slug: "some updated slug",
        title: "some updated title"
      }

      assert {:ok, %Playlist{} = playlist} = Playlists.update_playlist(playlist, update_attrs)
      assert playlist.description == "some updated description"
      assert playlist.metadata == %{}
      assert playlist.slug == "some updated slug"
      assert playlist.title == "some updated title"
    end

    test "update_playlist/2 with invalid data returns error changeset", %{user: user} do
      playlist = playlist_fixture(%{user_id: user.id})
      assert {:error, %Ecto.Changeset{}} = Playlists.update_playlist(playlist, @invalid_attrs)
      assert playlist == Playlists.get_playlist!(playlist.id)
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
  end
end
