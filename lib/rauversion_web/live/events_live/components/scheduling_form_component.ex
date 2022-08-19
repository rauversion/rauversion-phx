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
  def handle_event("validate", event_params, socket) do
    changeset =
      socket.assigns.event
      |> Rauversion.Events.change_event(event_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
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
            <%= gettext "Create Event" %>
          </h2>

          <div class="mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">


              <%= inputs_for f, :scheduling_settings, fn i -> %>
                <div class="sm:col-span-6 flex justify-end space-x-3">
                  <%= form_input_renderer(i, %{type: :datetime_input, name: :event_start, wrapper_class: nil}) %>
                  <%= form_input_renderer(i, %{type: :datetime_input, name: :event_ends, wrapper_class: nil}) %>
                  <%= form_input_renderer(f, %{type: :select, options: [
                    [key: "Daily", value: "daily"],
                    [key: "Weekly", value: "weekly"],
                    [key: "Once", value: "once"],
                  ], wrapper_class: nil, name: :schedule_type }) %>
                </div>
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
