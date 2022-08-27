defmodule RauversionWeb.EventsLive.EventTicketsComponent do
  use RauversionWeb, :live_component
  alias Rauversion.PurchasedTickets
  alias Rauversion.PurchasedTickets.PurchasedTicket

  @impl true
  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:open, false)
      |> assign(:tickets, get_public_tickets(assigns.event))
      |> assign(
        :changeset,
        PurchasedTickets.change_purchased_ticket(%PurchasedTicket{})
      )
    }
  end

  def get_public_tickets(event) do
    event
    |> Ecto.assoc(:event_tickets)
    |> Rauversion.Repo.all()
    |> Enum.filter(fn x -> !x.settings.hidden end)
  end

  @impl true
  def handle_event("show-tickets", %{}, socket) do
    {:noreply, socket |> assign(:open, true)}
  end

  @impl true
  def handle_event("close-modal", %{}, socket) do
    {:noreply, socket |> assign(:open, false)}
  end

  @impl true
  def handle_event("validate", %{"purchased_ticket" => event_params}, socket) do
    changeset =
      %PurchasedTicket{}
      |> PurchasedTickets.change_purchased_ticket(event_params)
      |> Map.put(:action, :validate)

    # IO.inspect(changeset)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def render(assigns) do
    ~H"""
      <div class="hidden sm:mt-10 sm:flex lg:mt-0 lg:grow lg:basis-0 lg:justify-end">
        <a phx-click="show-tickets" phx-target={@myself} class="inline-flex justify-center rounded-2xl bg-brand-600 p-4 text-base font-semibold text-white hover:bg-brand-500 focus:outline-none focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-brand-500 active:text-white/70" href="#">
          <%= gettext("Get your tickets") %>
        </a>

        <%= if @open do %>
          <.modal close_handler={@myself}>
            <div class="px-4 sm:px-6 lg:px-8">
              <div class="mt-8 flex flex-col">
                <div class="-my-2 -mx-4 overflow-x-auto sm:-mx-6 lg:-mx-8">
                  <div class="inline-block min-w-full py-2 align-middle md:px-6 lg:px-8">
                    <div class="overflow-hidden shadow ring-1 ring-black ring-opacity-5 md:rounded-lg">
                      <table class="min-w-full divide-y divide-gray-300 dark:divide-gray-700">
                        <thead class="bg-gray-50-- dark:bg-gray-900--">

                          <tr>
                            <th scope="col" class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 dark:text-gray-100 sm:pl-6">Name</th>
                            <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-gray-100">Price</th>
                            <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-gray-100">QTY</th>
                          </tr>

                        </thead>

                        <tbody class="divide-y divide-gray-200 dark:divide-gray-900-- bg-white-- dark:bg-gray-800--">
                          <%= for ticket <- @tickets do %>
                            <tr>
                              <td class="whitespace-nowrap py-4 pl-4 pr-3 text-sm sm:pl-6">
                                <div class="flex items-center">
                                  <div class="ml-4">
                                    <div class="font-medium text-gray-900 dark:text-gray-100">
                                      <%= ticket.title %>
                                    </div>
                                    <div class="text-gray-500 dark:text-gray-400">
                                      <%= ticket.short_description %>
                                    </div>
                                  </div>
                                </div>
                              </td>
                              <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500 dark:text-gray-400">
                                <div class="text-gray-900 dark:text-gray-100 text-2xl">
                                  <%= Number.Currency.number_to_currency(ticket.price) %>
                                </div>
                              </td>
                              <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500 dark:text-gray-400">
                                <div class="flex justify-start items-center space-x-3">
                                  <.form let={f} for={@changeset}
                                    phx-change="validate"
                                    phx-target={@myself}
                                    phx-submit="save">
                                    <%= label f, :x %>
                                    <%= text_input f, :qty, class: "bg-gray-700 border rounded-sm", type: :number %>
                                    <%= submit "Save", class: "inline-flex items-center rounded-md border border-gray-300 dark:border-gray-700 bg-white dark:bg-black px-3 py-2 text-sm font-medium leading-4 text-gray-700 dark:text-gray-300 shadow-sm hover:bg-gray-50 dark:hover:bg-gray-900 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-30" %>
                                  </.form>
                                </div>
                              </td>
                            </tr>
                          <% end %>
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </.modal>
        <% end %>
    </div>
    """
  end
end
