defmodule Rauversion.EventsTest do
  use Rauversion.DataCase

  alias Rauversion.Events

  describe "event" do
    alias Rauversion.Events.Event

    import Rauversion.EventsFixtures

    @invalid_attrs %{age_requirement: nil, attendee_list_settings: nil, city: nil, country: nil, description: nil, eticket: nil, event: nil, event_capacity: nil, event_capacity_limit: nil, event_ends: nil, event_settings: nil, event_short_link: nil, event_start: nil, location: nil, online: nil, order_form: nil, postal: nil, private: nil, province: nil, slug: nil, state: nil, street: nil, street_number: nil, tax_rates_settings: nil, timezone: nil, title: nil, widget_button: nil, will_call: nil}

    test "list_event/0 returns all event" do
      event = event_fixture()
      assert Events.list_event() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{age_requirement: "some age_requirement", attendee_list_settings: %{}, city: "some city", country: "some country", description: "some description", eticket: true, event: "some event", event_capacity: true, event_capacity_limit: 42, event_ends: ~N[2022-08-12 17:38:00], event_settings: %{}, event_short_link: "some event_short_link", event_start: ~U[2022-08-12 17:38:00Z], location: "some location", online: true, order_form: %{}, postal: "some postal", private: true, province: "some province", slug: "some slug", state: "some state", street: "some street", street_number: "some street_number", tax_rates_settings: %{}, timezone: "some timezone", title: "some title", widget_button: %{}, will_call: true}

      assert {:ok, %Event{} = event} = Events.create_event(valid_attrs)
      assert event.age_requirement == "some age_requirement"
      assert event.attendee_list_settings == %{}
      assert event.city == "some city"
      assert event.country == "some country"
      assert event.description == "some description"
      assert event.eticket == true
      assert event.event == "some event"
      assert event.event_capacity == true
      assert event.event_capacity_limit == 42
      assert event.event_ends == ~N[2022-08-12 17:38:00]
      assert event.event_settings == %{}
      assert event.event_short_link == "some event_short_link"
      assert event.event_start == ~U[2022-08-12 17:38:00Z]
      assert event.location == "some location"
      assert event.online == true
      assert event.order_form == %{}
      assert event.postal == "some postal"
      assert event.private == true
      assert event.province == "some province"
      assert event.slug == "some slug"
      assert event.state == "some state"
      assert event.street == "some street"
      assert event.street_number == "some street_number"
      assert event.tax_rates_settings == %{}
      assert event.timezone == "some timezone"
      assert event.title == "some title"
      assert event.widget_button == %{}
      assert event.will_call == true
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      update_attrs = %{age_requirement: "some updated age_requirement", attendee_list_settings: %{}, city: "some updated city", country: "some updated country", description: "some updated description", eticket: false, event: "some updated event", event_capacity: false, event_capacity_limit: 43, event_ends: ~N[2022-08-13 17:38:00], event_settings: %{}, event_short_link: "some updated event_short_link", event_start: ~U[2022-08-13 17:38:00Z], location: "some updated location", online: false, order_form: %{}, postal: "some updated postal", private: false, province: "some updated province", slug: "some updated slug", state: "some updated state", street: "some updated street", street_number: "some updated street_number", tax_rates_settings: %{}, timezone: "some updated timezone", title: "some updated title", widget_button: %{}, will_call: false}

      assert {:ok, %Event{} = event} = Events.update_event(event, update_attrs)
      assert event.age_requirement == "some updated age_requirement"
      assert event.attendee_list_settings == %{}
      assert event.city == "some updated city"
      assert event.country == "some updated country"
      assert event.description == "some updated description"
      assert event.eticket == false
      assert event.event == "some updated event"
      assert event.event_capacity == false
      assert event.event_capacity_limit == 43
      assert event.event_ends == ~N[2022-08-13 17:38:00]
      assert event.event_settings == %{}
      assert event.event_short_link == "some updated event_short_link"
      assert event.event_start == ~U[2022-08-13 17:38:00Z]
      assert event.location == "some updated location"
      assert event.online == false
      assert event.order_form == %{}
      assert event.postal == "some updated postal"
      assert event.private == false
      assert event.province == "some updated province"
      assert event.slug == "some updated slug"
      assert event.state == "some updated state"
      assert event.street == "some updated street"
      assert event.street_number == "some updated street_number"
      assert event.tax_rates_settings == %{}
      assert event.timezone == "some updated timezone"
      assert event.title == "some updated title"
      assert event.widget_button == %{}
      assert event.will_call == false
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event == Events.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end
end
