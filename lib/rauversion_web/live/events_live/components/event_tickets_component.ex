defmodule RauversionWeb.EventsLive.EventTicketsComponent do
  use RauversionWeb, :live_component
  alias Rauversion.{PurchaseOrders, Events}
  alias Rauversion.PurchaseOrders.{PurchaseOrder}

  @impl true
  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:open, false)
      |> assign(:result, 0)
      |> assign(:tickets, get_public_tickets(assigns.event))
      |> assign(:purchase, nil)
      |> assign(:status, nil)
      |> assign(
        :changeset,
        %PurchaseOrder{}
        |> PurchaseOrders.change_purchase_order(%{
          data:
            get_public_tickets(assigns.event)
            |> Enum.map(fn x -> %{ticket_id: x.id, count: 0} end)
        })

        # PurchasedTickets.change_purchased_ticket(%PurchasedTicket{})
      )
    }
  end

  def get_public_tickets(event) do
    event
    |> Events.public_event_tickets()
  end

  @impl true
  def handle_event("show-tickets", %{}, socket) do
    {:noreply, socket |> assign(:open, true)}
  end

  @impl true
  def handle_event("save", %{"purchase_order" => purchase_order}, socket) do
    if socket.assigns.changeset.valid? do
      with %{url: url, order: order_with_payment_id} <-
             order_session(socket.assigns.event, purchase_order, socket.assigns.current_user.id) do
        {:noreply,
         assign(socket, :purchase, order_with_payment_id)
         |> redirect(external: url)}
      else
        {:error, err} ->
          {:noreply, assign(socket, :status, err)}

        # nil -> {:error, ...} an example that we can match here too
        _ ->
          {:noreply, assign(socket, :status, "no sabemos que pasó")}
      end
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("save", _, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("close-modal", %{}, socket) do
    {:noreply, socket |> assign(:open, false)}
  end

  @impl true
  def handle_event(
        "get-free-ticket",
        %{"id" => id},
        socket = %{assigns: %{current_user: user = %Rauversion.Accounts.User{}}}
      ) do
    with {:ok, result} <-
           Rauversion.PurchaseOrders.create_free_ticket_order(
             socket.assigns.event,
             id,
             user.id
           ) do
      IO.inspect(result)

      {:noreply,
       socket
       |> put_flash(:error, "Failed to authenticate.")
       |> assign(:purchase, result)
       |> assign(:status, :success)}
    else
      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(:error, "Failed to authenticate.")
         |> assign(:status, :error)}
    end
  end

  @impl true
  def handle_event("get-free-ticket", _params, socket = %{assigns: %{current_user: _user = nil}}) do
    {:noreply,
     socket
     |> put_flash(:info, gettext("You need to be login before get tickets"))
     |> redirect(to: "/users/log_in")}
  end

  @impl true
  def handle_event(
        "validate",
        %{"purchase_order" => purchase_order},
        socket = %{assigns: %{current_user: %Rauversion.Accounts.User{}}}
      ) do
    changeset =
      %Rauversion.PurchaseOrders.PurchaseOrder{
        user_id: socket.assigns.current_user.id
      }
      |> Rauversion.PurchaseOrders.change_purchase_order(purchase_order)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(socket, :changeset, changeset)
     |> assign(
       :result,
       Rauversion.PurchaseOrders.calculate_total(changeset |> Ecto.Changeset.apply_changes())
     )}
  end

  @impl true
  def handle_event(
        "validate",
        %{"purchase_order" => _purchase_order},
        socket = %{assigns: %{current_user: nil}}
      ) do
    {:noreply,
     socket
     |> put_flash(:info, gettext("You need to be login before get tickets"))
     |> redirect(to: "/users/log_in")}
  end

  def order_session(
        event = %{event_settings: %{payment_gateway: "stripe"}},
        purchase_order,
        user_id
      ) do
    case Rauversion.PurchaseOrders.create_stripe_order(event, purchase_order, user_id) do
      {:ok, %{response: resp, order: order}} ->
        %{url: resp["url"], order: order}

      _ ->
        nil
    end
  end

  def order_session(
        event = %{event_settings: %{payment_gateway: "transbank"}},
        purchase_order,
        user_id
      ) do
    case Rauversion.PurchaseOrders.create_transbank_order(event, purchase_order, user_id) do
      {:ok, %{gen_ticket: %{response: resp, order: order}}} ->
        %{url: resp["url"] <> "?token_ws=#{resp["token"]}", order: order}

      {:error, :gen_ticket, err, _} ->
        {:error, err}

      e ->
        IO.inspect(e)
        {:error, "chuchuc"}
    end

    # %{url: resp["url"] <> "?token_ws=#{resp["token"]}", order: a}
  end

  def reedemed_free_ticket?(current_user, ticket) do
    case Rauversion.Accounts.get_event_ticket(current_user, ticket) do
      nil -> false
      _ -> true
    end
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

                      <%= if @status do %>
                        <%= @status %>
                      <% end %>

                      <%= if @purchase |> is_nil do %>

                        <.form let={f} for={@changeset}
                          phx-change="validate"
                          phx-target={@myself}
                          phx-submit="save">
                            <table class="min-w-full divide-y divide-gray-300 dark:divide-gray-700">
                                <thead class="bg-gray-50-- dark:bg-gray-900--">

                                  <tr>
                                    <th scope="col" class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 dark:text-gray-100 sm:pl-6"><%= gettext("Name") %></th>
                                    <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-gray-100"><%= gettext("Price") %></th>
                                    <th scope="col" class="px-3 py-3.5 text-center text-sm font-semibold text-gray-900 dark:text-gray-100"><%= gettext("QTY") %></th>
                                  </tr>

                                </thead>

                                <tbody class="divide-y divide-gray-200 dark:divide-gray-900-- bg-white-- dark:bg-gray-800--">

                                  <%= inputs_for f, :data, fn i -> %>

                                  <% ticket = Rauversion.EventTickets.get_event_ticket!(i.params["ticket_id"])

                                  # ticket = Rauversion.EventTickets.get_event_ticket!(i.ticket_id) %>

                                  <% #= for ticket <- @tickets do %>
                                    <tr>
                                      <td class="whitespace-nowrap py-4 pl-4 pr-3 text-sm sm:pl-6">
                                        <div class="flex items-center">
                                          <div class="">
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
                                          <%= Number.Currency.number_to_currency(ticket.price, precision: Rauversion.Events.presicion_for_currency(@event)) %>
                                          <%= @event.event_settings.ticket_currency %>
                                        </div>
                                      </td>
                                      <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500 dark:text-gray-400">

                                        <div class="flex justify-center items-center space-x-3">

                                          <%= if Decimal.to_integer(ticket.price) != 0 do %>
                                            <%= label i, :x %>
                                            <%= text_input i, :count, class: "bg-gray-700 border rounded-sm", type: :number %>
                                            <%= error_tag i, :count %>
                                            <%= hidden_input i, :ticket_id, value: ticket.id %>
                                          <% else %>
                                            <%= if reedemed_free_ticket?(@current_user, ticket) do %>
                                              <div class="flex items-center space-x-2">
                                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6 text-green-600">
                                                  <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                                </svg>
                                                <div class="text-sm font-medium text-gray-900 dark:text-gray-100">
                                                  <%= gettext("Free ticket already added") %>
                                                </div>

                                              </div>
                                            <% else %>
                                              <button
                                                phx-click="get-free-ticket"
                                                phx-value-id={ticket.id}
                                                phx-target={@myself}
                                                class="inline-flex justify-center rounded-2xl bg-brand-600 px-4 p-2 text-base font-semibold text-white hover:bg-brand-500 focus:outline-none focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-brand-500 active:text-white/70">
                                                <%= gettext("Get your FREE ticket") %>
                                              </button>
                                            <% end %>
                                          <% end %>
                                        </div>
                                      </td>
                                    </tr>
                                  <% end %>

                                  <tr>
                                    <td class="whitespace-nowrap py-4 pl-4 pr-3 text-sm sm:pl-6">

                                    </td>

                                    <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500 dark:text-gray-400">

                                    </td>

                                    <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500 dark:text-gray-400">
                                      <div class="flex justify-end">
                                        <h2 class="text-2xl">
                                          <%= Number.Currency.number_to_currency(@result) %>
                                        </h2>
                                      </div>
                                    </td>
                                  </tr>


                                  <tr>
                                    <td class="whitespace-nowrap py-4 pl-4 pr-3 text-sm sm:pl-6">

                                    </td>

                                    <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500 dark:text-gray-400">
                                    </td>

                                    <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500 dark:text-gray-400">
                                      <div class="flex justify-end">
                                        <div class="hidden">
                                        <%= if @changeset.valid? do %>
                                          is valid!
                                        <% else %>
                                          no valid!
                                        <% end %>
                                        </div>
                                        <%= submit gettext("Place order"),
                                          disabled: !@changeset.valid?,
                                          class: "inline-flex items-center rounded-md border border-brand-300 dark:border-brand-700 bg-brand-600 dark:bg-brand-600 px-4 py-4 text-sm font-medium leading-4 text-brand-100 dark:text-brand-100 shadow-sm hover:bg-brand-50 dark:hover:bg-brand-900 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-30"
                                        %>
                                      </div>
                                    </td>
                                  </tr>

                                </tbody>


                              </table>
                        </.form>

                      <% else %>

                        <div class="bg-white dark:bg-black shadow sm:rounded-lg">
                          <div class="px-4 py-5 sm:p-6">
                            <div class="flex space-x-3">
                              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6 text-green-600">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                              </svg>
                              <h3 class="text-lg font-medium leading-6 text-gray-900 dark:text-gray-100">
                                <%= gettext("Ticket purchase complete") %>
                              </h3>
                            </div>
                            <div class="mt-2 sm:flex sm:items-start sm:justify-between">
                              <div class="max-w-xl text-sm text-gray-500 dark:text-gray-200">
                                <p>
                                  <%= gettext("The ticket purchase was successfully completed, it willappear in your purchases section") %>
                                </p>
                              </div>
                              <div class="mt-5 sm:mt-0 sm:ml-6 sm:flex sm:flex-shrink-0 sm:items-center">
                                <%= live_redirect to: "/purchases/tickets", class: "inline-flex items-center rounded-md border border-transparent bg-brand-600 px-4 py-2 font-medium text-white shadow-sm hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:ring-offset-2 sm:text-sm" do %>
                                  <%= gettext("go to ticket") %>
                                <% end %>
                              </div>
                            </div>
                          </div>
                        </div>

                      <% end %>
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
