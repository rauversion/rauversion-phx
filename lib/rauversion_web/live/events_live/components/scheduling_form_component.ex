defmodule RauversionWeb.Live.EventsLive.Components.SchedulingFormComponent do
  use RauversionWeb, :live_component

  alias Rauversion.Events

  @impl true
  def handle_event("add-feature", _, socket) do
    socket =
      update(socket, :changeset, fn changeset ->
        changeset
        |> Ecto.Changeset.apply_changes()
        |> Ecto.Changeset.change()
        |> EctoNestedChangeset.append_at(:scheduling_settings, %{})
      end)

    {:noreply, socket}
  end

  @impl true
  def handle_event("add-feature-scheduling", %{"id" => index}, socket) do
    index = String.to_integer(index)

    socket =
      update(socket, :changeset, fn changeset ->
        changeset
        |> Ecto.Changeset.apply_changes()
        |> Ecto.Changeset.change()
        |> EctoNestedChangeset.append_at(
          [:scheduling_settings, index, :schedulings],
          %Rauversion.Events.Scheduling{}
        )
      end)

    {:noreply, socket}
  end

  @impl true
  def handle_event("delete-item", %{"index" => index}, socket) do
    index = String.to_integer(index)

    socket =
      update(socket, :changeset, fn changeset ->
        changeset
        |> Ecto.Changeset.apply_changes()
        |> Ecto.Changeset.change()
        |> EctoNestedChangeset.delete_at([:scheduling_settings, index])
      end)

    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "delete-scheduling-item",
        %{"setting-index" => setting_index, "scheduling-index" => index},
        socket
      ) do
    setting_index = String.to_integer(setting_index)
    index = String.to_integer(index)

    IO.inspect("#{setting_index}, #{index}")

    socket =
      update(socket, :changeset, fn changeset ->
        changeset
        |> Ecto.Changeset.apply_changes()
        |> Ecto.Changeset.change()
        |> EctoNestedChangeset.delete_at([
          :scheduling_settings,
          setting_index,
          :schedulings,
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
          |> put_flash(:info, "Event updated successfully")
          # |> push_redirect(to: socket.assigns.return_to)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect("ERROOROR changeset")
        IO.inspect(changeset)
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

          <h2 class="mx-0 mt-0 mb-4 font-sans text-2xl font-bold leading-none">
            <%= gettext "Create Event" %>
          </h2>

          <div class="mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">

            <div class="sm:col-span-6">

              <%= for i <- inputs_for(f, :scheduling_settings) do %>
                <%= live_component RauversionWeb.EventsLive.Components.SchedulingSettingsForm,
                  id: "aoaoa-#{i.index}",
                  f: i,
                  target: @myself
                %>
              <% end %>

            </div>

            <div class="sm:col-span-6 flex justify-end space-x-2">
              <button
                type="button"
                class="inline-flex justify-between dark:border-2 dark:border-white rounded-lg py-3 px-5 bg-black text-white block font-medium"
                phx-target={@myself}
                phx-click="add-feature">

                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M12 3v18m9-9H3" />
                </svg>

                <span>Add</span>
              </button>

              <%= submit gettext("Save"), phx_disable_with: gettext("Saving..."), class: "inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-brand-600 hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500" %>
            </div>

          </div>

        </.form>
      </div>
    """
  end
end
