defmodule Rauversion.TrackLikesTest do
  use Rauversion.DataCase

  alias Rauversion.TrackLikes

  describe "track_likes" do
    alias Rauversion.TrackLikes.TrackLike

    import Rauversion.{
      TrackLikesFixtures,
      # RepostsFixtures,
      TracksFixtures,
      AccountsFixtures
    }

    @invalid_attrs %{user_id: nil}

    setup do
      user = user_fixture()
      track = track_fixture(%{user_id: user.id})
      {:ok, %{user: user, track: track}}
    end

    test "list_track_likes/0 returns all track_likes", %{user: user, track: track} do
      track_like = track_like_fixture(%{user_id: user.id, track_id: track.id})
      assert TrackLikes.list_track_likes() == [track_like]
    end

    test "get_track_like!/1 returns the track_like with given id", %{user: user, track: track} do
      track_like = track_like_fixture(%{user_id: user.id, track_id: track.id})
      assert TrackLikes.get_track_like!(track_like.id) == track_like
    end

    test "create_track_like/1 with valid data creates a track_like", %{user: user, track: track} do
      valid_attrs = %{user_id: user.id, track_id: track.id}

      assert {:ok, %TrackLike{} = _track_like} = TrackLikes.create_track_like(valid_attrs)
    end

    test "create_track_like/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TrackLikes.create_track_like(@invalid_attrs)
    end

    test "update_track_like/2 with valid data updates the track_like", %{user: user, track: track} do
      track_like = track_like_fixture(%{user_id: user.id, track_id: track.id})
      update_attrs = %{}

      assert {:ok, %TrackLike{} = _track_like} =
               TrackLikes.update_track_like(track_like, update_attrs)
    end

    test "update_track_like/2 with invalid data returns error changeset", %{
      user: user,
      track: track
    } do
      track_like = track_like_fixture(%{user_id: user.id, track_id: track.id})

      assert {:error, %Ecto.Changeset{}} =
               TrackLikes.update_track_like(track_like, @invalid_attrs)

      assert track_like == TrackLikes.get_track_like!(track_like.id)
    end

    test "delete_track_like/1 deletes the track_like", %{user: user, track: track} do
      track_like = track_like_fixture(%{user_id: user.id, track_id: track.id})
      assert {:ok, %TrackLike{}} = TrackLikes.delete_track_like(track_like)
      assert_raise Ecto.NoResultsError, fn -> TrackLikes.get_track_like!(track_like.id) end
    end

    test "change_track_like/1 returns a track_like changeset", %{user: user, track: track} do
      track_like = track_like_fixture(%{user_id: user.id, track_id: track.id})
      assert %Ecto.Changeset{} = TrackLikes.change_track_like(track_like)
    end
  end
end
