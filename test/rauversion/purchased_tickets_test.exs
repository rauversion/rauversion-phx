defmodule Rauversion.PurchasedTicketsTest do
  use Rauversion.DataCase

  alias Rauversion.PurchasedTickets

  describe "purchased_tickets" do
    alias Rauversion.PurchasedTickets.PurchasedTicket

    import Rauversion.PurchasedTicketsFixtures
    import Rauversion.PurchaseOrdersFixtures
    import Rauversion.EventsFixtures
    import Rauversion.AccountsFixtures
    import Rauversion.EventTicketsFixtures

    @invalid_attrs %{data: nil, state: nil}

    test "list_purchased_tickets/0 returns all purchased_tickets" do
      event = event_fixture()
      user = user_fixture()
      event_ticket = event_ticket_fixture(%{event_id: event.id})

      event = Rauversion.Events.get_event!(event.id) |> Rauversion.Repo.preload(:event_tickets)

      order =
        purchase_order_fixture(%{
          user_id: user.id,
          data: [
            %{ticket_id: event_ticket.id, count: 2}
          ]
        })

      Rauversion.PurchaseOrders.generate_purchased_tickets(order)

      tickets = user |> Ecto.assoc(:purchased_tickets) |> Rauversion.Repo.all()

      assert PurchasedTickets.list_purchased_tickets() == tickets
    end

    test "get_purchased_ticket!/1 returns the purchased_ticket with given id" do
      event = event_fixture()
      user = user_fixture()
      event_ticket = event_ticket_fixture(%{event_id: event.id})

      order =
        purchase_order_fixture(%{
          user_id: user.id,
          data: [
            %{ticket_id: event_ticket.id, count: 1}
          ]
        })

      Rauversion.PurchaseOrders.generate_purchased_tickets(order)

      ticket = user |> Ecto.assoc(:purchased_tickets) |> Rauversion.Repo.one()

      assert PurchasedTickets.get_purchased_ticket!(ticket.id) == ticket
    end

    test "create_purchased_ticket/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               PurchasedTickets.create_purchased_ticket(@invalid_attrs)
    end

    @tag :skip
    test "update_purchased_ticket/2 with invalid data returns error changeset" do
      event = event_fixture()
      user = user_fixture()
      event_ticket = event_ticket_fixture()

      purchased_ticket =
        purchased_ticket_fixture(%{
          event_id: event.id,
          event_ticket_id: event_ticket.id,
          user_id: user.id
        })

      assert {:error, %Ecto.Changeset{}} =
               PurchasedTickets.update_purchased_ticket(purchased_ticket, @invalid_attrs)

      assert purchased_ticket == PurchasedTickets.get_purchased_ticket!(purchased_ticket.id)
    end

    @tag :skip
    test "delete_purchased_ticket/1 deletes the purchased_ticket" do
      event = event_fixture()
      user = user_fixture()
      event_ticket = event_ticket_fixture()

      purchased_ticket =
        purchased_ticket_fixture(%{
          event_id: event.id,
          event_ticket_id: event_ticket.id,
          user_id: user.id
        })

      assert {:ok, %PurchasedTicket{}} =
               PurchasedTickets.delete_purchased_ticket(purchased_ticket)

      assert_raise Ecto.NoResultsError, fn ->
        PurchasedTickets.get_purchased_ticket!(purchased_ticket.id)
      end
    end

    @tag :skip
    test "change_purchased_ticket/1 returns a purchased_ticket changeset" do
      event = event_fixture()
      user = user_fixture()
      event_ticket = event_ticket_fixture()

      purchased_ticket =
        purchased_ticket_fixture(%{
          event_id: event.id,
          event_ticket_id: event_ticket.id,
          user_id: user.id
        })

      assert %Ecto.Changeset{} = PurchasedTickets.change_purchased_ticket(purchased_ticket)
    end
  end
end
