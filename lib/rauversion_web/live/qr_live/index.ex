defmodule RauversionWeb.QrLive.Index do
  use RauversionWeb, :live_view
  alias Rauversion.{PurchasedTickets, Repo}
  on_mount RauversionWeb.UserLiveAuth

  @impl true
  def mount(%{"signed_id" => signed_id}, _session, socket) do
    case get_ticket(signed_id) do
      nil ->
        {:ok, socket}

      ticket ->
        {:ok,
         assign(socket, :qr, gen_qr(ticket))
         |> assign(:ticket, ticket)
         |> assign_timezone()}
    end
  end

  defp assign_timezone(socket) do
    # || @default_timezone
    timezone = get_connect_params(socket)["timezone"]
    assign(socket, timezone: timezone)
  end

  @impl true
  def handle_event("check-in", %{}, socket = %{assigns: %{is_manager: is_manager}})
      when is_manager == true do
    case Rauversion.PurchasedTickets.check_in_purchased_ticket(socket.assigns.ticket) do
      {:ok, %Rauversion.PurchasedTickets.PurchasedTicket{} = ticket} ->
        {:noreply, assign(socket, :ticket, ticket)}

      _ ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("reenable", %{}, socket = %{assigns: %{is_manager: is_manager}})
      when is_manager == true do
    case Rauversion.PurchasedTickets.uncheck_in_purchased_ticket(socket.assigns.ticket) do
      {:ok, %Rauversion.PurchasedTickets.PurchasedTicket{} = ticket} ->
        {:noreply, assign(socket, :ticket, ticket)}

      _ ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Ticket")
    |> assign(
      :is_manager,
      check_manager(socket.assigns.current_user, socket.assigns.ticket.event_ticket.event.slug)
    )
  end

  def check_manager(user = %Rauversion.Accounts.User{}, event_id) do
    case Rauversion.Events.find_event_by_user(user, event_id) do
      %Rauversion.Events.Event{} -> true
      _ -> false
    end
  end

  def check_manager(_user = nil, _event) do
    false
  end

  defp get_ticket(id) do
    PurchasedTickets.find_by_signed_id!(id)
    |> Repo.preload([:user, [event_ticket: :event]])
  end

  defp gen_qr(ticket) do
    PurchasedTickets.url_for_ticket(ticket)
    |> QRCodeEx.encode()
    |> QRCodeEx.svg(width: 120)
  end
end
