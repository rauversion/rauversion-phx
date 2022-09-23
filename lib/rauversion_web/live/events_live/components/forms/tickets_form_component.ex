defmodule RauversionWeb.Live.EventsLive.Components.TicketsFormComponent do
  use RauversionWeb, :live_component
  alias Rauversion.Events

  @impl true
  def handle_event("add-ticket", _, socket) do
    socket =
      update(socket, :changeset, fn changeset ->
        changeset
        |> Ecto.Changeset.apply_changes()
        |> Ecto.Changeset.change()
        |> EctoNestedChangeset.append_at(:event_tickets, %{})
      end)

    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "delete-ticket",
        %{"index" => index},
        socket
      ) do
    index = String.to_integer(index)

    socket =
      update(socket, :changeset, fn changeset ->
        changeset
        |> Ecto.Changeset.apply_changes()
        |> Ecto.Changeset.change()
        |> EctoNestedChangeset.delete_at([
          :event_tickets,
          index
        ])
      end)

    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"event" => event_params}, socket) do
    changeset =
      socket.assigns.event
      |> Events.change_event(event_params)
      |> Map.put(:action, :validate)

    # IO.inspect(changeset)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", event_params, socket) do
    save_event(socket, :edit, event_params)
  end

  defp save_event(socket, :edit, %{"event" => event_params}) do
    case Rauversion.Events.update_event(socket.assigns.event, event_params) do
      {:ok, _event} ->
        {
          :noreply,
          socket
          |> put_flash(:info, "Tickets updated successfully")
          # |> push_redirect(to: socket.assigns.return_to)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def ticket_kind(i) do
    assigns = %{}

    value =
      if Map.get(i.params, "price") do
        case Integer.parse(i.params["price"]) do
          {n, ""} -> n
          _ -> 0
        end
      else
        Decimal.to_integer(i.data.price)
      end

    ~H"""
      <div>
        <%= if value == 0 do %>
          <span class="inline-flex items-center rounded-full bg-green-900 px-3 py-1.5 text-xl font-medium text-green-200">
            <%= gettext("Free ticket") %>
          </span>
        <% else %>
          <span class="inline-flex items-center rounded-full bg-blue-900 px-3 py-1.5 text-xl font-medium text-blue-200">
            <%= gettext("Paid ticket") %>
          </span>
        <% end %>
      </div>
    """
  end

  @impl true
  def render(assigns) do
    ~H"""
      <div class="p-5">
        <.form
          let={f}
          for={@changeset}
          phx-target={@myself}
          id="tickets-form"
          phx-change="validate"
          phx-submit="save">

          <h2 class="mx-0 mt-0 mb-4 font-sans text-2xl font-bold leading-none">
            <%= gettext "Create Tickets" %>
          </h2>

          <div class="sm:col-span-6 flex justify-end">
            <%= submit gettext("Save"), phx_disable_with: gettext("Saving..."), class: "inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-brand-600 hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500" %>
          </div>

          <%= inputs_for f, :event_tickets, fn i -> %>

            <div class="border-2 rounded-md p-4 my-4">

              <div class="rounded-md p-2 my-2 flex justify-end">
                <%= ticket_kind(i) %>
              </div>

              <div class="mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">

                <%= form_input_renderer(i, %{
                  type: :text_input,
                  name: :title,
                  wrapper_class: "sm:col-span-3",
                  hint: gettext("Ticket Type. For Example: General Admission, VIP Admission ...")
                }) %>


                <div class="sm:col-span-3 flex items-start space-x-4">
                  <%= form_input_renderer(i, %{
                    type: :number_input,
                    name: :price,
                    wrapper_class: "w-1/2",
                    hint: gettext("All prices are in $%{ccy}.", %{ccy: f.data.event_settings.ticket_currency})
                    })
                  %>

                  <%= form_input_renderer(i, %{
                    type: :number_input,
                    name: :qty,
                    wrapper_class: "w-1/2",
                    hint: gettext("Total number of tickets.")
                  }) %>
                </div>

                <%= form_input_renderer(i, %{
                  type: :datetime_input,
                  name: :selling_start,
                  wrapper_class: "sm:col-span-1"
                }) %>

                <%= form_input_renderer(i, %{
                  type: :datetime_input,
                  name: :selling_end,
                  wrapper_class: "sm:col-span-1"
                }) %>

                <%= form_input_renderer(i, %{
                  type: :textarea,
                  name: :short_description,
                  wrapper_class: "sm:col-span-6",
                  hint: gettext("Optional short description will be displayed next to this ticket on the Event page.")
                }) %>

              </div>

              <%= inputs_for i, :settings, fn ii -> %>
                <div class="mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">


                  <%= form_input_renderer(ii, %{
                    type: :checkbox,
                    name: :show_sell_until,
                    wrapper_class: "sm:col-span-3",
                    hint: gettext("Show the Sell Until date on the event page.")
                  }) %>

                  <%= form_input_renderer(ii, %{
                    type: :checkbox,
                    name: :show_after_sold_out,
                    wrapper_class: "sm:col-span-3",
                    hint: gettext("Display with a \"Sold out\" message after ticket quantity runs out.")
                    })
                  %>

                  <%= form_input_renderer(ii, %{type: :select, options: [
                      [key: "Pass all fees to the buyer", value: "pass_all"],
                      [key: "Absorb service and Credit card fees", value: "absorb_all"],
                      [key: "Pass Service fee to the buyer and Absorb Credit Card fee", value: "absorb_merchant"],
                    ],
                    wrapper_class: "sm:col-span-6",
                    name: :fees })
                  %>

                  <%= form_input_renderer(ii, %{
                    type: :checkbox,
                    name: :hidden,
                    wrapper_class: "sm:col-span-4",
                    label: "Hide Ticket?",
                    hint: gettext("Check to hide this ticket on your Event page and make it available via a direct link only.")
                  }) %>

                  <%= form_input_renderer(ii, %{
                    type: :number_input,
                    name: :min_tickets_per_order,
                    wrapper_class: "sm:col-span-3",
                    hint: gettext("Leave blank unless there is a Minimum amount of tickets customer has to order.")
                    })
                  %>

                  <%= form_input_renderer(ii, %{
                    type: :number_input,
                    name: :max_tickets_per_order,
                    wrapper_class: "sm:col-span-3",
                    hint: gettext("Leave blank unless there is a Maximum number of tickets customer is limited to.")
                  }) %>


                  <%= form_input_renderer(ii, %{
                    type: :textarea,
                    name: :after_purchase_message,
                    wrapper_class: "sm:col-span-6",
                    hint: gettext("Additional message to include on the purchased ticket")
                  }) %>

                  <%= form_input_renderer(ii, %{type: :select, options: [
                    [key: "All channels", value: "all"],
                    [key: "Event page only", value: "event_page"],
                    [key: "Box office only", value: "box_office"],
                    ],
                    wrapper_class: "sm:col-span-4",
                    name: :sales_channel }) %>
                </div>
              <% end %>

              <button type="button"
                phx-click="delete-ticket"
                phx-target={@myself}
                class="mt-2 inline-flex justify-center items-center border-2 border-red-600 rounded-lg py-2 px-2 dark:bg-black text-red-600 block text-sm"
                phx-value-index={i.index}>
                Delete Ticket
              </button>

            </div>
          <% end %>


          <div class="mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">

            <div class="sm:col-span-6">
              <button
                  type="button"
                  class="inline-flex justify-start space-x-2 dark:border-2 dark:border-white rounded-lg py-3 px-5 bg-black text-white block font-medium"
                  phx-target={@myself}
                  phx-click="add-ticket">

                  <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 3v18m9-9H3" />
                  </svg>

                  <span><%= gettext("Add new Ticket") %></span>
                </button>

            </div>

            <div class="sm:col-span-6 flex justify-end">
              <%= submit gettext("Save"), phx_disable_with: gettext("Saving..."), class: "inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-brand-600 hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500" %>
            </div>



          </div>

        </.form>
      </div>
    """
  end
end
