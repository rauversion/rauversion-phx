defmodule Rauversion.EventHostsTest do
  use Rauversion.DataCase

  alias Rauversion.EventHosts

  describe "event_host" do
    alias Rauversion.EventHosts.EventHost

    import Rauversion.EventHostsFixtures
    import Rauversion.EventsFixtures

    @invalid_attrs %{description: nil, name: nil, event_id: nil}

    test "list_event_host/0 returns all event_host" do
      event = event_fixture()
      event_host = event_host_fixture(%{event_id: event.id})
      assert EventHosts.list_event_host() == [event_host]
    end

    test "get_event_host!/1 returns the event_host with given id" do
      event = event_fixture()
      event_host = event_host_fixture(%{event_id: event.id})
      assert EventHosts.get_event_host!(event_host.id) == event_host
    end

    test "create_event_host/1 with valid data creates a event_host" do
      event = event_fixture()
      valid_attrs = %{description: "some description", name: "some name", event_id: event.id}

      assert {:ok, %EventHost{} = event_host} = EventHosts.create_event_host(valid_attrs)
      assert event_host.description == "some description"
      assert event_host.name == "some name"
    end

    test "create_event_host/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = EventHosts.create_event_host(@invalid_attrs)
    end

    test "update_event_host/2 with valid data updates the event_host" do
      event = event_fixture()
      event_host = event_host_fixture(%{event_id: event.id})
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %EventHost{} = event_host} =
               EventHosts.update_event_host(event_host, update_attrs)

      assert event_host.description == "some updated description"
      assert event_host.name == "some updated name"
    end

    test "update_event_host/2 with invalid data returns error changeset" do
      event = event_fixture()
      event_host = event_host_fixture(%{event_id: event.id})

      assert {:error, %Ecto.Changeset{}} =
               EventHosts.update_event_host(event_host, @invalid_attrs)

      assert event_host == EventHosts.get_event_host!(event_host.id)
    end

    test "delete_event_host/1 deletes the event_host" do
      event = event_fixture()
      event_host = event_host_fixture(%{event_id: event.id})
      assert {:ok, %EventHost{}} = EventHosts.delete_event_host(event_host)
      assert_raise Ecto.NoResultsError, fn -> EventHosts.get_event_host!(event_host.id) end
    end

    test "change_event_host/1 returns a event_host changeset" do
      event = event_fixture()
      event_host = event_host_fixture(%{event_id: event.id})
      assert %Ecto.Changeset{} = EventHosts.change_event_host(event_host)
    end
  end
end
