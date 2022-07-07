defmodule Rauversion.PlaylistLikesTest do
  use Rauversion.DataCase

  alias Rauversion.PlaylistLikes

  describe "playlist_likes" do
    alias Rauversion.PlaylistLikes.PlaylistLike

    import Rauversion.PlaylistLikesFixtures

    @invalid_attrs %{}

    test "list_playlist_likes/0 returns all playlist_likes" do
      playlist_like = playlist_like_fixture()
      assert PlaylistLikes.list_playlist_likes() == [playlist_like]
    end

    test "get_playlist_like!/1 returns the playlist_like with given id" do
      playlist_like = playlist_like_fixture()
      assert PlaylistLikes.get_playlist_like!(playlist_like.id) == playlist_like
    end

    test "create_playlist_like/1 with valid data creates a playlist_like" do
      valid_attrs = %{}

      assert {:ok, %PlaylistLike{} = playlist_like} = PlaylistLikes.create_playlist_like(valid_attrs)
    end

    test "create_playlist_like/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PlaylistLikes.create_playlist_like(@invalid_attrs)
    end

    test "update_playlist_like/2 with valid data updates the playlist_like" do
      playlist_like = playlist_like_fixture()
      update_attrs = %{}

      assert {:ok, %PlaylistLike{} = playlist_like} = PlaylistLikes.update_playlist_like(playlist_like, update_attrs)
    end

    test "update_playlist_like/2 with invalid data returns error changeset" do
      playlist_like = playlist_like_fixture()
      assert {:error, %Ecto.Changeset{}} = PlaylistLikes.update_playlist_like(playlist_like, @invalid_attrs)
      assert playlist_like == PlaylistLikes.get_playlist_like!(playlist_like.id)
    end

    test "delete_playlist_like/1 deletes the playlist_like" do
      playlist_like = playlist_like_fixture()
      assert {:ok, %PlaylistLike{}} = PlaylistLikes.delete_playlist_like(playlist_like)
      assert_raise Ecto.NoResultsError, fn -> PlaylistLikes.get_playlist_like!(playlist_like.id) end
    end

    test "change_playlist_like/1 returns a playlist_like changeset" do
      playlist_like = playlist_like_fixture()
      assert %Ecto.Changeset{} = PlaylistLikes.change_playlist_like(playlist_like)
    end
  end
end
