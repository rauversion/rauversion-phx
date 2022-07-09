defmodule RauversionWeb.UsersettingsLive.ContactForm do
  use RauversionWeb, :live_component

  def render(%{profile_changeset: _profile_changeset} = assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto py-10 px-4 sm:px-6 lg:py-12 lg:px-8">
    <h1 class="text-3xl font-extrabold text-blue-gray-900">Account</h1>

    <.form let={f}
      for={@profile_changeset}
      multipart={true}
      id="update_profile">
      <%= if @profile_changeset.action do %>
        <div class="alert alert-danger">
          <p>Oops, something went wrong! Please check the errors below.</p>
        </div>
      <% end %>

      <%= hidden_input f, :action, name: "action", value: "update_profile" %>

      <div class="grid grid-cols-1 gap-y-6 sm:grid-cols-6 sm:gap-x-6">
        <div class="sm:col-span-6">
          <h2 class="text-xl font-medium text-blue-gray-900">Contact Information</h2>
          <p class="mt-1 text-sm text-blue-gray-500">This information will be displayed publicly so be careful what you share.</p>
        </div>

        <div class="sm:col-span-3">
          <%= label f, :first_name, class: "block text-sm font-medium text-blue-gray-900" %>
          <%= text_input f, :first_name, required: true, class: "mt-1 block w-full border-blue-gray-300 rounded-md shadow-sm text-blue-gray-900 sm:text-sm focus:ring-blue-500 focus:border-blue-500" %>
          <%= error_tag f, :first_name %>
        </div>

        <div class="sm:col-span-3">
          <%= label f, :last_name, class: "block text-sm font-medium text-blue-gray-900" %>
          <%= text_input f, :last_name, required: true, class: "mt-1 block w-full border-blue-gray-300 rounded-md shadow-sm text-blue-gray-900 sm:text-sm focus:ring-blue-500 focus:border-blue-500" %>
          <%= error_tag f, :last_name %>
        </div>

        <div class="sm:col-span-3">
          <%= label f, :username, class: "block text-sm font-medium text-blue-gray-900" %>
          <%= text_input f, :username, required: true, class: "mt-1 block w-full border-blue-gray-300 rounded-md shadow-sm text-blue-gray-900 sm:text-sm focus:ring-blue-500 focus:border-blue-500" %>
          <%= error_tag f, :username %>
        </div>

        <div class="sm:col-span-6">
          <label for="photo" class="block text-sm font-medium text-blue-gray-900">
            Photo
          </label>
          <div class="mt-1 flex items-center">

            <%= img_tag(Rauversion.Accounts.avatar_url(@profile_changeset.data),
            class: "inline-block h-12 w-12 rounded-full")
            %>

            <div class="ml-4 flex">
              <div class="relative bg-white py-2 px-3 border border-blue-gray-300 rounded-md shadow-sm flex items-center cursor-pointer hover:bg-blue-gray-50 focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-offset-blue-gray-50 focus-within:ring-blue-500">
                <label for="user-photo" class="relative text-sm font-medium text-blue-gray-900 pointer-events-none">
                  <span>Change</span>
                  <span class="sr-only"> user photo</span>
                </label>

                <input
                  class="absolute inset-0 w-full h-full opacity-0 cursor-pointer border-gray-300 rounded-md"
                  type="file"
                  name="user[avatar]"
                  id="user_avatar">
              </div>
              <button type="button" class="ml-3 bg-transparent py-2 px-3 border border-transparent rounded-md text-sm font-medium text-blue-gray-900 hover:text-blue-gray-700 focus:outline-none focus:border-blue-gray-300 focus:ring-2 focus:ring-offset-2 focus:ring-offset-blue-gray-50 focus:ring-blue-500">
                Remove
              </button>
            </div>
          </div>
        </div>

      </div>

      <div class="pt-8 grid grid-cols-1 gap-y-6 sm:grid-cols-6 sm:gap-x-6">
        <div class="sm:col-span-6">
          <h2 class="text-xl font-medium text-blue-gray-900">Personal Information</h2>
          <p class="mt-1 text-sm text-blue-gray-500">This information will be displayed publicly so be careful what you share.</p>
        </div>

        <div class="sm:col-span-3">
          <label for="email-address" class="block text-sm font-medium text-blue-gray-900">
            Email address
          </label>
          <input type="text" name="email-address" id="email-address" autocomplete="email" class="mt-1 block w-full border-blue-gray-300 rounded-md shadow-sm text-blue-gray-900 sm:text-sm focus:ring-blue-500 focus:border-blue-500">
        </div>

        <div class="sm:col-span-3">
          <label for="phone-number" class="block text-sm font-medium text-blue-gray-900">
            Phone number
          </label>
          <input type="text" name="phone-number" id="phone-number" autocomplete="tel" class="mt-1 block w-full border-blue-gray-300 rounded-md shadow-sm text-blue-gray-900 sm:text-sm focus:ring-blue-500 focus:border-blue-500">
        </div>

        <div class="sm:col-span-3">
          <label for="country" class="block text-sm font-medium text-blue-gray-900">
            Country
          </label>
          <select id="country" name="country" autocomplete="country-name" class="mt-1 block w-full border-blue-gray-300 rounded-md shadow-sm text-blue-gray-900 sm:text-sm focus:ring-blue-500 focus:border-blue-500">
            <option></option>
            <option>United States</option>
            <option>Canada</option>
            <option>Mexico</option>
            <option>Chile</option>
          </select>
        </div>

        <div class="sm:col-span-3">
          <label for="language" class="block text-sm font-medium text-blue-gray-900">
            Language
          </label>
          <input type="text" name="language" id="language" class="mt-1 block w-full border-blue-gray-300 rounded-md shadow-sm text-blue-gray-900 sm:text-sm focus:ring-blue-500 focus:border-blue-500">
        </div>

        <p class="text-sm text-blue-gray-500 sm:col-span-6">This account was created on <time datetime="2017-01-05T20:35:40">January 5, 2017, 8:35:40 PM</time>.</p>
      </div>

      <div class="pt-8 flex justify-end">
        <button type="button" class="bg-white py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-blue-gray-900 hover:bg-blue-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
          Cancel
        </button>
        <%= submit "Change information", class: "bg-white py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-blue-gray-900 hover:bg-blue-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500" %>
      </div>

    </.form>
    </div>
    """
  end
end
