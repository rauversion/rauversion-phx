defmodule RauversionWeb.UsersettingsLive.SecurityForm do
  use RauversionWeb, :live_component

  @impl true
  def render(%{changeset: _changeset} = assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto py-10 px-4 sm:px-6 lg:py-12 lg:px-8">
    <h1 class="text-3xl font-extrabold text-blue-gray-900">Security</h1>

    <.form
      let={f}
      for={@changeset}
      id="update_password"
      phx-target={@target}
      phx-submit="save"
      class="space-y-8 divide-y divide-gray-200"
      >
      <%= if @changeset.action do %>
        <div class="alert alert-danger">
          <p>Oops, something went wrong! Please check the errors below.</p>
        </div>
      <% end %>

      <%= hidden_input f, :action, name: "action", value: "update_password" %>

      <div class="grid grid-cols-1 gap-y-6 sm:grid-cols-6 sm:gap-x-6">
        <div class="sm:col-span-6">
          <h2 class="text-xl font-medium text-blue-gray-900">Change Password</h2>
          <p class="mt-1 text-sm text-blue-gray-500">This information will be displayed publicly so be careful what you share.</p>
        </div>

        <div class="sm:col-span-3">
          <%= label f, :password, "New password", class: "block text-sm font-medium text-blue-gray-900" %>
          <%= password_input f, :password, required: true, class: "mt-1 block w-full border-blue-gray-300 rounded-md shadow-sm text-blue-gray-900 sm:text-sm focus:ring-blue-500 focus:border-blue-500" %>
          <%= error_tag f, :password %>
        </div>

        <div class="sm:col-span-3">
          <%= label f, :password_confirmation, "Confirm new password", class: "block text-sm font-medium text-blue-gray-900" %>
          <%= password_input f, :password_confirmation, required: true, class: "mt-1 block w-full border-blue-gray-300 rounded-md shadow-sm text-blue-gray-900 sm:text-sm focus:ring-blue-500 focus:border-blue-500" %>
          <%= error_tag f, :password_confirmation %>
        </div>

        <div class="sm:col-span-3">
          <%= label f, :current_password, for: "current_password_for_password", class: "block text-sm font-medium text-blue-gray-900" %>
          <%= password_input f, :current_password, required: true, class: "mt-1 block w-full border-blue-gray-300 rounded-md shadow-sm text-blue-gray-900 sm:text-sm focus:ring-blue-500 focus:border-blue-500" %>
          <%= error_tag f, :current_password %>
        </div>

      </div>


      <div class="pt-8 flex justify-end space-x-2">
        <%= live_redirect to: @return_to, class: "bg-white py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-blue-gray-900 hover:bg-blue-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500" do %>
          Cancel
        <% end %>
        <%= submit "Change password", phx_disable_with: "Saving...", class: "bg-white py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-blue-gray-900 hover:bg-blue-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500" %>
      </div>

    </.form>

    </div>
    """
  end
end
