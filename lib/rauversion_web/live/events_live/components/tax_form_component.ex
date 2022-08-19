defmodule RauversionWeb.Live.EventsLive.Components.TaxFormComponent do
  use RauversionWeb, :live_component

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
            <%= gettext "Tax options" %>
          </h2>

          <p>
            You can use this section to set up taxes for your event.
            Rauversion does not collect or remit sales tax on your behalf.
            It is your responsibility to assess tax obligations in areas where you are selling tickets.
          </p>

          <div class="mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">


            <%= form_input_renderer(f, %{
              type: :checkbox,
              name: :tax_charge,
              wrapper_class: "sm:col-span-6",
            }) %>

            <%= form_input_renderer(f, %{
              type: :text_input,
              name: :tax_id,
              wrapper_class: "sm:col-span-3",
            }) %>

            <%= form_input_renderer(f, %{
              type: :text_input,
              name: :tax_rate,
              wrapper_class: "sm:col-span-3",
            }) %>

            <%= form_input_renderer(f, %{
              type: :text_input,
              name: :tax_country,
              wrapper_class: "sm:col-span-3",
            }) %>

            <%= form_input_renderer(f, %{
              type: :text_input,
              name: :tax_label,
              wrapper_class: "sm:col-span-3",
              hint: gettext("For example: Ticket Sales")
            }) %>

            <div class="sm:col-span-6 flex justify-end">
              <%= submit gettext("Save"), phx_disable_with: gettext("Saving..."), class: "inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-brand-600 hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500" %>
            </div>

          </div>

        </.form>
      </div>
    """
  end
end
