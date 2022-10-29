defmodule RauversionWeb.UsersettingsLive.ProfileForm do
  use RauversionWeb, :live_component

  def render(%{changeset: _changeset} = assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto py-10 px-4 sm:px-6 lg:py-12 lg:px-8">
    <h1 class="text-3xl font-extrabold text-blue-gray-900"><%= gettext("Account") %></h1>

    <.form
      let={f}
      for={@changeset}
      id="update_profile"
      phx-target={@target}
      phx-change="validate"
      phx-submit="save"
      multipart={true}
      class="space-y-8 divide-y divide-gray-200 dark:divide-gray-800"
      >
      <%= if @changeset.action do %>
        <div class="alert alert-danger">
          <p><%= gettext "Oops, something went wrong! Please check the errors below." %></p>
        </div>
      <% end %>

      <%= hidden_input f, :action, name: "action", value: "update_profile" %>

      <div class="grid grid-cols-1 gap-y-6 sm:grid-cols-6 sm:gap-x-6">
        <div class="sm:col-span-6">
          <h2 class="text-xl font-medium text-blue-gray-900"><%= gettext "Contact Information" %></h2>
          <p class="mt-1 text-sm text-blue-gray-500"><%= gettext "This information will be displayed publicly so be careful what you share." %></p>
        </div>

        <div class="sm:col-span-6">
          <label for="username" class="block text-sm font-medium text-blue-gray-900">
          <%= gettext "Username" %>
          </label>
          <div class="mt-1 flex rounded-md shadow-sm">
            <span class="inline-flex items-center px-3 rounded-l-md border border-r-0 border-blue-gray-300 bg-blue-gray-50 text-blue-gray-500 sm:text-sm">
              <% #= ENV['APP_DOMAIN']%>
              <%= Application.get_env(:rauversion, :app_name, "rauversion.com") %>
            </span>
            <%= text_input f, :username, required: true, class: "flex-1 block w-full min-w-0 border-blue-gray-300 rounded-none rounded-r-md text-blue-gray-900 dark:text-blue-gray-100 dark:bg-gray-900 sm:text-sm focus:ring-blue-500 focus:border-blue-500" %>
          </div>
        </div>

        <div class="sm:col-span-3">
          <%= label f, :first_name, class: "block text-sm font-medium text-blue-gray-900" %>
          <%= text_input f, :first_name, required: true, class: "mt-1 block w-full border-blue-gray-300 rounded-md shadow-sm text-blue-gray-900 dark:text-blue-gray-100 dark:bg-gray-900 sm:text-sm focus:ring-blue-500 focus:border-blue-500" %>
          <%= error_tag f, :first_name %>
        </div>

        <div class="sm:col-span-3">
          <%= label f, :last_name, class: "block text-sm font-medium text-blue-gray-900" %>
          <%= text_input f, :last_name, required: true, class: "mt-1 block w-full border-blue-gray-300 rounded-md shadow-sm text-blue-gray-900 dark:text-blue-gray-100 dark:bg-gray-900 sm:text-sm focus:ring-blue-500 focus:border-blue-500" %>
          <%= error_tag f, :last_name %>
        </div>

        <div class="sm:col-span-3">
          <%= label f, :country, class: "block text-sm font-medium text-blue-gray-900" %>
          <%= text_input f, :country, class: "mt-1 block w-full border-blue-gray-300 rounded-md shadow-sm text-blue-gray-900 dark:text-blue-gray-100 dark:bg-gray-900 sm:text-sm focus:ring-blue-500 focus:border-blue-500" %>
          <%= error_tag f, :country %>
        </div>

        <div class="sm:col-span-3">
          <%= label f, :city, class: "block text-sm font-medium text-blue-gray-900" %>
          <%= text_input f, :city, class: "mt-1 block w-full border-blue-gray-300 rounded-md shadow-sm text-blue-gray-900 dark:text-blue-gray-100 dark:bg-gray-900 sm:text-sm focus:ring-blue-500 focus:border-blue-500" %>
          <%= error_tag f, :city %>
        </div>


        <div class="sm:col-span-6">
          <%= label f, :bio, class: "block text-sm font-medium text-blue-gray-900" %>
          <%= textarea f, :bio, class: "mt-1 block w-full border-blue-gray-300 rounded-md shadow-sm text-blue-gray-900 dark:text-blue-gray-100 dark:bg-gray-900 sm:text-sm focus:ring-blue-500 focus:border-blue-500" %>
          <%= error_tag f, :bio %>
        </div>

        <div class="sm:col-span-6">
          <label for="photo" class="block text-sm font-medium text-blue-gray-900">
          <%= gettext "Photo" %>
          </label>
          <div class="mt-1 flex items-center">

            <%= img_tag(Rauversion.Accounts.avatar_url(@changeset.data, :small),
            class: "inline-block h-12 w-12 rounded-full")
            %>

            <div class="ml-4 flex space-x-2">
              <div class="relative py-2 px-3 border border-blue-gray-300 rounded-md shadow-sm flex items-center cursor-pointer hover:bg-blue-gray-50 focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-offset-blue-gray-50 focus-within:ring-blue-500">
                <%= label f, :avatar, class: "relative text-sm font-medium text-blue-gray-900 pointer-events-none" do %>
                    <span>Change</span>
                    <span class="sr-only"><%= gettext "user photo" %></span>
                <% end %>
                <div phx-drop-target={@uploads.avatar.ref}>
                  <.live_file_input upload={@uploads.avatar} class="absolute inset-0 w-full h-full opacity-0 cursor-pointer border-gray-300 rounded-md" />
                  <% #= live_file_input @uploads.avatar, class: "absolute inset-0 w-full h-full opacity-0 cursor-pointer border-gray-300 rounded-md"%>
                </div>
              </div>

              <button type="button" class="ml-3 bg-transparent py-2 px-3 border border-transparent rounded-md text-sm font-medium text-blue-gray-900 hover:text-blue-gray-700 focus:outline-none focus:border-blue-gray-300 focus:ring-2 focus:ring-offset-2 focus:ring-offset-blue-gray-50 focus:ring-blue-500">
              <%= gettext "Remove" %>
              </button>
            </div>
          </div>
        </div>


        <div class="sm:col-span-6">
          <%= form_input_renderer(f, %{type: :upload, uploads: @uploads, name: :profile_header, label: gettext("Cover image")}) %>
        </div>

      </div>

      <div class="pt-8 flex justify-end space-x-2">
        <%= submit gettext("Change profile information"), phx_disable_with: gettext("Saving..."), class: "bg-white py-2 px-4 border border-gray-300 dark:text-blue-gray-100 dark:bg-gray-900 rounded-md shadow-sm text-sm font-medium text-blue-gray-900 hover:bg-blue-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500" %>
      </div>
    </.form>
    </div>
    """
  end
end
