defmodule RauversionWeb.EventsLive.Components.SchedulingSettingsForm do
  use RauversionWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
      <div class="border mt-6 p-4 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6 dark:bg-black rounded-md">
          <%= form_input_renderer(@f, %{type: :text_input, name: :name, wrapper_class: "sm:col-span-6"}) %>
          <% #= form_input_renderer(@f, %{type: :datetime_input, name: :start_date, wrapper_class: "sm:col-span-2"}) %>
          <%= form_input_renderer(@f, %{type: :text_input, name: :start_date, wrapper_class: "sm:col-span-2", id: "wrap-id", hook: "DatetimeHook"}) %>
          <%= form_input_renderer(@f, %{type: :text_input, name: :end_date, wrapper_class: "sm:col-span-2", id: "wrap-end", hook: "DatetimeHook"}) %>
          <% #= form_input_renderer(@f, %{type: :datetime_input, name: :end_date, wrapper_class: "sm:col-span-2"}) %>
          <%= form_input_renderer(@f, %{type: :select, options: [
            [key: "Daily", value: "daily"],
            [key: "Weekly", value: "weekly"],
            [key: "Once", value: "once"],
          ], wrapper_class: "sm:col-span-2", name: :schedule_type }) %>
          <%= form_input_renderer(@f, %{type: :textarea, name: :description, wrapper_class: "sm:col-span-6"}) %>

          <%= for i <- inputs_for(@f, :schedulings) do %>
            <div class="sm:col-span-6 mt-6 p-4 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6 dark:bg-gray-700 rounded-md border-2 border-white">
              <%= form_input_renderer(i, %{type: :text_input, name: :title, wrapper_class: "sm:col-span-6"}) %>

              <%= form_input_renderer(i, %{type: :text_input, name: :start_date, wrapper_class: "sm:col-span-3", hook: "DatetimeHook"}) %>
              <%= form_input_renderer(i, %{type: :text_input, name: :end_date, wrapper_class: "sm:col-span-3", hook: "DatetimeHook"}) %>
              <%= form_input_renderer(i, %{type: :textarea, name: :short_description, wrapper_class: "sm:col-span-6"}) %>

              <button type="button"
                phx-click="delete-scheduling-item"
                phx-target={@target}
                class="inline-flex justify-center items-center dark:border-2 dark:border-red-600 rounded-lg py-2 px-2 bg-black text-red-600 block text-sm"
                phx-value-setting-index={@f.index}
                phx-value-scheduling-index={i.index}>
                Delete scheduling
              </button>
            </div>
          <% end %>

          <div class="flex justify-end items-center sm:col-span-6 space-x-2">

            <button type="button"
              phx-click="delete-item"
              phx-target={@target}
              class="inline-flex justify-center items-center dark:border-2 dark:border-red-500 rounded-lg py-2 px-2 bg-black text-red-600 block text-sm"
              phx-value-index={@f.index}>
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 19.5l15-15m-15 0l15 15" />
              </svg>
              <span>Delete</span>
            </button>

            <button type="button"
              phx-target={@target}
              phx-value-id={@f.index}
              class="inline-flex justify-center items-center dark:border-2 dark:border-white rounded-lg py-2 px-2 bg-black text-white block text-sm"
              phx-click="add-feature-scheduling">

              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                <path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75m-18 0v-7.5A2.25 2.25 0 015.25 9h13.5A2.25 2.25 0 0121 11.25v7.5m-9-6h.008v.008H12v-.008zM12 15h.008v.008H12V15zm0 2.25h.008v.008H12v-.008zM9.75 15h.008v.008H9.75V15zm0 2.25h.008v.008H9.75v-.008zM7.5 15h.008v.008H7.5V15zm0 2.25h.008v.008H7.5v-.008zm6.75-4.5h.008v.008h-.008v-.008zm0 2.25h.008v.008h-.008V15zm0 2.25h.008v.008h-.008v-.008zm2.25-4.5h.008v.008H16.5v-.008zm0 2.25h.008v.008H16.5V15z" />
              </svg>
              <span>Add scheduling</span>
            </button>

          </div>

      </div>
    """
  end
end
