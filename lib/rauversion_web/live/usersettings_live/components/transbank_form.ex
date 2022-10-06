defmodule RauversionWeb.UsersettingsLive.TransbankForm do
  use RauversionWeb, :live_component

  def render(%{changeset: _changeset} = assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto py-10 px-4 sm:px-6 lg:py-12 lg:px-8">
      <%= if is_creator?(@changeset.data) do %>

        <h1 class="text-3xl font-extrabold text-blue-gray-900">
          <%= gettext "Transbank Commerce Settings" %>
        </h1>

        <.form
          let={f}
          for={@changeset}
          id="update_profile"
          phx-target={@target}
          phx-change="validate"
          phx-submit="save"
          class="space-y-8 divide-y divide-gray-200 dark:divide-gray-800"
          >

          <%= if @changeset.action do %>
            <div class="alert alert-danger">
              <p><%= gettext "Oops, something went wrong! Please check the errors below." %></p>
            </div>
          <% end %>

          <%= inputs_for f, :settings, fn ff -> %>

            <%= hidden_input ff, :action, name: "action", value: "update_transbank_settings" %>

            <div class="grid grid-cols-1 gap-y-6 sm:grid-cols-6 sm:gap-x-6">
              <div class="sm:col-span-6">
                <h2 class="text-xl font-medium text-blue-gray-900"><%= gettext "Transbank Commerce code" %></h2>
                <p class="mt-1 text-sm text-blue-gray-500"><%= gettext "Código transbank de producción de 12 dígitos" %></p>
              </div>

              <div class="sm:col-span-3">
                <%= label ff, :tbk_commerce_code, class: "block text-sm font-medium text-blue-gray-900" %>
                <%= text_input ff, :tbk_commerce_code, class: "mt-1 block w-full border-blue-gray-300 rounded-md shadow-sm text-blue-gray-900 dark:text-blue-gray-100 dark:bg-gray-900 sm:text-sm focus:ring-blue-500 focus:border-blue-500" %>
                <%= error_tag ff, :tbk_commerce_code %>
              </div>

              <div class="sm:col-span-6 relative flex items-start">
                <div class="absolute flex h-5 items-center">
                  <%= checkbox(ff, :pst_enabled, class: "h-4 w-4 border-gray-300 text-brand-600 focus:ring-brand-500") %>
                </div>
                <div class="pl-7 text-sm">
                  <label for="privacy-published-to-article" class="font-medium text-gray-900 dark:text-gray-100">
                    <%= gettext "PST enabled" %>
                  </label>
                  <p id="privacy-published-to-article-description" class="text-gray-500">
                    <%= gettext "Article will be plublished on blog listing." %>
                  </p>
                </div>
              </div>

              <div class="sm:col-span-6 relative flex items-start">
                <div class="absolute flex h-5 items-center">
                  <%= checkbox(ff, :tbk_test_mode, class: "h-4 w-4 border-gray-300 text-brand-600 focus:ring-brand-500") %>
                </div>
                <div class="pl-7 text-sm">
                  <label for="privacy-published-to-article" class="font-medium text-gray-900 dark:text-gray-100">
                    <%= gettext "Test mode" %>
                  </label>
                </div>
              </div>


            </div>
          <% end %>

          <div class="pt-8 flex justify-end space-x-2">
            <%= submit gettext("Change information"), phx_disable_with: gettext("Saving..."), class: "bg-white py-2 px-4 border border-gray-300 dark:text-blue-gray-100 dark:bg-gray-900 rounded-md shadow-sm text-sm font-medium text-blue-gray-900 hover:bg-blue-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500" %>
          </div>

        </.form>

      <% else %>
        <.live_component
          id="not-yet-transbank"
          module={RauversionWeb.BlockedView}
          title={gettext("Transbank not allowed")}
          subtitle={gettext("Transbank accounts are not allowed on your account type")}
          description={gettext("Please send us an email showing us your work")}
          cta={gettext("Request an artist account")}
        />
      <% end %>
    </div>
    """
  end
end
