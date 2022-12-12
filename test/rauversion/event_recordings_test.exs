defmodule Rauversion.EventRecordingsTest do
  use Rauversion.DataCase

  alias Rauversion.EventRecordings

  describe "event_recordings" do
    alias Rauversion.EventRecordings.EventRecording
    import Rauversion.EventsFixtures

    import Rauversion.EventRecordingsFixtures

    @invalid_attrs %{title: nil, properties: nil, type: nil, event_id: nil}

    test "list_event_recordings/0 returns all event_recordings" do
      event = event_fixture()
      event_recording = event_recording_fixture(%{event_id: event.id})
      assert EventRecordings.list_event_recordings() == [event_recording]
    end

    test "get_event_recording!/1 returns the event_recording with given id" do
      event = event_fixture()
      event_recording = event_recording_fixture(%{event_id: event.id})
      assert EventRecordings.get_event_recording!(event_recording.id) == event_recording
    end

    test "create_event_recording/1 with valid data creates a event_recording" do
      event = event_fixture()

      valid_attrs = %{
        title: "some name",
        properties: %{},
        type: "some type",
        event_id: event.id,
        description: "bla bla",
        iframe: "http://djdjdj.cl/fijdjd"
      }

      assert {:ok, %EventRecording{} = event_recording} =
               EventRecordings.create_event_recording(valid_attrs)

      assert event_recording.title == "some name"
      assert event_recording.properties == %{}
      assert event_recording.type == "some type"
    end

    test "create_event_recording/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = EventRecordings.create_event_recording(@invalid_attrs)
    end

    test "update_event_recording/2 with valid data updates the event_recording" do
      event = event_fixture()
      event_recording = event_recording_fixture(%{event_id: event.id})
      update_attrs = %{title: "some updated name", properties: %{}, type: "some updated type"}

      assert {:ok, %EventRecording{} = event_recording} =
               EventRecordings.update_event_recording(event_recording, update_attrs)

      assert event_recording.title == "some updated name"
      assert event_recording.properties == %{}
      assert event_recording.type == "some updated type"
    end

    test "update_event_recording/2 with invalid data returns error changeset" do
      event = event_fixture()
      event_recording = event_recording_fixture(%{event_id: event.id})

      assert {:error, %Ecto.Changeset{}} =
               EventRecordings.update_event_recording(event_recording, @invalid_attrs)

      assert event_recording == EventRecordings.get_event_recording!(event_recording.id)
    end

    test "delete_event_recording/1 deletes the event_recording" do
      event = event_fixture()
      event_recording = event_recording_fixture(%{event_id: event.id})
      assert {:ok, %EventRecording{}} = EventRecordings.delete_event_recording(event_recording)

      assert_raise Ecto.NoResultsError, fn ->
        EventRecordings.get_event_recording!(event_recording.id)
      end
    end

    test "change_event_recording/1 returns a event_recording changeset" do
      event = event_fixture()
      event_recording = event_recording_fixture(%{event_id: event.id})
      assert %Ecto.Changeset{} = EventRecordings.change_event_recording(event_recording)
    end
  end
end
