defmodule Rauversion.TracksTest do
  use Rauversion.DataCase

  alias Rauversion.Tracks

  describe "tracks" do
    alias Rauversion.Tracks.Track
    import Rauversion.AccountsFixtures
    import Rauversion.TracksFixtures

    @invalid_attrs %{
      caption: nil,
      description: nil,
      metadata: nil,
      notification_settings: nil,
      private: false,
      slug: nil,
      title: nil
    }

    setup do
      Surgex.DatabaseCleaner.call(Rauversion.Repo)
      user = user_fixture()
      {:ok, %{user: user}}
    end

    test "list_tracks/0 returns all tracks", %{user: user} do
      track =
        track_fixture(%{user_id: user.id})
        |> Repo.preload([
          :cover_attachment,
          :cover_blob,
          :mp3_audio_attachment,
          :mp3_audio_blob,
          user: [:avatar_attachment]
        ])

      assert Tracks.list_tracks()
             |> Repo.all() == [track]
    end

    test "get_track!/1 returns the track with given id", %{user: user} do
      track = track_fixture(%{user_id: user.id})
      assert Tracks.get_track!(track.id) == track
    end

    test "create_track/1 with valid data creates a track", %{user: user} do
      valid_attrs = %{
        caption: "some caption",
        description: "some description",
        metadata: %{},
        notification_settings: %{},
        private: true,
        slug: "some slug",
        title: "some title",
        user_id: user.id
      }

      assert {:ok, %Track{} = track} = Tracks.create_track(valid_attrs)

      assert track.caption == "some caption"
      assert track.description == "some description"
      assert track.metadata == %Rauversion.Tracks.TrackMetadata{id: track.metadata.id}
      assert track.notification_settings == %{}
      assert track.private == true
      assert track.slug == "some-title"
      assert track.title == "some title"
    end

    test "create_track/1 with invalid data returns error changeset" do
      assert {:error, :insert, %Ecto.Changeset{}, %{}} = Tracks.create_track(@invalid_attrs)
    end

    test "update_track/2 with valid data updates the track", %{user: user} do
      track = track_fixture(%{user_id: user.id})

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
      assert track.metadata == %Rauversion.Tracks.TrackMetadata{id: track.metadata.id}
      assert track.notification_settings == %{}
      assert track.private == false
      assert track.slug == "some-title"
      assert track.title == "some updated title"
    end

    @tag skip: "this test is incomplete"
    test "update_track/2 with valid file", %{user: user} do
      track = track_fixture(%{user_id: user.id})

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

      assert %{metadata: %{peaks: [_ | _]}} = Tracks.get_track!(track.id)
    end

    test "update_track/2 with invalid data returns error changeset", %{user: user} do
      track = track_fixture(%{user_id: user.id})
      assert {:error, :insert, %Ecto.Changeset{}, %{}} = Tracks.update_track(track, @invalid_attrs)
      assert track == Tracks.get_track!(track.id)
    end

    test "update_track/2 with changeset peaks", %{user: user} do
      track = track_fixture(%{user_id: user.id})

      assert {:ok, %Rauversion.Tracks.Track{}} =
               Tracks.update_track(track, %{
                 metadata: %{id: track.metadata.id, peaks: [12, 3, 4, 5]}
               })

      assert %Rauversion.Tracks.Track{
               metadata: %{peaks: [12.0, 3.0, 4.0, 5.0]}
             } = Tracks.get_track!(track.id)

      track = Tracks.get_track!(track.id)

      assert {:ok, %Rauversion.Tracks.Track{}} =
               Tracks.update_track(track, %{
                 metadata: %{id: track.metadata.id, artist: "Zappa Frank"}
               })

      assert %Rauversion.Tracks.Track{
               metadata: %{artist: "Zappa Frank", peaks: [12.0, 3.0, 4.0, 5.0]}
             } = Tracks.get_track!(track.id)
    end

    test "delete_track/1 deletes the track", %{user: user} do
      track = track_fixture(%{user_id: user.id})
      assert {:ok, %Track{}} = Tracks.delete_track(track)
      assert_raise Ecto.NoResultsError, fn -> Tracks.get_track!(track.id) end
    end

    test "change_track/1 returns a track changeset", %{user: user} do
      track = track_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = Tracks.change_track(track)
    end
  end
end
