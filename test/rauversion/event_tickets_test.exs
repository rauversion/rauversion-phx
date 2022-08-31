defmodule Rauversion.EventTicketsTest do
  use Rauversion.DataCase

  alias Rauversion.EventTickets

  describe "event_tickets" do
    alias Rauversion.EventTickets.EventTicket

    import Rauversion.EventTicketsFixtures

    @invalid_attrs %{
      early_bird_price: nil,
      price: nil,
      qty: nil,
      selling_end: nil,
      selling_start: nil,
      settings: nil,
      short_description: nil,
      standard_price: nil,
      title: nil
    }

    test "list_event_tickets/0 returns all event_tickets" do
      event_ticket = event_ticket_fixture()
      assert EventTickets.list_event_tickets() == [event_ticket]
    end

    test "get_event_ticket!/1 returns the event_ticket with given id" do
      event_ticket = event_ticket_fixture()
      assert EventTickets.get_event_ticket!(event_ticket.id) == event_ticket
    end

    test "create_event_ticket/1 with valid data creates a event_ticket" do
      valid_attrs = %{
        early_bird_price: "120.5",
        price: "120.5",
        qty: 42,
        selling_end: ~U[2022-08-26 04:47:00Z],
        selling_start: ~U[2022-08-26 04:47:00Z],
        settings: %{},
        short_description: "some short_description",
        standard_price: "120.5",
        title: "some title"
      }

      assert {:ok, %EventTicket{} = event_ticket} = EventTickets.create_event_ticket(valid_attrs)
      assert event_ticket.early_bird_price == Decimal.new("120.5")
      assert event_ticket.price == Decimal.new("120.5")
      assert event_ticket.qty == 42
      assert event_ticket.selling_end == ~U[2022-08-26 04:47:00Z]
      assert event_ticket.selling_start == ~U[2022-08-26 04:47:00Z]
      assert %Rauversion.Events.Ticket{} = event_ticket.settings
      assert event_ticket.short_description == "some short_description"
      assert event_ticket.standard_price == Decimal.new("120.5")
      assert event_ticket.title == "some title"
    end

    test "create_event_ticket/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = EventTickets.create_event_ticket(@invalid_attrs)
    end

    test "update_event_ticket/2 with valid data updates the event_ticket" do
      event_ticket = event_ticket_fixture()

      update_attrs = %{
        early_bird_price: "456.7",
        price: "456.7",
        qty: 43,
        selling_end: ~U[2022-08-27 04:47:00Z],
        selling_start: ~U[2022-08-27 04:47:00Z],
        settings: %{},
        short_description: "some updated short_description",
        standard_price: "456.7",
        title: "some updated title"
      }

      assert {:ok, %EventTicket{} = event_ticket} =
               EventTickets.update_event_ticket(event_ticket, update_attrs)

      assert event_ticket.early_bird_price == Decimal.new("456.7")
      assert event_ticket.price == Decimal.new("456.7")
      assert event_ticket.qty == 43
      assert event_ticket.selling_end == ~U[2022-08-27 04:47:00Z]
      assert event_ticket.selling_start == ~U[2022-08-27 04:47:00Z]
      assert %Rauversion.Events.Ticket{} = event_ticket.settings
      assert event_ticket.short_description == "some updated short_description"
      assert event_ticket.standard_price == Decimal.new("456.7")
      assert event_ticket.title == "some updated title"
    end

    test "update_event_ticket/2 with invalid data returns error changeset" do
      event_ticket = event_ticket_fixture()

      assert {:error, %Ecto.Changeset{}} =
               EventTickets.update_event_ticket(event_ticket, @invalid_attrs)

      assert event_ticket == EventTickets.get_event_ticket!(event_ticket.id)
    end

    test "delete_event_ticket/1 deletes the event_ticket" do
      event_ticket = event_ticket_fixture()
      assert {:ok, %EventTicket{}} = EventTickets.delete_event_ticket(event_ticket)
      assert_raise Ecto.NoResultsError, fn -> EventTickets.get_event_ticket!(event_ticket.id) end
    end

    test "change_event_ticket/1 returns a event_ticket changeset" do
      event_ticket = event_ticket_fixture()
      assert %Ecto.Changeset{} = EventTickets.change_event_ticket(event_ticket)
    end
  end
end
