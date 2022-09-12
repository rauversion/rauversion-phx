defmodule RauversionWeb.Live.EventsLive.Components.FormComponent do
  use RauversionWeb, :live_component

  def render(assigns) do
    ~H"""
      <div class="p-5">
        <.form
          let={f}
          for={@changeset}
          id="playlist-form"
          phx-change="validate"
          phx-submit="save"
          data-controller="gmaps"
          data-action="google-maps-callback@window->maps#initializeMap"
          >

          <h2 class="mx-0 mt-0 mb-4 font-sans text-base font-bold leading-none">
            <%= gettext "Create Event" %>
          </h2>

          <div class="mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">

            <%= form_input_renderer(f, %{type: :text_input, name: :title, wrapper_class: "sm:col-span-6"}) %>

            <%= form_input_renderer(f, %{type: :datetime_input, name: :event_start, wrapper_class: "sm:col-span-3"}) %>
            <%= form_input_renderer(f, %{type: :datetime_input, name: :event_ends, wrapper_class: "sm:col-span-3"}) %>


            <%= form_input_renderer(f, %{type: :textarea, name: :description, wrapper_class: "sm:col-span-6"}) %>

            <div class="sm:col-span-3 space-y-3 flex flex-col justify-between">
              <%= form_input_renderer(f, %{type: :text_input, name: :venue, wrapper_class: ""}) %>

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

            </div>


            <div class="sm:col-span-3 space-y-3">
              <%= form_input_renderer(f, %{type: :upload, uploads: @uploads}) %>
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
                class: "shadow-sm focus:ring-brand-500 focus:border-brand-500 block w-full sm:text-sm border-gray-300 rounded-md dark:bg-gray-900 dark:bg-gray-900 dark:text-gray-100" %>
              </div>
                <p class="mt-2 text-sm text-gray-500 dark:text-gray-300">
                  Type the event address, and confirm the prompt
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
              class: "shadow-sm focus:ring-brand-500 focus:border-brand-500 block w-full sm:text-sm border-gray-300 rounded-md dark:bg-gray-900 dark:bg-gray-900 dark:text-gray-100"
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
