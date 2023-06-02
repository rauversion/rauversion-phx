defmodule RauversionWeb.Live.EventsLive.Components.RecordingsComponent do
  use RauversionWeb, :live_component

  alias Rauversion.EventRecordings
  alias Rauversion.EventRecordings.EventRecording
  alias Rauversion.Events

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:event_recording, %EventRecording{})
     |> assign(:changeset, EventRecordings.change_event_recording(%EventRecording{}, %{}))
     |> assign(:display_form, false)
     |> assign(:event_recordings, list_recordings(assigns.event))}
  end

  def list_recordings(event) do
    Ecto.assoc(event, :event_recordings) |> Rauversion.Repo.all()
  end

  @impl true
  def handle_event("validate", %{"event_recording" => event_params}, socket) do
    changeset =
      socket.assigns.event_recording
      |> EventRecordings.change_event_recording(event_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"event_recording" => event_params}, socket) do
    save_event(socket, :new, event_params)
  end

  @impl true
  def handle_event("edit", %{"id" => id}, socket) do
    recording = Events.get_recording(socket.assigns.event, id)

    {:noreply,
     socket
     |> assign(:event_recording, recording)
     |> assign(:changeset, EventRecordings.change_event_recording(recording, %{}))
     |> assign(:display_form, true)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    recording = Events.get_recording(socket.assigns.event, id)

    EventRecordings.delete_event_recording(recording)

    {:noreply,
     socket
     |> assign(:event_recording, recording)
     |> assign(:changeset, EventRecordings.change_event_recording(recording, %{}))
     |> assign(:event_recordings, list_recordings(socket.assigns.event))}
  end

  @impl true
  def handle_event("new_recording", _, socket) do
    {:noreply,
     socket
     |> assign(:changeset, EventRecordings.change_event_recording(%EventRecording{}, %{}))
     |> assign(:display_form, true)}
  end

  defp save_event(socket, :edit, event_params) do
    case EventRecordings.update_event_recording(socket.assigns.event_recording, event_params) do
      {:ok, _event} ->
        {
          :noreply,
          socket
          |> put_flash(:info, "Event updated successfully")
          # |> push_redirect(to: socket.assigns.return_to)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_event(socket, :new, event_params) do
    event_params = event_params |> Map.put("event_id", socket.assigns.event.id)

    case EventRecordings.create_event_recording(event_params) do
      {:ok, _event} ->
        {
          :noreply,
          socket
          |> put_flash(:info, "Event recording created successfully")
          |> assign(:event_recordings, list_recordings(socket.assigns.event))
          |> assign(:display_form, false)
          # |> push_redirect(to: "/events/#{event.slug}/edit")
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        # IO.inspect(changeset)
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="m-4">
      <div class="my-4 mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div class="mx-auto max-w-4xl text-center">
          <h2 class="text-3xl font-bold tracking-tight text-gray-900 dark:text-gray-100 sm:text-4xl">
            <%= gettext("Event Recordings") %>
          </h2>

          <p class="my-3 text-xl text-gray-500 dark:text-gray-300 dark:text-gray-300 dark:text-gray-300 sm:mt-4">
            <%= gettext("Add Event recordings from Twitch, Youtube etc...") %>
          </p>

          <%= link(gettext("Add new event recording"),
            to: "#",
            phx_target: @myself,
            phx_click: "new_recording",
            class:
              "inline-flex items-center rounded border border-transparent bg-indigo-600 px-2.5 py-1.5 text-xs font-medium text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
          ) %>
        </div>
      </div>

      <%= if @display_form do %>
        <.form
          :let={f}
          for={@changeset}
          phx-target={@myself}
          id="hosts-form"
          phx-change="validate"
          phx-submit="save"
        >
          <div class="space-y-3">
            <%= gettext(
              "Add a host to highlight them on the event page or to get help managing the event."
            ) %>
            <%= form_input_renderer(f, %{
              type: :text_input,
              name: :title,
              wrapper_class: "",
              placeholder: "recording title"
            }) %>
            <%= form_input_renderer(f, %{
              type: :textarea,
              name: :description,
              wrapper_class: "",
              placeholder: "recording description here"
            }) %>
            <%= form_input_renderer(f, %{
              type: :text_input,
              name: :iframe,
              wrapper_class: "",
              placeholder: "iframe link, ie:: https//video.com/1223"
            }) %>

            <%= # form_input_renderer(f, %{type: :text_input, name: :email, wrapper_class: "", placeholder: "email"}) %>
            <%= form_input_renderer(f, %{
              type: :select,
              options: [
                [key: "twitch", value: "twitch"],
                [key: "youtube", value: "youtube"],
                [key: "iframe", value: "iframe"]
              ],
              wrapper_class: nil,
              name: :type
            }) %>
            <%= submit(gettext("Save"),
              phx_disable_with: gettext("Saving..."),
              class:
                "inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-brand-600 hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500"
            ) %>
          </div>
        </.form>
      <% end %>

      <ul
        role="list"
        class="grid grid-cols-2 gap-x-4 gap-y-8 sm:grid-cols-3 sm:gap-x-6 lg:grid-cols-3 xl:gap-x-8"
      >
        <%= for item <- @event_recordings do %>
          <li class="relative">
            <iframe
              src={item.iframe}
              frameborder="0"
              allowfullscreen="true"
              scrolling="no"
              height="240"
              phx-update="ignore"
              id={"recordings-#{item.id}"}
              width="100%"
            >
            </iframe>
            <div class="flex justify-center space-x-2">
              <%= link("delete",
                to: "#",
                class: "text-xs text-red-800",
                phx_target: @myself,
                phx_click: "delete",
                phx_value_id: item.id,
                "data-confirm": "Are you sure?"
              ) %>
              <%= link("edit",
                to: "#",
                class: "text-xs",
                phx_target: @myself,
                phx_click: "edit",
                phx_value_id: item.id
              ) %>
            </div>
          </li>
        <% end %>
      </ul>
    </div>
    """
  end
end
