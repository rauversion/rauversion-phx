defmodule RauversionWeb.Live.EventsLive.Components.StreamingComponent do
  use RauversionWeb, :live_component

  alias Rauversion.{Events}

  @impl true
  def update(%{event: event} = assigns, socket) do
    changeset = Events.change_event(event)

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:service, nil)
      |> assign(:changeset, changeset)
    }
  end

  @impl true
  def handle_event("validate", %{"event" => service_params}, socket) do
    changeset =
      Events.change_event(socket.assigns.event, service_params)
      |> Map.put(:action, :validate)

    # IO.inspect(changeset)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"event" => event_params}, socket) do
    case Events.update_event(socket.assigns.changeset.data, event_params) do
      {:ok, event} ->
        {
          :noreply,
          socket
          |> put_flash(:info, "Event updated successfully")
          |> push_redirect(to: "/events/#{event.slug}/edit/streaming")
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_event("select-service", %{"id" => id}, socket) do
    attrs = %{streaming_service: %{__type__: id}}
    changeset = socket.assigns.event |> Rauversion.Events.change_event(attrs)

    {
      :noreply,
      assign(socket, :service, id)
      |> assign(:changeset, changeset)
    }
  end

  @impl true
  def handle_event("close-modal", _, socket) do
    {
      :noreply,
      assign(socket, :service, nil)
    }
  end

  defp private_streaming_link(event) do
    Routes.events_streaming_show_path(
      RauversionWeb.Endpoint,
      :show,
      event.slug,
      Events.streaming_access_for(event)
    )
  end

  def streaming_services() do
    [
      %{name: "twitch", active: true, description: gettext("Twitch is a streaming service")},
      %{name: "mux", active: true, description: gettext("Mux is a streaming service")},
      %{name: "whereby", active: true, description: gettext("Whereby is a streaming service")},
      %{
        name: "stream_yard",
        active: true,
        description:
          gettext("Live Streaming to 15 services at once, including youtube, twitch, zoom etc...")
      },
      %{name: "zoom", active: true, description: gettext("Zoom is a streaming service")},
      %{
        name: "jitsi",
        active: false,
        description: gettext("Live Streaming on jitsy open source platform")
      },
      %{
        name: "restream",
        active: false,
        description:
          gettext("Live Streaming to 15 services at once, including youtube, twitch, zoom etc...")
      }
    ]
  end

  def render_definitions(name) do
    case Rauversion.Events.StreamingProviders.Service.find_module_by_type(name) do
      nil -> []
      mod -> mod.definitions()
    end
  end

  def render_form(assigns) do
    u = Rauversion.Events.StreamingProviders.Service

    assigns =
      assign(
        assigns,
        :webhook_url,
        u.webhook_url(assigns.event.id, %{service: assigns.kind})
      )

    ~H"""
      <%= polymorphic_embed_inputs_for @f, :streaming_service, :"#{@kind}", fn form -> %>
        <div class="sms-inputs space-y-2">
          <h3 class="text-2xl"><%= @kind %></h3>
          <%= for definitions <- render_definitions(@kind) do %>
            <%= form_input_renderer(form, definitions) %>
          <% end %>

          <h3 class="text-xl"><%= gettext("webhook url") %></h3>
          <h3 class="text-md font-bold">
            <%= gettext("use this url in case you need to process webhooks from the streamin service") %>
          </h3>
          <span class="my-2 text-sm p-2 border-gray-700 rounded-sm block bg-gray-800">
          <%= Application.get_env(:rauversion, :domain) <> @webhook_url %>
          </span>
        </div>
      <% end %>
    """
  end

  def render_fields(assigns) do
    ~H"""
    <%= case Ecto.Changeset.get_field(@changeset, :streaming_service) do %>
      <% %Rauversion.Events.Schemas.Whereby{} -> %>
        <.render_form event={@event} kind={"whereby"} f={@f}></.render_form>
      <% %Rauversion.Events.Schemas.Jitsi{} -> %>
        <.render_form event={@event} kind={"jitsi"} f={@f}></.render_form>
      <% %Rauversion.Events.Schemas.Mux{} -> %>
        <.render_form event={@event} kind={"mux"} f={@f}></.render_form>
      <% %Rauversion.Events.Schemas.Zoom{} -> %>
        <.render_form event={@event} kind={"zoom"} f={@f}></.render_form>
      <% %Rauversion.Events.Schemas.Restream{} -> %>
        <.render_form event={@event} kind={"restream"} f={@f}></.render_form>
      <% %Rauversion.Events.Schemas.Twitch{} -> %>
        <.render_form event={@event} kind={"twitch"} f={@f}></.render_form>

      <% %Ecto.Changeset{data: %Rauversion.Events.Schemas.Whereby{} } -> %>
        <.render_form event={@event} kind={"whereby"} f={@f}></.render_form>
      <% %Ecto.Changeset{data: %Rauversion.Events.Schemas.Jitsi{} } -> %>
        <.render_form event={@event} kind={"jitsi"} f={@f}></.render_form>
      <% %Ecto.Changeset{data: %Rauversion.Events.Schemas.Mux{} } -> %>
        <.render_form event={@event} kind={"mux"} f={@f}></.render_form>
      <% %Ecto.Changeset{data: %Rauversion.Events.Schemas.Zoom{} } -> %>
        <.render_form event={@event} kind={"zoom"} f={@f}></.render_form>
      <% %Ecto.Changeset{data: %Rauversion.Events.Schemas.Restream{}} -> %>
        <.render_form event={@event} kind={"restream"} f={@f}></.render_form>
      <% %Ecto.Changeset{data: %Rauversion.Events.Schemas.Twitch{}} -> %>
        <.render_form event={@event} kind={"twitch"} f={@f}></.render_form>
      <% %Ecto.Changeset{data: %Rauversion.Events.Schemas.StreamYard{}} -> %>
        <.render_form event={@event} kind={"stream_yard"} f={@f}></.render_form>
      <% a ->  %>
        service not found!
    <% end %>
    """
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="m-4">

      <%= if @service do %>
        <%= @service %>
        <.modal
          w_class={"w-2/3"}
          close_handler={@myself}>
          <.form
          let={f}
          for={@changeset}
          phx-target={@myself}
          id="scheduling-form"
          phx-change="validate"
          phx-submit="save">

          <h2 class="mx-0 mt-0 mb-4 font-sans text-2xl font-bold leading-none">
            <%= gettext "Add Streaming service" %>
          </h2>

          <% # IO.inspect "AAAAKAKAK" %>
          <% # IO.inspect @event.streaming_service %>
          <% # IO.inspect Ecto.Changeset.get_field(@changeset, :streaming_service) %>

          <div class="mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-1">

            <.render_fields event={@event} changeset={@changeset} f={f}></.render_fields>

            <div class="sm:col-span-6 flex justify-end space-x-2">
              <%= submit gettext("Save"), phx_disable_with: gettext("Saving..."), class: "inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-brand-600 hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500" %>
            </div>

          </div>
          </.form>
        </.modal>
      <% end %>

      <div class="my-4 mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div class="mx-auto max-w-4xl text-center">
          <h2 class="text-3xl font-bold tracking-tight text-gray-900 dark:text-gray-100 sm:text-4xl">
            <%= gettext("Streaming services") %>
          </h2>
          <p class="mt-3 text-xl text-gray-500 dark:text-gray-300 dark:text-gray-300 dark:text-gray-300 sm:mt-4">
            <%= gettext("Go live with a remote event via one of the following video streaming services") %>
          </p>

          <%= live_redirect gettext("Go streaming page"), to: private_streaming_link(@event) %>

        </div>
      </div>

      <div class="divide-y divide-gray-200 dark:divide-gray-800 border dark:border:gray-800 overflow-hidden rounded-lg bg-gray-200 dark:bg-gray-900 shadow sm:grid sm:grid-cols-2 sm:gap-px sm:divide-y-0">

        <%= for service <- streaming_services() do %>
          <div class={"  #{if !service[:active], do: "opacity-50" } relative group bg-white dark:bg-black p-6 focus-within:ring-2 focus-within:ring-inset focus-within:ring-indigo-500"}>
            <div>

            <%= if :"#{service[:name]}" == PolymorphicEmbed.get_polymorphic_type(Rauversion.Events.Event, :streaming_service, @event.streaming_service) do %>
              <span class="rounded-lg inline-flex p-3 bg-green-100 text-green-700 ring-4 ring-white">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5" />
                </svg>
              </span>
            <% end %>

            </div>
            <div class="mt-8">
              <h3 class="text-lg font-medium">
                <%= if service[:active] do %>
                  <a
                    href="#"
                    phx-click={"select-service"}
                    phx-value-id={service[:name]}
                    phx-target={@myself}
                    class="focus:outline-none">
                    <!-- Extend touch target to entire panel -->
                    <span class="absolute inset-0" aria-hidden="true"></span>
                    <%= service[:name] %>
                  </a>
                <% else %>
                  <div class="flex space-x-2">
                    <span>
                      <%= service[:name] %>
                    </span>
                    <span class="inline-flex items-center rounded-full bg-gray-100 px-2.5 py-0.5 text-xs font-medium text-gray-800">
                      SOON
                    </span>
                  </div>
                <% end %>
              </h3>
              <p class="mt-2 text-sm text-gray-500">
                <%= service[:description] %>
              </p>
            </div>
            <span class="pointer-events-none absolute top-6 right-6 text-gray-300 group-hover:text-gray-400" aria-hidden="true">
              <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 24 24">
                <path d="M20 4h1a1 1 0 00-1-1v1zm-1 12a1 1 0 102 0h-2zM8 3a1 1 0 000 2V3zM3.293 19.293a1 1 0 101.414 1.414l-1.414-1.414zM19 4v12h2V4h-2zm1-1H8v2h12V3zm-.707.293l-16 16 1.414 1.414 16-16-1.414-1.414z" />
              </svg>
            </span>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
