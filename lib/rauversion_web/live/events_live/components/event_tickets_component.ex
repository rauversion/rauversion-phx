defmodule RauversionWeb.EventsLive.EventTicketsComponent do
  use RauversionWeb, :live_component
  alias Rauversion.{PurchaseOrders}
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
    |> Ecto.assoc(:event_tickets)
    |> Rauversion.Repo.all()
    |> Enum.filter(fn x -> !x.settings.hidden end)
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
  def handle_event("close-modal", %{}, socket) do
    {:noreply, socket |> assign(:open, false)}
  end

  @impl true
  def handle_event(
        "validate",
        %{"purchase_order" => purchase_order},
        socket
      ) do
    changeset =
      %Rauversion.PurchaseOrders.PurchaseOrder{
        user_id: socket.assigns.current_user.id
      }
      |> Rauversion.PurchaseOrders.change_purchase_order(purchase_order)
      |> Map.put(:action, :validate)

    # IO.inspect(changeset)

    {:noreply,
     assign(socket, :changeset, changeset)
     |> assign(
       :result,
       Rauversion.PurchaseOrders.calculate_total(changeset |> Ecto.Changeset.apply_changes())
     )}
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
                                    <th scope="col" class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 dark:text-gray-100 sm:pl-6">Name</th>
                                    <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-gray-100">Price</th>
                                    <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900 dark:text-gray-100">QTY</th>
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
                                          <%= Number.Currency.number_to_currency(ticket.price) %>
                                          <%= @event.event_settings.ticket_currency %>
                                        </div>
                                      </td>
                                      <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500 dark:text-gray-400">
                                        <div class="flex justify-start items-center space-x-3">
                                            <%= label i, :x %>
                                            <%= text_input i, :count, class: "bg-gray-700 border rounded-sm", type: :number %>
                                            <%= error_tag i, :count %>
                                            <%= hidden_input i, :ticket_id, value: ticket.id %>
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
                                        <%= if @changeset.valid? do %>
                                          is valid!
                                        <% else %>
                                          no valid!
                                        <% end %>
                                        <%= submit "Place order",
                                          disabled: !@changeset.valid?,
                                          class: "inline-flex items-center rounded-md border border-brand-300 dark:border-brand-700 bg-brand-600 dark:bg-brand-600 px-4 py-4 text-sm font-medium leading-4 text-brand-100 dark:text-brand-100 shadow-sm hover:bg-brand-50 dark:hover:bg-brand-900 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-30"
                                        %>
                                      </div>
                                    </td>
                                  </tr>

                                </tbody>


                              </table>
                        </.form>
                      <% else %>
                        ya papoooo!
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
