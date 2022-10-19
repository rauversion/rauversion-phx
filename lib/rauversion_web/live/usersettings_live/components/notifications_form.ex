defmodule RauversionWeb.UsersettingsLive.NotificationsForm do
  use RauversionWeb, :live_component

  def notification_inputs() do
    [
      %{name: :new_follower_email, type: :checkbox, wrapper_class: "sm:col-span-6"},
      %{name: :new_follower_app, type: :checkbox, wrapper_class: "sm:col-span-6"},
      %{name: :repost_of_your_post_email, type: :checkbox, wrapper_class: "sm:col-span-6"},
      %{name: :repost_of_your_post_app, type: :checkbox, wrapper_class: "sm:col-span-6"},
      %{name: :new_post_by_followed_user_email, type: :checkbox, wrapper_class: "sm:col-span-6"},
      %{name: :new_post_by_followed_user_app, type: :checkbox, wrapper_class: "sm:col-span-6"},
      %{
        name: :like_and_plays_on_your_post_email,
        type: :checkbox,
        wrapper_class: "sm:col-span-6"
      },
      %{name: :like_and_plays_on_your_post_app, type: :checkbox, wrapper_class: "sm:col-span-6"},
      %{name: :comment_on_your_post_email, type: :checkbox, wrapper_class: "sm:col-span-6"},
      %{name: :comment_on_your_post_app, type: :checkbox, wrapper_class: "sm:col-span-6"},
      %{name: :suggested_content_email, type: :checkbox, wrapper_class: "sm:col-span-6"},
      %{name: :suggested_content_app, type: :checkbox, wrapper_class: "sm:col-span-6"},
      %{name: :new_message_email, type: :checkbox, wrapper_class: "sm:col-span-6"},
      %{name: :new_message_app, type: :checkbox, wrapper_class: "sm:col-span-6"}
    ]
  end

  def render(%{changeset: _changeset} = assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto py-10 px-4 sm:px-6 lg:py-12 lg:px-8">
    <h1 class="text-3xl font-extrabold text-blue-gray-900">Change Notifications</h1>

    <.form
      let={f}
      for={@changeset}
      id="update_email"
      phx-target={@target}
      phx-submit="save"
      class="space-y-8 divide-y divide-gray-200 dark:divide-gray-800"
    >
    <%= if @changeset.action do %>
      <div class="alert alert-danger">
        <p><%= gettext "Oops, something went wrong! Please check the errors below." %></p>
      </div>
    <% end %>

    <%= hidden_input f, :action, name: "action", value: "update_notifications" %>

    <div class="grid grid-cols-1 gap-y-6 sm:grid-cols-6 sm:gap-x-6">
      <div class="sm:col-span-6">
        <h2 class="text-xl font-medium text-blue-gray-900"><%= gettext "Notifications" %></h2>
        <p class="mt-1 text-sm text-blue-gray-500"><%= gettext "Notification settings." %></p>
      </div>

      <%= inputs_for f, :notification_settings, fn item -> %>
        <%= for field <- notification_inputs() do %>
          <%= form_input_renderer(item, field ) %>
        <% end %>
      <% end %>
    </div>

    <div class="pt-8 flex justify-end space-x-2">
      <%= submit gettext("Update Notifications"), phx_disable_with: gettext("Saving..."), class: "bg-white py-2 px-4 border border-gray-300 dark:text-blue-gray-100 dark:bg-gray-900 rounded-md shadow-sm text-sm font-medium text-blue-gray-900 hover:bg-blue-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500" %>
    </div>

    </.form>

    </div>
    """
  end
end
