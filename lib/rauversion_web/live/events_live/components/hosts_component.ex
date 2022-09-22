defmodule RauversionWeb.Live.EventsLive.Components.HostsComponent do
  use RauversionWeb, :live_component

  alias Rauversion.{Events}

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:upload_modal, nil)
     |> assign(:new_modal, nil)}
  end

  @impl true
  def handle_event("add-host", _, socket) do
    socket =
      update(socket, :changeset, fn changeset ->
        changeset
        |> Ecto.Changeset.apply_changes()
        |> Ecto.Changeset.change()
        |> EctoNestedChangeset.append_at(:event_hosts, %{})
      end)

    {:noreply, socket}
  end

  @impl true
  def handle_event("upload-modal", %{"index" => id}, socket) do
    {:noreply,
     socket
     |> assign(:upload_modal, true)
     |> assign(:host, find_host(socket.assigns.event, id))}
  end

  @impl true
  def handle_event("close-modal", %{}, socket) do
    {:noreply,
     assign(socket, :upload_modal, nil)
     |> assign(:new_modal, nil)}
  end

  @impl true
  def handle_event(
        "delete-host",
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
          :event_hosts,
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
  def handle_event("validate", _, socket) do
    handle_event("validate", %{"event" => %{"event_hosts" => []}}, socket)
  end

  @impl true
  def handle_event("save", event_params, socket) do
    save_event(socket, :edit, event_params)
  end

  @impl true
  def handle_event("new-modal", _, socket) do
    {:noreply, assign(socket, :new_modal, true)}
  end

  def find_host(event, id) do
    Rauversion.Events.get_host!(event, id)
  end

  defp save_event(socket, :edit, %{"event" => event_params}) do
    case Rauversion.Events.update_event(socket.assigns.event, event_params) do
      {:ok, _event} ->
        {
          :noreply,
          socket
          |> put_flash(:info, "Hosts updated successfully")
          # |> push_redirect(to: socket.assigns.return_to)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_event(socket, :edit, %{}) do
    save_event(socket, :edit, %{"event" => %{"event_hosts" => []}})
  end

  def get_hosts(event) do
    Rauversion.Events.get_hosts(event)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-5 w-full">

        <%= if @new_modal do %>

          <.modal close_handler={@myself} w_class={"w-1/4"}>
            <.form
              let={f}
              for={:new_user}
              phx-target={@myself}
              id="hosts-form"
              phx-change="validate"
              phx-submit="save">
              <div class="space-y-3">
                <%= gettext("Add a host to highlight them on the event page or to get help managing the event.") %>
                <%= form_input_renderer(f, %{type: :text_input, name: :email, wrapper_class: "", placeholder: "email"}) %>
                <%= submit gettext("Save"), phx_disable_with: gettext("Saving..."), class: "inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-brand-600 hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500" %>
              </div>
            </.form>
          </.modal>

        <% end %>

        <%= for host <- get_hosts(@event) do %>
          <div>
            <%= host.name %>
            <%= if host.user do %>
              user: <%= host.user.username %>
            <% end %>
          </div>
        <% end %>

        <%= if @upload_modal do %>
          <.modal close_handler={@myself}>
            <.live_component
              id={"upload-form"}
              host={@host}
              module={RauversionWeb.EventsLive.Components.HostsUploaderComponent}
            />

          </.modal>
        <% end %>

        <button type="button"
          phx-click="new-modal"
          phx-target={@myself}
          class="mt-2 inline-flex justify-center items-center border-2 border-white-600 rounded-lg py-2 px-2 bg-black text-white-600 block text-sm"
          >
          <%= gettext("New host") %>
        </button>

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

              <%= inputs_for f, :event_hosts, fn i -> %>
                <div class="border-2 rounded-md p-4 my-4">
                  <div class="mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">

                    <%= form_input_renderer(i, %{
                      type: :text_input,
                      name: :name,
                      wrapper_class: "sm:col-span-3",
                      hint: gettext("Host Name")
                    }) %>

                    <%= form_input_renderer(i, %{
                      type: :textarea,
                      name: :description,
                      wrapper_class: "sm:col-span-6",
                      hint: gettext("Host description.")
                    }) %>

                    <%= form_input_renderer(i, %{
                      type: :checkbox,
                      name: :listed_on_page,
                      wrapper_class: "sm:col-span-4",
                      label: "Listed on page",
                      hint: gettext("if checked Host will be listed on Event's page.")
                    }) %>

                    <%= form_input_renderer(i, %{
                      type: :checkbox,
                      name: :event_manager,
                      wrapper_class: "sm:col-span-4",
                      label: "Manager",
                      hint: gettext("if checked the Host will have manager access to event.")
                    }) %>

                  </div>

                  <button type="button"
                    phx-click="upload-modal"
                    phx-target={@myself}
                    class="mt-2 inline-flex justify-center items-center border-2 border-white-600 rounded-lg py-2 px-2 bg-black text-white-600 block text-sm"
                    phx-value-index={i.data.id}>
                    <%= gettext("Add Avatar") %>
                  </button>

                  <button type="button"
                    phx-click="delete-host"
                    phx-target={@myself}
                    class="mt-2 inline-flex justify-center items-center border-2 border-red-600 rounded-lg py-2 px-2 bg-black text-red-600 block text-sm"
                    phx-value-index={i.index}>
                    <%= gettext("Delete Host") %>
                  </button>

                </div>
              <% end %>
            </div>

            <div class="sm:col-span-6 flex justify-end space-x-2">
              <button
                type="button"
                class="inline-flex justify-between dark:border-2 dark:border-white rounded-lg py-3 px-5 bg-black text-white block font-medium"
                phx-target={@myself}
                phx-click="add-host">

                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M12 3v18m9-9H3" />
                </svg>

                <span><%= gettext("Add Host") %></span>
              </button>

              <%= submit gettext("Save"), phx_disable_with: gettext("Saving..."), class: "inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-brand-600 hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500" %>
            </div>

          </div>

        </.form>
      </div>
    """
  end
end
