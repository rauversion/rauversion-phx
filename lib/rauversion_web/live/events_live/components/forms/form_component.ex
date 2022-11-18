defmodule RauversionWeb.Live.EventsLive.Components.FormComponent do
  use RauversionWeb, :live_component

  alias Rauversion.Accounts.Settings

  def has_stripe?(user_id) do
    case user_id do
      nil ->
        false

      _ ->
        case Rauversion.Accounts.find_by_credential_provider("stripe", user_id) do
          %Rauversion.OauthCredentials.OauthCredential{} -> false
          _ -> true
        end
    end
  end

  def has_transbank?(user) do
    with %{settings: _settings = %Settings{tbk_commerce_code: tbk_code}} <-
           user do
      !(tbk_code |> is_binary())
    else
      _ -> nil
    end

    #!(user.settings.tbk_commerce_code |> is_binary())
  end

  def handle_event("publish-event", _, socket) do
    event =
      case socket.assigns.event do
        %{state: "published"} ->
          Rauversion.Events.unpublish_event!(socket.assigns.event)

        _ ->
          Rauversion.Events.publish_event!(socket.assigns.event)
      end

    {:noreply, assign(:event, event)}
  end

  def button_label(event) do
    case event do
      %{state: "published"} -> gettext("Unpublish Event")
      _ -> gettext("Publish Event")
    end
  end

  def event_status_label(event) do
    case event do
      %{state: "published"} -> gettext("Your event is published")
      _ -> gettext("Your event has not been published")
    end
  end

  def render(assigns) do
    ~H"""
      <div class="p-5">

          <h2 class="mx-0 mt-0 mb-4 font-sans text-2xl font-bold leading-none">
            <%= if @event.id do %>
              <%= gettext "Edit Event" %>
            <% else %>
              <%= gettext "Create Event" %>
            <% end %>
          </h2>

          <div class="flex justify-end items-center space-x-3">
            <span class="text-xs dark:text-gray-400">
              <%= event_status_label(@event) %>
            </span>
            <button
              phx-click={"publish-event"}
              phx-target={@myself}
              class={["inline-flex items-center rounded-md border border-transparent bg-green-600 px-3 py-2 text-sm font-medium leading-4 text-white shadow-sm hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2"]}
              >
              <%= button_label(@event) %>
            </button>
          </div>


        <.form
          let={f}
          for={@changeset}
          id="events-form"
          phx-change="validate"
          phx-submit="save"
          data-controller="gmaps"
          data-action="google-maps-callback@window->maps#initializeMap"
          >

          <div class="mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">

            <%= form_input_renderer(f, %{type: :text_input, name: :title, wrapper_class: "sm:col-span-6"}) %>

            <%= form_input_renderer(f, %{type: :datetime_input, name: :event_start, wrapper_class: "sm:col-span-3"}) %>
            <%= form_input_renderer(f, %{type: :datetime_input, name: :event_ends, wrapper_class: "sm:col-span-3"}) %>
            <%= form_input_renderer(f, %{type: :textarea, name: :description, wrapper_class: "sm:col-span-6"}) %>

            <div class="sm:col-span-3 space-y-3 flex flex-col justify-between">
              <%= form_input_renderer(f, %{type: :text_input, name: :venue, wrapper_class: ""}) %>
              <%= form_input_renderer(f, %{type: :select, options: [
                [key: "All ages", value: "all", disabled: true],
                [key: "13+", value: "13"],
                [key: "16+", value: "16"],
                [key: "17+", value: "17"],
                [key: "18+", value: "18"],
                [key: "19+", value: "19"],
                [key: "20+", value: "20"],
                [key: "21+", value: "21"]
              ], wrapper_class: nil, name: :age_requirement }) %>

              <div class="flex items-center space-x-2">
                <div class="flex items-center">
                  <label for="push-everything" class="block text-md font-bold text-gray-700 dark:text-gray-300">
                  <%= gettext "Privacy" %>
                  </label>
                </div>

                <div class="flex items-center">
                  <%= radio_button f, :private, true, class: "focus:ring-brand-500 h-4 w-4 text-brand-600 border-gray-300" %>
                  <label for="push-everything" class="ml-3 block text-sm font-medium text-gray-700 dark:text-gray-300">
                  <%= gettext "Private" %>
                  </label>
                </div>

                <div class="flex items-center">
                  <%= radio_button f, :private, false, class: "focus:ring-brand-500 h-4 w-4 text-brand-600 border-gray-300" %>
                  <label for="push-email" class="ml-3 block text-sm font-medium text-gray-700 dark:text-gray-300">
                  <%= gettext "Public" %>
                  </label>
                </div>
              </div>

              <div class="flex items-center justify-between space-x-2">
                <%= inputs_for f, :event_settings, fn i -> %>
                  <div class="sm:w-1/2 flex flex-col justify-start space-y-2">
                    <%= form_input_renderer(i, %{type: :select, options: [
                        [key: "none", value: "none"],
                        [key: "stripe", value: "stripe", disabled: has_stripe?(@event.user_id)],
                        [key: "transbank", value: "transbank", disabled: has_transbank?(@current_user)]
                      ], wrapper_class: nil,
                      name: :payment_gateway,
                      hint: gettext("para transbank usaremos tu codigo de comercio de los ajustes") })
                    %>
                  </div>
                  <div class="sm:w-1/2 flex flex-col justify-start space-y-2">
                    <%= form_input_renderer(i,
                      %{
                        type: :select,
                        options: [
                          [key: "CLP", value: "clp", disabled: false],
                          [key: "USD", value: "usd", disabled: false],
                          [key: "EUR", value: "eur", disabled: false]
                        ],
                        wrapper_class: nil,
                        name: :ticket_currency
                      })
                  %>

                  </div>
                <% end %>
              </div>

            </div>


            <div class="sm:col-span-3 space-y-3">
              <%= form_input_renderer(f, %{type: :upload, uploads: @uploads, name: :cover, label: gettext("Event image")}) %>
            </div>

          </div>



          <div class="mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">

            <% #= form_input_renderer(f, %{type: :text_input, name: :location, wrapper_class: nil}) %>

            <div class="sm:col-span-6">
              <%= label f, :location, class: "block text-sm font-medium text-gray-700 dark:text-gray-300" %>
              <div class="mt-1">
                <%= text_input f,
                :location, placeholder: "type location",
                "data-gmaps-target": "field",
                autocomplete: "false",
                "data-action": "keydown->maps#preventSubmit",
                class: "shadow-sm focus:ring-brand-500 focus:border-brand-500 block w-full sm:text-sm border-gray-300 dark:border-gray-600 rounded-md dark:bg-gray-900 dark:bg-gray-900 dark:text-gray-100" %>
              </div>
                <p class="mt-2 text-sm text-gray-500 dark:text-gray-300">
                  <%= gettext("Type the event address, and confirm the prompt") %>
                </p>
            </div>

            <%= hidden_input f, :lat,
              "data-gmaps-target": "latitude",
              autocomplete: "false",
              "data-action": "keydown->maps#preventSubmit",
              class: "shadow-sm focus:ring-brand-500 focus:border-brand-500 block w-full sm:text-sm border-gray-300 rounded-md dark:bg-gray-900 dark:bg-gray-900 dark:text-gray-100"
            %>

            <%= hidden_input f, :lng,
              "data-gmaps-target": "longitude",
              autocomplete: "false",
              "data-action": "keydown->maps#preventSubmit",
              class: "shadow-sm focus:ring-brand-500 focus:border-brand-500 block w-full sm:text-sm border-gray-300 rounded-md dark:bg-gray-900 dark:bg-gray-900 dark:text-gray-100"
            %>

            <%= hidden_input f, :country,
              "data-gmaps-target": "country",
              autocomplete: "false",
              "data-action": "keydown->maps#preventSubmit",
              class: "shadow-sm focus:ring-brand-500 focus:border-brand-500 block w-full sm:text-sm border-gray-300 rounded-md dark:bg-gray-900 dark:bg-gray-900 dark:text-gray-100"
            %>

            <%= hidden_input f, :city,
              "data-gmaps-target": "city",
              autocomplete: "false",
              "data-action": "keydown->maps#preventSubmit",
              class: "shadow-sm focus:ring-brand-500 focus:border-brand-500 block w-full sm:text-sm border-gray-300 rounded-md dark:bg-gray-900 dark:bg-gray-900 dark:text-gray-100"
            %>

            <%= hidden_input f, :province,
              "data-gmaps-target": "province",
              autocomplete: "false",
              "data-action": "keydown->maps#preventSubmit",
              class: "shadow-sm focus:ring-brand-500 focus:border-brand-500 block w-full sm:text-sm border-gray-300 dark:border-gray-600 rounded-md dark:bg-gray-900 dark:bg-gray-900 dark:text-gray-100"
            %>

            <div class="sm:col-span-6" phx-update="ignore" id="main-map">
              <div class="w-full h-64" data-gmaps-target="map"></div>
            </div>

          </div>

          <div class="mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">

            <%= inputs_for f, :event_settings, fn i -> %>
              <div class="sm:col-span-3 flex flex-col justify-start space-y-2">
                <%= form_input_renderer(i, %{type: :text_input, name: :participant_label, wrapper_class: "sm:col-span-6"}) %>
                <%= form_input_renderer(i, %{type: :textarea, name: :participant_description, wrapper_class: "sm:col-span-6"}) %>
              </div>
              <div class="sm:col-span-3 flex flex-col justify-start space-y-2">
                <%= form_input_renderer(i, %{type: :text_input, name: :sponsors_label, wrapper_class: ""}) %>
                <%= form_input_renderer(i, %{type: :textarea, name: :sponsors_description, wrapper_class: ""}) %>
                <%= form_input_renderer(i, %{type: :checkbox, name: :accept_sponsors, wrapper_class: ""}) %>
              </div>
              <div class="sm:col-span-3 flex flex-col justify-start space-y-2">
                <%= form_input_renderer(i, %{type: :text_input, name: :scheduling_label, wrapper_class: "sm:col-span-6"}) %>
                <%= form_input_renderer(i, %{type: :textarea, name: :scheduling_description, wrapper_class: "sm:col-span-6"}) %>
              </div>
            <% end %>

            <div class="sm:col-span-6 flex justify-end">
              <%= submit gettext("Save"), phx_disable_with: gettext("Saving..."), class: "inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-brand-600 hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500" %>
            </div>

          </div>

        </.form>
      </div>
    """
  end
end
