defmodule RauversionWeb.QrLive.Components.TicketComponent do
  use RauversionWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>

      <div class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0">
        <div class="relative transform overflow-hidden rounded-lg bg-white dark:bg-gray-900 dark:border-2 px-4 pt-5 pb-4 text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-md sm:p-6">
          <div class="flex flex-col">
            <div class="flex items-center space-x-2">

              <div class="flex self-auto items-center justify-center rounded-full bg-green-100 dark:bg-green-900">
                <div class="text-green-600 dark:text-green-400 flex items-center justify-center">
                  <%= raw @qr %>
                </div>
              </div>

              <div class="flex flex-col">
                <h3 class="text-lg font-medium leading-6 text-gray-900 dark:text-gray-100">
                  <%= @ticket.user.email %>
                </h3>
                <div class="flex">
                  <div class="p-2 bg-green-600 text-white block rounded-md">
                    <%= @ticket.state %>
                  </div>
                </div>

                <div class="p-2 flex flex-col space-y-2 text-white block">
                  <span class="text-bold">
                    TICKET: <%= @ticket.event_ticket.title %>
                  </span>
                  <span class="text-sm text-gray-600">
                    <%= Number.Currency.number_to_currency(@ticket.event_ticket.price, precision: Rauversion.Events.presicion_for_currency(@ticket.event_ticket.event)) %>
                    <%= @ticket.event_ticket.event.event_settings.ticket_currency %>
                  </span>
                </div>
              </div>
            </div>

            <div class="mt-3 text-center sm:mt-5">
              <h3 class="text-lg font-medium leading-6 text-gray-900 dark:text-gray-100">
                <%= @ticket.event_ticket.event.title %>
              </h3>
              <div class="mt-2 flex flex-col">
                <p class="text-sm text-gray-500 dark:text-gray-300">
                  <%= Rauversion.Events.event_dates(@ticket.event_ticket.event, @timezone) %>
                </p>

                <p class="text-sm text-gray-500 dark:text-gray-300 font-bold">
                  <%= @ticket.event_ticket.event.location %>
                </p>

                <%= if @ticket.checked_in do %>
                <p class="mt-4 text-sm text-brand-500 dark:text-brand-300 font-bold">
                  Checked in at: <%= @ticket.checked_in_at %>
                </p>
                <% end %>
              </div>
            </div>

          </div>
          <div class="mt-5 sm:mt-6">
            <%= live_redirect to: Routes.events_show_path(@socket, :show, @ticket.event_ticket.event.slug),
              class: "inline-flex w-full justify-center rounded-md border border-transparent bg-brand-600 dark:bg-brand-400 px-4 py-2 text-base font-medium text-white shadow-sm hover:bg-brand-700 dark:hover:bg-brand-300 focus:outline-none focus:ring-2 focus:ring-brand-500 dark:focus:ring-brand-600 focus:ring-offset-2 sm:text-sm" do %>
              <%= gettext("Go to Event") %>
            <% end %>
          </div>
        </div>
      </div>

      <% #= img_tag(Rauversion.Events.Event.variant_url(@ticket.event_ticket.event,  "cover", %{resize_to_limit: "500x500"}), class: "h-full w-full object-cover")  %>

    </div>

    """
  end
end
