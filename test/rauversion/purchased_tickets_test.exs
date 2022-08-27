defmodule Rauversion.PurchasedTicketsTest do
  use Rauversion.DataCase

  alias Rauversion.PurchasedTickets

  describe "purchased_tickets" do
    alias Rauversion.PurchasedTickets.PurchasedTicket

    import Rauversion.PurchasedTicketsFixtures

    @invalid_attrs %{data: nil, state: nil}

    test "list_purchased_tickets/0 returns all purchased_tickets" do
      purchased_ticket = purchased_ticket_fixture()
      assert PurchasedTickets.list_purchased_tickets() == [purchased_ticket]
    end

    test "get_purchased_ticket!/1 returns the purchased_ticket with given id" do
      purchased_ticket = purchased_ticket_fixture()
      assert PurchasedTickets.get_purchased_ticket!(purchased_ticket.id) == purchased_ticket
    end

    test "create_purchased_ticket/1 with valid data creates a purchased_ticket" do
      valid_attrs = %{data: %{}, state: "some state"}

      assert {:ok, %PurchasedTicket{} = purchased_ticket} = PurchasedTickets.create_purchased_ticket(valid_attrs)
      assert purchased_ticket.data == %{}
      assert purchased_ticket.state == "some state"
    end

    test "create_purchased_ticket/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PurchasedTickets.create_purchased_ticket(@invalid_attrs)
    end

    test "update_purchased_ticket/2 with valid data updates the purchased_ticket" do
      purchased_ticket = purchased_ticket_fixture()
      update_attrs = %{data: %{}, state: "some updated state"}

      assert {:ok, %PurchasedTicket{} = purchased_ticket} = PurchasedTickets.update_purchased_ticket(purchased_ticket, update_attrs)
      assert purchased_ticket.data == %{}
      assert purchased_ticket.state == "some updated state"
    end

    test "update_purchased_ticket/2 with invalid data returns error changeset" do
      purchased_ticket = purchased_ticket_fixture()
      assert {:error, %Ecto.Changeset{}} = PurchasedTickets.update_purchased_ticket(purchased_ticket, @invalid_attrs)
      assert purchased_ticket == PurchasedTickets.get_purchased_ticket!(purchased_ticket.id)
    end

    test "delete_purchased_ticket/1 deletes the purchased_ticket" do
      purchased_ticket = purchased_ticket_fixture()
      assert {:ok, %PurchasedTicket{}} = PurchasedTickets.delete_purchased_ticket(purchased_ticket)
      assert_raise Ecto.NoResultsError, fn -> PurchasedTickets.get_purchased_ticket!(purchased_ticket.id) end
    end

    test "change_purchased_ticket/1 returns a purchased_ticket changeset" do
      purchased_ticket = purchased_ticket_fixture()
      assert %Ecto.Changeset{} = PurchasedTickets.change_purchased_ticket(purchased_ticket)
    end
  end
end
