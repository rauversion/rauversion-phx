defmodule RauversionWeb.EventsLive.Components.HostsUploaderComponent do
  use RauversionWeb, :live_component

  alias Rauversion.{EventHosts}

  @impl true
  def update(%{host: host} = assigns, socket) do
    changeset = EventHosts.change_event_host(host)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> allow_upload(:avatar, accept: ~w(.jpg .jpeg .png), max_entries: 1)}
  end

  @impl true
  def handle_event("validate", event_params, socket) do
    changeset =
      socket.assigns.host
      |> EventHosts.change_event_host(event_params)
      |> Map.put(:action, :validate)

    # IO.inspect(changeset)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", event_params, socket) do
    save_event(socket, :edit, event_params)
  end

  defp save_event(socket, :edit, event_params) do
    event_params =
      event_params
      |> Map.put("avatar", files_for(socket, :avatar))

    case EventHosts.update_event_host(socket.assigns.host, event_params) do
      {:ok, _event} ->
        {
          :noreply,
          socket
          |> put_flash(:info, "Host updated successfully")
          # |> push_redirect(to: socket.assigns.return_to)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form
        let={f}
        for={@changeset}
        phx-target={@myself}
        id="playlist-form"
        phx-change="validate"
        phx-submit="save">

        <h2 class="mx-0 mt-0 mb-4 font-sans text-2xl font-bold leading-none">
          <%= gettext "Host & Managers" %>
        </h2>

        <div class="mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">

          <div class="sm:col-span-6">
            <%= form_input_renderer(f, %{
              type: :upload,
              uploads: @uploads,
              name: :avatar
              }) %>
          </div>

          <div class="sm:col-span-6 flex justify-end space-x-2">
            <%= submit gettext("Save"), phx_disable_with: gettext("Saving..."), class: "inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-brand-600 hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500" %>
          </div>

        </div>

      </.form>


    </div>
    """
  end
end
