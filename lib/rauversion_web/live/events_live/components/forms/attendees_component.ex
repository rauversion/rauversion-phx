defmodule RauversionWeb.Live.EventsLive.Components.AttendeesComponent do
  use RauversionWeb, :live_component
  alias Rauversion.Events.InviteTicketForm
  alias Rauversion.Accounts
  alias Rauversion.Accounts.User

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:attendees, list_posts(assigns.event))
     |> assign(:open_modal, false)}
  end

  defp list_posts(event) do
    Rauversion.Events.list_tickets(event)
    # Events.list_event() |> Repo.preload(user: :avatar_blob)
  end

  def new_invitation_changeset(%InviteTicketForm{} = invitation, attrs \\ %{}) do
    invitation
    |> InviteTicketForm.changeset(attrs)
  end

  @impl true
  def handle_event("validate", %{"invite_ticket_form" => event_params}, socket) do
    changeset =
      new_invitation_changeset(%InviteTicketForm{}, event_params)
      |> Map.put(:action, :validate)

    # IO.inspect(changeset)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("open_modal", %{"value" => ""}, socket) do
    {:noreply,
     assign(socket, :open_modal, true)
     |> assign(:invitation_changeset, new_invitation_changeset(%InviteTicketForm{}))}
  end

  def handle_event("close-modal", _, socket) do
    {:noreply, assign(socket, :open_modal, false)}
  end

  def handle_event(
        "save",
        %{
          "invite_ticket_form" =>
            _params = %{"email" => email, "message" => message, "ticket_id" => ticket_id}
        },
        socket
      ) do
    with %User{} = user <- get_user_from_email(email),
         {:ok, result} <-
           Rauversion.PurchaseOrders.create_free_ticket_order(
             socket.assigns.event,
             ticket_id,
             user.id
           ),
         {:ok, _} <-
           Rauversion.PurchaseOrders.notify_purchased_order(
             result.purchase_order,
             message,
             socket.assigns.current_user,
             subject:
               gettext("Invitation for event: %{title}", %{title: socket.assigns.event.title}),
             event: socket.assigns.event
           ) do
      # IO.inspect(result)
      {:noreply,
       socket
       |> assign(:open_modal, false)
       |> assign(:status, :success)
       |> put_flash(:info, gettext("Invitation sent"))
       |> push_redirect(to: "/events/#{socket.assigns.event.slug}/edit/attendees")}

      # |> assign(:attendees, list_posts(socket.assigns.event))}
    else
      {:error, :purchase_order, changeset, %{}} ->
        {:noreply,
         socket
         |> put_flash(:error, "Fail to create chchc.")
         |> assign(:changeset, changeset)
         |> assign(:status, :error)}

      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(:error, "Failed to authenticate.")
         |> assign(:status, :error)}

      _any ->
        {:noreply,
         socket
         |> assign(:status, :error)}
    end

    # save_repost(socket, socket.assigns.action, repost_params)
  end

  def get_user_from_email(email) do
    case Rauversion.Accounts.get_user_by_email(email) do
      %User{} = user ->
        user

      nil ->
        case Accounts.invite_user(%User{}, %{email: email}) do
          {:ok, user} -> user
          _ -> {:error, "error on user invitation"}
        end
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="px-4 sm:px-6 lg:px-8 w-full">
      <div class="sm:flex sm:items-center">
        <div class="sm:flex-auto">
          <h1 class="text-xl font-semibold text-gray-900 dark:text-gray-100">
            <%= gettext("Users") %>
          </h1>
          <p class="mt-2 text-sm text-gray-700 dark:text-gray-300">
            <%= gettext(
              "A list of all the users in your account including their name, title, email and role."
            ) %>
          </p>
        </div>
        <div class="mt-4 sm:mt-0 sm:ml-16 sm:flex-none">
          <button
            type="button"
            phx-click="open_modal"
            phx-target={@myself}
            class="inline-flex items-center justify-center rounded-md border border-transparent bg-brand-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:ring-offset-2 sm:w-auto"
          >
            Add user
          </button>
        </div>
      </div>
      <div class="-mx-4 mt-8 overflow-hidden shadow ring-1 ring-black ring-opacity-5 sm:-mx-6 md:mx-0 md:rounded-lg">
        <table class="min-w-full divide-y divide-gray-300 dark:divide-gray-700">
          <thead class="bg-gray-50 dark:bg-gray-800">
            <tr>
              <th
                scope="col"
                class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 dark:text-gray-100 sm:pl-6"
              >
                Name
              </th>
              <th
                scope="col"
                class="hidden px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-gray-100 lg:table-cell"
              >
                Price
              </th>
              <th
                scope="col"
                class="hidden px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-gray-100 sm:table-cell"
              >
                Email
              </th>
              <th
                scope="col"
                class="hidden px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-gray-100 lg:table-cell"
              >
                Ticket
              </th>
              <th
                scope="col"
                class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-gray-100"
              >
                Status
              </th>
              <th
                scope="col"
                class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-gray-100"
              >
                Checked in
              </th>
              <th scope="col" class="relative py-3.5 pl-3 pr-4 sm:pr-6">
                <span class="sr-only"><%= gettext("Edit") %></span>
              </th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-200 dark:divide-gray-800 bg-white dark:bg-gray-900">
            <%= for ticket <- @attendees do %>
              <tr>
                <td class="w-full max-w-0 py-4 pl-4 pr-3 text-sm font-medium text-gray-900 dark:text-gray-100 sm:w-auto sm:max-w-none sm:pl-6">
                  <%= ticket.user.username %>
                  <dl class="font-normal lg:hidden">
                    <dt class="sr-only">Status</dt>
                    <dd class="mt-1 truncate text-gray-700 dark:text-gray-300">
                      <%= ticket.state %>
                    </dd>
                    <dt class="sr-only sm:hidden">Email</dt>
                    <dd class="mt-1 truncate text-gray-500 sm:hidden"><%= ticket.user.email %></dd>
                  </dl>
                </td>
                <td class="hidden px-3 py-4 text-sm text-gray-500 dark:text-gray-300 lg:table-cell">
                  <%= Number.Currency.number_to_currency(ticket.event_ticket.price) %>
                  <% # = ticket.event_ticket.currency %>
                </td>
                <td class="hidden px-3 py-4 text-sm text-gray-500 dark:text-gray-300 sm:table-cell">
                  <%= ticket.user.email %>
                </td>
                <td class="px-3 py-4 text-sm text-gray-500 dark:text-gray-300">
                  <%= ticket.event_ticket.title %>
                </td>
                <td class="px-3 py-4 text-sm text-gray-500 dark:text-gray-300">
                  <%= ticket.state %>
                </td>
                <td class="px-3 py-4 text-sm text-gray-500 dark:text-gray-300">
                  <%= ticket.checked_in_at %>
                </td>
                <td class="py-4 pl-3 pr-4 text-right text-sm font-medium sm:pr-6">
                  <.link navigate={Rauversion.PurchasedTickets.url_for_ticket(ticket)}>
                    view
                  </.link>
                  <a href="#" class="text-brand-600 hover:text-brand-900">
                    Refund<span class="sr-only"></span>
                  </a>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>

      <%= if @open_modal do %>
        <.modal close_handler={@myself}>
          <.live_component
            module={RauversionWeb.EventsLive.Components.Forms.InviteAttendeeForm}
            title="@page_title"
            action={:new}
            changeset={@invitation_changeset}
            id="invite-event-form"
            event={@event}
            target={@myself}
            current_user={@current_user}
          />
        </.modal>
      <% end %>
    </div>
    """
  end
end
