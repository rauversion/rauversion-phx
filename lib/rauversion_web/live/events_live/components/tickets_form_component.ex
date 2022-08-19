defmodule RauversionWeb.Live.EventsLive.Components.TicketsFormComponent do
  use RauversionWeb, :live_component

  @impl true
  def handle_event("add-feature", _, socket) do
    socket =
      update(socket, :changeset, fn changeset ->
        existing = Ecto.Changeset.get_field(changeset, :tickets, [])
        Ecto.Changeset.put_embed(changeset, :tickets, existing ++ [%{}])
      end)

    IO.inspect(socket)
    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", _event_params, socket) do
    # changeset =
    #  socket.assigns.event
    #  |> Events.change_event(event_params)
    #  |> Map.put(:action, :validate)

    # {:noreply, assign(socket, :changeset, changeset)}

    {:noreply, socket}
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
          |> put_flash(:info, "Playlist updated successfully")
          # |> push_redirect(to: socket.assigns.return_to)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
      <div class="p-5">
        <.form
          let={f}
          for={@changeset}
          phx-target={@myself}
          id="playlist-form"
          phx-change="validate"
          phx-submit="save">

          <h2 class="mx-0 mt-0 mb-4 font-sans text-base font-bold leading-none">
            <%= gettext "Create Tickets" %>
          </h2>


          <%= inputs_for f, :tickets, fn i -> %>
            <div class="mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">

              <%= form_input_renderer(i, %{
                type: :text_input,
                name: :title,
                wrapper_class: "sm:col-span-6",
                hint: gettext("Ticket Type. For Example: General Admission, VIP Admission ...")
              }) %>

              <div class="sm:col-span-6 flex items-start space-x-4">
                <%= form_input_renderer(i, %{
                  type: :number_input,
                  name: :price,
                  wrapper_class: "w-1/4",
                  hint: gettext("All prices are in U.S. Dollars ($). To select a different currency, click here.")
                  })
                %>

                <%= form_input_renderer(i, %{
                  type: :number_input,
                  name: :quantity,
                  wrapper_class: "w-1/4",
                  hint: gettext("Total number of tickets.")
                }) %>
              </div>

              <%= form_input_renderer(i, %{
                type: :datetime_input,
                name: :selling_start,
                wrapper_class: "sm:col-span-2"
              }) %>

              <%= form_input_renderer(i, %{
                type: :datetime_input,
                name: :selling_ends,
                wrapper_class: "sm:col-span-2"
              }) %>

              <%= form_input_renderer(i, %{
                type: :textarea,
                name: :description,
                wrapper_class: "sm:col-span-6",
                hint: gettext("Optional short description will be displayed next to this ticket on the Event page.")
              }) %>

              <%= form_input_renderer(i, %{
                type: :checkbox,
                name: :show_sell_until,
                wrapper_class: "sm:col-span-6",
                hint: gettext("Show the Sell Until date on the event page.")
              }) %>

              <%= form_input_renderer(i, %{
                type: :checkbox,
                name: :show_after_sold_out,
                wrapper_class: "sm:col-span-6",
                hint: gettext("Display with a \"Sold out\" message after ticket quantity runs out.")
                })
              %>

              <%= form_input_renderer(f, %{type: :select, options: [
                  [key: "Pass all fees to the buyer", value: "pass_all"],
                  [key: "Absorb service and Credit card fees", value: "absorb_all"],
                  [key: "Pass Service fee to the buyer and Absorb Credit Card fee", value: "absorb_merchant"],
                ],
                wrapper_class: "sm:col-span-6",
                name: :fees })
              %>

              <%= form_input_renderer(i, %{
                type: :checkbox,
                name: :hidden,
                wrapper_class: "sm:col-span-4",
                label: "Hide Ticket?",
                hint: gettext("Check to hide this ticket on your Event page and make it available via a direct link only.")
              }) %>

              <%= form_input_renderer(i, %{
                type: :number_input,
                name: :max_tickets_per_order,
                wrapper_class: "sm:col-span-3",
                hint: gettext("Leave blank unless there is a Maximum number of tickets customer is limited to.")
              }) %>

              <%= form_input_renderer(i, %{
                type: :number_input,
                name: :min_tickets_per_order,
                wrapper_class: "sm:col-span-3",
                hint: gettext("Leave blank unless there is a Minimum amount of tickets customer has to order.")
                })
              %>

              <%= form_input_renderer(i, %{
                type: :textarea,
                name: :after_purchase_message,
                wrapper_class: "sm:col-span-4",
                hint: gettext("Additional message to include on the purchased ticket")
              }) %>

              <%= form_input_renderer(i, %{type: :select, options: [
                [key: "All channels", value: "all"],
                [key: "Event page only", value: "event_page"],
                [key: "Box office only", value: "box_office"],
                ],
                wrapper_class: "sm:col-span-4",
                name: :sales_channel }) %>
            </div>
          <% end %>


          <div class="mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">

            <a href="#" type="button" phx-target={@myself} phx-click="add-feature"> add </a>

            <div class="sm:col-span-6 flex justify-end">
              <%= submit gettext("Save"), phx_disable_with: gettext("Saving..."), class: "inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-brand-600 hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500" %>
            </div>

          </div>

        </.form>
      </div>
    """
  end
end
