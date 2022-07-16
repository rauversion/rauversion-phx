defmodule Rauversion.PlaylistLikesTest do
  use Rauversion.DataCase

  alias Rauversion.PlaylistLikes

  describe "playlist_likes" do
    alias Rauversion.PlaylistLikes.PlaylistLike

    import Rauversion.PlaylistLikesFixtures
    import Rauversion.PlaylistsFixtures
    import Rauversion.AccountsFixtures

    @invalid_attrs %{}

    setup do
      user = user_fixture(%{username: "miki"})
      playlist = playlist_fixture(%{user_id: user.id})
      {:ok, %{user: user, playlist: playlist}}
    end

    test "list_playlist_likes/0 returns all playlist_likes", %{user: user, playlist: playlist} do
      playlist_like = playlist_like_fixture(%{user_id: user.id, playlist_id: playlist.id})
      assert PlaylistLikes.list_playlist_likes() == [playlist_like]
    end

    test "get_playlist_like!/1 returns the playlist_like with given id", %{
      user: user,
      playlist: playlist
    } do
      playlist_like = playlist_like_fixture(%{user_id: user.id, playlist_id: playlist.id})
      assert PlaylistLikes.get_playlist_like!(playlist_like.id) == playlist_like
    end

    test "create_playlist_like/1 with valid data creates a playlist_like", %{
      user: user,
      playlist: playlist
    } do
      valid_attrs = %{user_id: user.id, playlist_id: playlist.id}

      assert {:ok, %PlaylistLike{} = _playlist_like} =
               PlaylistLikes.create_playlist_like(valid_attrs)
    end

    test "create_playlist_like/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PlaylistLikes.create_playlist_like(@invalid_attrs)
    end

    test "update_playlist_like/2 with valid data updates the playlist_like", %{
      user: user,
      playlist: playlist
    } do
      playlist_like = playlist_like_fixture(%{user_id: user.id, playlist_id: playlist.id})
      update_attrs = %{}

      assert {:ok, %PlaylistLike{} = _playlist_like} =
               PlaylistLikes.update_playlist_like(playlist_like, update_attrs)
    end

    test "update_playlist_like/2 with invalid data returns error changeset", %{
      user: user,
      playlist: playlist
    } do
      playlist_like = playlist_like_fixture(%{user_id: user.id, playlist_id: playlist.id})

      assert {:error, %Ecto.Changeset{}} =
               PlaylistLikes.update_playlist_like(playlist_like, %{user_id: nil})

      assert playlist_like == PlaylistLikes.get_playlist_like!(playlist_like.id)
    end

    test "delete_playlist_like/1 deletes the playlist_like", %{user: user, playlist: playlist} do
      playlist_like = playlist_like_fixture(%{user_id: user.id, playlist_id: playlist.id})
      assert {:ok, %PlaylistLike{}} = PlaylistLikes.delete_playlist_like(playlist_like)

      assert_raise Ecto.NoResultsError, fn ->
        PlaylistLikes.get_playlist_like!(playlist_like.id)
      end
    end

    test "change_playlist_like/1 returns a playlist_like changeset", %{
      user: user,
      playlist: playlist
    } do
      playlist_like = playlist_like_fixture(%{user_id: user.id, playlist_id: playlist.id})
      assert %Ecto.Changeset{} = PlaylistLikes.change_playlist_like(playlist_like)
    end
  end
end
