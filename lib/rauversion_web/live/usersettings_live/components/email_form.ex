defmodule RauversionWeb.UsersettingsLive.EmailForm do
  use RauversionWeb, :live_component

  def render(%{email_changeset: _email_changeset} = assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto py-10 px-4 sm:px-6 lg:py-12 lg:px-8">
    <h1 class="text-3xl font-extrabold text-blue-gray-900">Change Email</h1>

    <.form let={f} for={@email_changeset}
      id="update_email" class="space-y-8 divide-y divide-gray-200"
      phx-submit="save"
    >
    <%= if @email_changeset.action do %>
      <div class="alert alert-danger">
        <p>Oops, something went wrong! Please check the errors below.</p>
      </div>
    <% end %>

    <%= hidden_input f, :action, name: "action", value: "update_email" %>

    <div class="grid grid-cols-1 gap-y-6 sm:grid-cols-6 sm:gap-x-6">
      <div class="sm:col-span-6">
        <h2 class="text-xl font-medium text-blue-gray-900">Change Email</h2>
        <p class="mt-1 text-sm text-blue-gray-500">This information will be displayed publicly so be careful what you share.</p>
      </div>

      <div class="sm:col-span-3">
        <%= label f, :email, class: "block text-sm font-medium text-blue-gray-900" %>
        <%= email_input f, :email, required: true, class: "mt-1 block w-full border-blue-gray-300 rounded-md shadow-sm text-blue-gray-900 sm:text-sm focus:ring-blue-500 focus:border-blue-500" %>
        <%= error_tag f, :email %>
      </div>

      <div class="sm:col-span-3">
        <%= label f, :current_password, for: "current_password_for_email", class: "block text-sm font-medium text-blue-gray-900" %>
        <%= password_input f, :current_password, required: true, name: "current_password", id: "current_password_for_email", class: "mt-1 block w-full border-blue-gray-300 rounded-md shadow-sm text-blue-gray-900 sm:text-sm focus:ring-blue-500 focus:border-blue-500"%>
        <%= error_tag f, :current_password %>
      </div>

      <div class="sm:col-span-6">
        <label for="username" class="block text-sm font-medium text-blue-gray-900">
          Username
        </label>
        <div class="mt-1 flex rounded-md shadow-sm">
          <span class="inline-flex items-center px-3 rounded-l-md border border-r-0 border-blue-gray-300 bg-blue-gray-50 text-blue-gray-500 sm:text-sm">
            <% #= ENV['APP_DOMAIN']%>
            <%= Application.get_env(:rauversion, :app_name) %>
          </span>
          <%= text_input f, :username, required: true, class: "flex-1 block w-full min-w-0 border-blue-gray-300 rounded-none rounded-r-md text-blue-gray-900 sm:text-sm focus:ring-blue-500 focus:border-blue-500" %>
        </div>
      </div>

    </div>

    <div class="pt-8 flex justify-end">
      <%= live_redirect to: "/users/settings/email", class: "bg-white py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-blue-gray-900 hover:bg-blue-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500" do %>
        Cancel
      <% end %>
      <%= submit "Change email", phx_disable_with: "Saving...", class: "bg-white py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-blue-gray-900 hover:bg-blue-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500" %>
    </div>

    </.form>

    </div>
    """
  end
end
