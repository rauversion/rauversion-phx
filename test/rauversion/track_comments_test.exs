defmodule Rauversion.TrackCommentsTest do
  use Rauversion.DataCase

  alias Rauversion.TrackComments

  describe "track_comments" do
    alias Rauversion.TrackComments.TrackComment

    import Rauversion.{
      # RepostsFixtures,
      TracksFixtures,
      AccountsFixtures,
      TrackCommentsFixtures
    }

    @invalid_attrs %{body: nil, state: nil, track_minute: nil}

    setup do
      Surgex.DatabaseCleaner.call(Rauversion.Repo)

      user = user_fixture(%{username: "miki"})
      track = track_fixture(%{user_id: user.id})
      {:ok, %{user: user, track: track}}
    end

    test "list_track_comments/0 returns all track_comments", %{user: user, track: track} do
      track_comment = track_comment_fixture(%{user_id: user.id, track_id: track.id})

      assert TrackComments.list_track_comments() == [track_comment]
    end

    test "get_track_comment!/1 returns the track_comment with given id", %{
      user: user,
      track: track
    } do
      track_comment = track_comment_fixture(%{user_id: user.id, track_id: track.id})
      assert TrackComments.get_track_comment!(track_comment.id) == track_comment
    end

    test "create_track_comment/1 with valid data creates a track_comment", %{
      user: user,
      track: track
    } do
      valid_attrs = %{
        body: "some body",
        state: "some state",
        track_minute: 42,
        user_id: user.id,
        track_id: track.id
      }

      assert {:ok, %TrackComment{} = track_comment} =
               TrackComments.create_track_comment(valid_attrs)

      assert track_comment.body == "some body"
      assert track_comment.state == "some state"
      assert track_comment.track_minute == 42
    end

    test "create_track_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TrackComments.create_track_comment(@invalid_attrs)
    end

    test "update_track_comment/2 with valid data updates the track_comment", %{
      user: user,
      track: track
    } do
      track_comment = track_comment_fixture(%{user_id: user.id, track_id: track.id})
      update_attrs = %{body: "some updated body", state: "some updated state", track_minute: 43}

      assert {:ok, %TrackComment{} = track_comment} =
               TrackComments.update_track_comment(track_comment, update_attrs)

      assert track_comment.body == "some updated body"
      assert track_comment.state == "some updated state"
      assert track_comment.track_minute == 43
    end

    test "update_track_comment/2 with invalid data returns error changeset", %{
      user: user,
      track: track
    } do
      track_comment = track_comment_fixture(%{user_id: user.id, track_id: track.id})

      assert {:error, %Ecto.Changeset{}} =
               TrackComments.update_track_comment(track_comment, @invalid_attrs)

      assert track_comment == TrackComments.get_track_comment!(track_comment.id)
    end

    test "delete_track_comment/1 deletes the track_comment", %{user: user, track: track} do
      track_comment = track_comment_fixture(%{user_id: user.id, track_id: track.id})
      assert {:ok, %TrackComment{}} = TrackComments.delete_track_comment(track_comment)

      assert_raise Ecto.NoResultsError, fn ->
        TrackComments.get_track_comment!(track_comment.id)
      end
    end

    test "change_track_comment/1 returns a track_comment changeset", %{user: user, track: track} do
      track_comment = track_comment_fixture(%{user_id: user.id, track_id: track.id})
      assert %Ecto.Changeset{} = TrackComments.change_track_comment(track_comment)
    end
  end
end
