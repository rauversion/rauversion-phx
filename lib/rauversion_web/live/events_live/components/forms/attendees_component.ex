defmodule RauversionWeb.Live.EventsLive.Components.AttendeesComponent do
  use RauversionWeb, :live_component

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:attendees, list_posts(assigns.event))}
  end

  defp list_posts(event) do
    Rauversion.Events.list_tickets(event)
    # Events.list_event() |> Repo.preload(user: :avatar_blob)
  end

  def render(assigns) do
    ~H"""
      <div class="px-4 sm:px-6 lg:px-8 w-full">
        <div class="sm:flex sm:items-center">
          <div class="sm:flex-auto">
            <h1 class="text-xl font-semibold text-gray-900 dark:text-gray-100">Users</h1>
            <p class="mt-2 text-sm text-gray-700 dark:text-gray-300">A list of all the users in your account including their name, title, email and role.</p>
          </div>
          <div class="mt-4 sm:mt-0 sm:ml-16 sm:flex-none">
            <button type="button" class="inline-flex items-center justify-center rounded-md border border-transparent bg-brand-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:ring-offset-2 sm:w-auto">Add user</button>
          </div>
        </div>
        <div class="-mx-4 mt-8 overflow-hidden shadow ring-1 ring-black ring-opacity-5 sm:-mx-6 md:mx-0 md:rounded-lg">
          <table class="min-w-full divide-y divide-gray-300 dark:divide-gray-700">
            <thead class="bg-gray-50 dark:bg-gray-800">
              <tr>
                <th scope="col" class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 dark:text-gray-100 sm:pl-6">Name</th>
                <th scope="col" class="hidden px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-gray-100 lg:table-cell">Price</th>
                <th scope="col" class="hidden px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-gray-100 sm:table-cell">Email</th>
                <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-gray-100">Status</th>
                <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-gray-100">Checked in</th>
                <th scope="col" class="relative py-3.5 pl-3 pr-4 sm:pr-6">
                  <span class="sr-only">Edit</span>
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
                      <dd class="mt-1 truncate text-gray-700 dark:text-gray-300"><%= ticket.state %></dd>
                      <dt class="sr-only sm:hidden">Email</dt>
                      <dd class="mt-1 truncate text-gray-500 sm:hidden"><%= ticket.user.email %></dd>
                    </dl>
                  </td>
                  <td class="hidden px-3 py-4 text-sm text-gray-500 dark:text-gray-300 lg:table-cell">
                    <%= Number.Currency.number_to_currency(ticket.event_ticket.price) %>
                    <% #= ticket.event_ticket.currency %>
                  </td>
                  <td class="hidden px-3 py-4 text-sm text-gray-500 dark:text-gray-300 sm:table-cell"><%= ticket.user.email %></td>
                  <td class="px-3 py-4 text-sm text-gray-500 dark:text-gray-300"><%= ticket.state %></td>
                  <td class="px-3 py-4 text-sm text-gray-500 dark:text-gray-300"><%= ticket.checked_in_at %></td>
                  <td class="py-4 pl-3 pr-4 text-right text-sm font-medium sm:pr-6">
                    <%= live_redirect "view", to: Rauversion.PurchasedTickets.url_for_ticket(ticket) %>
                    <a href="#" class="text-brand-600 hover:text-brand-900">Refund<span class="sr-only"></span></a>
                  </td>
                </tr>
              <% end %>
            </tbody>
          </table>
        </div>
      </div>
    """
  end
end
