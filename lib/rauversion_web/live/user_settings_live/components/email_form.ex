defmodule RauversionWeb.UserSettingsLive.EmailForm do
  use RauversionWeb, :live_component

  def render(%{changeset: _changeset} = assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto py-10 px-4 sm:px-6 lg:py-12 lg:px-8">
      <h1 class="text-3xl font-extrabold text-blue-gray-900">Change Email</h1>

      <.form
        :let={f}
        for={@changeset}
        id="update_email"
        phx-target={@target}
        phx-submit="save"
        class="space-y-8 divide-y divide-gray-200 dark:divide-gray-800"
      >
        <%= if @changeset.action do %>
          <div class="alert alert-danger">
            <p><%= gettext("Oops, something went wrong! Please check the errors below.") %></p>
          </div>
        <% end %>

        <%= hidden_input(f, :action, name: "action", value: "update_email") %>

        <div class="grid grid-cols-1 gap-y-6 sm:grid-cols-6 sm:gap-x-6">
          <div class="sm:col-span-6">
            <h2 class="text-xl font-medium text-blue-gray-900"><%= gettext("Change Email") %></h2>
            <p class="mt-1 text-sm text-blue-gray-500">
              <%= gettext("This information will be displayed publicly so be careful what you share.") %>
            </p>
          </div>

          <div class="sm:col-span-3">
            <%= label(f, :email, class: "block text-sm font-medium text-blue-gray-900") %>
            <%= email_input(f, :email,
              required: true,
              class:
                "mt-1 block w-full border-blue-gray-300 rounded-md shadow-sm text-blue-gray-900 sm:text-sm dark:text-blue-gray-100 dark:bg-gray-900 focus:ring-blue-500 focus:border-blue-500"
            ) %>
            <%= error_tag(f, :email) %>
          </div>

          <div class="sm:col-span-3">
            <%= label(f, :current_password,
              for: "current_password_for_email",
              class: "block text-sm font-medium text-blue-gray-900"
            ) %>
            <%= password_input(f, :current_password,
              required: true,
              name: "current_password",
              id: "current_password_for_email",
              class:
                "mt-1 block w-full border-blue-gray-300 dark:text-blue-gray-100 dark:bg-gray-900 rounded-md shadow-sm text-blue-gray-900 sm:text-sm focus:ring-blue-500 focus:border-blue-500"
            ) %>
            <%= error_tag(f, :current_password) %>
          </div>
        </div>

        <div class="pt-8 flex justify-end space-x-2">
          <%= submit(gettext("Change email"),
            phx_disable_with: gettext("Saving..."),
            class:
              "bg-white py-2 px-4 border border-gray-300 dark:text-blue-gray-100 dark:bg-gray-900 rounded-md shadow-sm text-sm font-medium text-blue-gray-900 dark:text-blue-gray-100 dark:bg-gray-900 hover:bg-blue-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
          ) %>
        </div>
      </.form>
    </div>
    """
  end
end
