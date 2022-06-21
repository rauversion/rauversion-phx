defmodule Rauversion.TracksTest do
  use Rauversion.DataCase

  alias Rauversion.Tracks

  describe "tracks" do
    alias Rauversion.Tracks.Track

    import Rauversion.TracksFixtures

    @invalid_attrs %{
      caption: nil,
      description: nil,
      metadata: nil,
      notification_settings: nil,
      private: nil,
      slug: nil,
      title: nil
    }

    test "list_tracks/0 returns all tracks" do
      track = track_fixture()
      assert Tracks.list_tracks() == [track]
    end

    test "get_track!/1 returns the track with given id" do
      track = track_fixture()
      assert Tracks.get_track!(track.id) == track
    end

    test "create_track/1 with valid data creates a track" do
      valid_attrs = %{
        caption: "some caption",
        description: "some description",
        metadata: %{},
        notification_settings: %{},
        private: true,
        slug: "some slug",
        title: "some title"
      }

      assert {:ok, %Track{} = track} = Tracks.create_track(valid_attrs)
      assert track.caption == "some caption"
      assert track.description == "some description"
      assert track.metadata == %{}
      assert track.notification_settings == %{}
      assert track.private == true
      assert track.slug == "some-title"
      assert track.title == "some title"
    end

    test "create_track/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracks.create_track(@invalid_attrs)
    end

    test "update_track/2 with valid data updates the track" do
      track = track_fixture()

      update_attrs = %{
        caption: "some updated caption",
        description: "some updated description",
        metadata: %{},
        notification_settings: %{},
        private: false,
        slug: "some updated slug",
        title: "some updated title"
      }

      assert {:ok, %Track{} = track} = Tracks.update_track(track, update_attrs)
      assert track.caption == "some updated caption"
      assert track.description == "some updated description"
      assert track.metadata == %{}
      assert track.notification_settings == %{}
      assert track.private == false
      assert track.slug == "some-title"
      assert track.title == "some updated title"
    end

    test "update_track/2 with valid file" do
      track = track_fixture()

      update_attrs = %{
        "audio" => [
          %{
            content_type: "audio/wav",
            filename: "audio.wav",
            path: "./test/files/audio.wav",
            size: 187_324_814
          }
        ]
      }

      assert {:ok, %Track{} = track} = Tracks.update_track(track, update_attrs)

      assert %{metadata: %{"peaks" => [_ | _]}} = Tracks.get_track!(track.id)
    end

    test "update_track/2 with invalid data returns error changeset" do
      track = track_fixture()
      assert {:error, %Ecto.Changeset{}} = Tracks.update_track(track, @invalid_attrs)
      assert track == Tracks.get_track!(track.id)
    end

    test "update_track/2 with changeset peaks" do
      track = track_fixture()

      assert {:ok, %Rauversion.Tracks.Track{}} =
               Tracks.update_track(track, %{metadata: %{peaks: [12, 3, 4, 5]}})

      assert %Rauversion.Tracks.Track{metadata: %{"peaks" => [12, 3, 4, 5]}} =
               Tracks.get_track!(track.id)
    end

    test "delete_track/1 deletes the track" do
      track = track_fixture()
      assert {:ok, %Track{}} = Tracks.delete_track(track)
      assert_raise Ecto.NoResultsError, fn -> Tracks.get_track!(track.id) end
    end

    test "change_track/1 returns a track changeset" do
      track = track_fixture()
      assert %Ecto.Changeset{} = Tracks.change_track(track)
    end
  end
end
