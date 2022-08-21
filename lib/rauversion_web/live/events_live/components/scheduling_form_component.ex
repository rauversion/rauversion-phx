defmodule RauversionWeb.Live.EventsLive.Components.SchedulingFormComponent do
  use RauversionWeb, :live_component

  @impl true
  def handle_event("add-feature", _, socket) do
    socket =
      update(socket, :changeset, fn changeset ->
        existing = Ecto.Changeset.get_field(changeset, :scheduling_settings, [])
        Ecto.Changeset.put_embed(changeset, :scheduling_settings, existing ++ [%{}])
      end)

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
      <div class="p-5 w-full">
        <.form
          let={f}
          for={@changeset}
          phx-target={@myself}
          id="playlist-form"
          phx-change="validate"
          phx-submit="save">

          <h2 class="mx-0 mt-0 mb-4 font-sans text-base font-bold leading-none">
            <%= gettext "Create Event" %>
          </h2>

          <div class="mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">
            <%= inputs_for f, :scheduling_settings, fn i -> %>
              <%= form_input_renderer(i, %{type: :text_input, name: :name, wrapper_class: "sm:col-span-6"}) %>
              <%= form_input_renderer(i, %{type: :datetime_input, name: :start_date, wrapper_class: "sm:col-span-3"}) %>
              <%= form_input_renderer(i, %{type: :datetime_input, name: :end_date, wrapper_class: "sm:col-span-3"}) %>
              <%= form_input_renderer(i, %{type: :select, options: [
                [key: "Daily", value: "daily"],
                [key: "Weekly", value: "weekly"],
                [key: "Once", value: "once"],
              ], wrapper_class: "sm:col-span-6", name: :schedule_type }) %>
              <%= form_input_renderer(i, %{type: :textarea, name: :description, wrapper_class: "sm:col-span-6"}) %>
            <% end %>
          </div>

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
