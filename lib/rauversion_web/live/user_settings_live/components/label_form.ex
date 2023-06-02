defmodule RauversionWeb.UserSettingsLive.LabelForm do
  use RauversionWeb, :live_component

  def render(%{changeset: _changeset} = assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto py-10 px-4 sm:px-6 lg:py-12 lg:px-8 space-y-4">
      <h1 class="text-3xl font-extrabold text-blue-gray-900"><%= gettext("Register Label") %></h1>

      <%= if Application.get_env(:rauversion, :disabled_label_registrations) == "false" do %>
        <.form
          :let={f}
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
              <p><%= gettext("Oops, something went wrong! Please check the errors below.") %></p>
            </div>
          <% end %>

          <%= hidden_input(f, :action, name: "action", value: "update_label") %>

          <div class="grid grid-cols-1 gap-y-6 sm:grid-cols-6 sm:gap-x-6">
            <div class="sm:col-span-6">
              <h2 class="text-xl font-medium text-blue-gray-900 ml-5">
                <%= gettext("Activate label") %>
              </h2>
              <p class="mt-1 text-sm text-blue-gray-500">
                <%= gettext("When enabled the account will became a label.") %>
              </p>
            </div>

            <div class="absolute flex h-5 items-center">
              <%= checkbox(f, :label,
                class: "h-4 w-4 border-gray-300 text-brand-600 focus:ring-brand-500"
              ) %>
            </div>
          </div>

          <div class="pt-8 flex justify-end space-x-2">
            <%= submit(gettext("Change profile information"),
              phx_disable_with: gettext("Saving..."),
              class:
                "bg-white py-2 px-4 border border-gray-300 dark:text-blue-gray-100 dark:bg-gray-900 rounded-md shadow-sm text-sm font-medium text-blue-gray-900 hover:bg-blue-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
            ) %>
          </div>
        </.form>
      <% else %>
        <p class="prose lg:prose-xl dark:text-white">
          Welcome to Rauversion, a music streaming platform that offers a unique opportunity for music labels to showcase their artists and connect with a global audience.
          If you're interested in becoming a label on Rauversion, we invite you to apply for a label account.
        </p>

        <div class="flex justify-center my-4">
          <a
            href="mailto:info@rauversion.com"
            class="border p-6 rounded-sm hover:bg-white hover:text-black"
          >
            Sends us an email
          </a>
        </div>

        <p class="prose lg:prose-lg dark:text-white">
          As a label on Rauversion, you'll have access to a range of tools and features that allow you to promote your artists,
          track their performance, and connect with fans around the world. Our platform is designed to make it easy for labels to reach new audiences and build their brands online.

          To apply for a label account, please fill out our application form and provide some basic information about your label and the artists you represent. We'll review your application and
          get back to you as soon as possible with next steps.
        </p>
        <p class="prose lg:prose-lg dark:text-white">
          Thank you for your interest in Rauversion, and we look forward to working with you to bring great music to the world!
        </p>
      <% end %>
    </div>
    """
  end
end
