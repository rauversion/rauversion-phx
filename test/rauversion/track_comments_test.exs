defmodule Rauversion.TrackCommentsTest do
  use Rauversion.DataCase

  alias Rauversion.TrackComments

  describe "track_comments" do
    alias Rauversion.TrackComments.TrackComment

    import Rauversion.TrackCommentsFixtures

    @invalid_attrs %{body: nil, state: nil, track_minute: nil}

    test "list_track_comments/0 returns all track_comments" do
      track_comment = track_comment_fixture()
      assert TrackComments.list_track_comments() == [track_comment]
    end

    test "get_track_comment!/1 returns the track_comment with given id" do
      track_comment = track_comment_fixture()
      assert TrackComments.get_track_comment!(track_comment.id) == track_comment
    end

    test "create_track_comment/1 with valid data creates a track_comment" do
      valid_attrs = %{body: "some body", state: "some state", track_minute: 42}

      assert {:ok, %TrackComment{} = track_comment} = TrackComments.create_track_comment(valid_attrs)
      assert track_comment.body == "some body"
      assert track_comment.state == "some state"
      assert track_comment.track_minute == 42
    end

    test "create_track_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TrackComments.create_track_comment(@invalid_attrs)
    end

    test "update_track_comment/2 with valid data updates the track_comment" do
      track_comment = track_comment_fixture()
      update_attrs = %{body: "some updated body", state: "some updated state", track_minute: 43}

      assert {:ok, %TrackComment{} = track_comment} = TrackComments.update_track_comment(track_comment, update_attrs)
      assert track_comment.body == "some updated body"
      assert track_comment.state == "some updated state"
      assert track_comment.track_minute == 43
    end

    test "update_track_comment/2 with invalid data returns error changeset" do
      track_comment = track_comment_fixture()
      assert {:error, %Ecto.Changeset{}} = TrackComments.update_track_comment(track_comment, @invalid_attrs)
      assert track_comment == TrackComments.get_track_comment!(track_comment.id)
    end

    test "delete_track_comment/1 deletes the track_comment" do
      track_comment = track_comment_fixture()
      assert {:ok, %TrackComment{}} = TrackComments.delete_track_comment(track_comment)
      assert_raise Ecto.NoResultsError, fn -> TrackComments.get_track_comment!(track_comment.id) end
    end

    test "change_track_comment/1 returns a track_comment changeset" do
      track_comment = track_comment_fixture()
      assert %Ecto.Changeset{} = TrackComments.change_track_comment(track_comment)
    end
  end
end
