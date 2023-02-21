defmodule RauversionWeb.AccountConnectLive.NewUser do
  use RauversionWeb, :live_component

  def handle_event("validate", %{"user" => user_params}, socket) do
    # socket.assigns.changeset
    changeset =
      %Rauversion.Accounts.User{}
      |> Rauversion.Accounts.change_user_profile(user_params)
      |> Map.put(:action, :validate)

    IO.inspect(user_params)
    IO.inspect(changeset)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    rand = SecureRandom.uuid()

    user_params =
      Map.merge(user_params, %{
        "email" => "internal+#{rand}@xxx.com",
        "password" => "123456"
      })

    # will auto atictivate the assoc (state: "active")
    case Rauversion.Accounts.register_user(user_params) do
      {:ok, user} ->
        case Rauversion.ConnectedAccounts.create(%{
               user_id: user.id,
               parent_id: socket.assigns.current_user.id,
               state: "active"
             }) do
          {:ok, _connected} ->
            {:noreply,
             socket
             |> put_flash(:info, "Artist created successfully")
             |> push_redirect(to: "/#{socket.assigns.current_user.username}/artists")}

          _ ->
            {:noreply, socket}
        end

      e ->
        {:noreply, socket |> assign(changeset: e)}
    end
  end

  def render(assigns) do
    ~H"""
    <div>
      <div>
        <.form
          :let={f}
          for={@changeset}
          phx-target={@myself}
          id="hosts-managers-form"
          phx-change="validate"
          phx-submit="save"
        >
          <h2 class="mx-0 mt-0 mb-4 font-sans text-2xl font-bold leading-none">
            <%= gettext("New artist") %>
          </h2>

          <p class="text-md">Please specify an account to add.</p>

          <div class="mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">
            <div class="mt-1 flex rounded-md shadow-sm md:col-span-6">
              <span class="inline-flex items-center px-3 rounded-l-md border border-r-0 dark:border-gray-700 bg-blue-gray-50 text-blue-gray-500 sm:text-sm">
                <%= Application.get_env(:rauversion, :domain) %>/
              </span>
              <%= text_input(f, :username,
                required: true,
                autocomplete: "off",
                class:
                  "autofill:!bg-yellow-200 dark:bg-gray-900 appearance-none block w-full px-3 py-2 border border-gray-300 dark:border-gray-700 flex-1 block w-full min-w-0 border-blue-gray-300 rounded-none rounded-r-md shadow-sm placeholder-gray-400 dark:placeholder-gray-600 focus:outline-none focus:ring-brand-500 focus:border-brand-500 sm:text-sm"
              ) %>
              <div class="mt-4">
                <%= error_tag(f, :username) %>
              </div>
              <!-- <input class="flex-1 block w-full min-w-0 border-blue-gray-300 rounded-none rounded-r-md text-blue-gray-900 dark:text-blue-gray-100 dark:bg-gray-900 sm:text-sm focus:ring-blue-500 focus:border-blue-500" id="update_profile_username" name="user[username]" required="" type="text" value="michelson">-->
            </div>

            <%= form_input_renderer(
              f,
              %{
                type: :text_input,
                name: :first_name,
                wrapper_class: "sm:col-span-6"
              }
            ) %>

            <%= form_input_renderer(
              f,
              %{
                type: :text_input,
                name: :last_name,
                wrapper_class: "sm:col-span-6"
              }
            ) %>

            <div class="sm:col-span-6 flex justify-end space-x-2">
              <%= submit(gettext("Save"),
                phx_disable_with: gettext("Saving..."),
                class:
                  "inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-brand-600 hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500"
              ) %>
            </div>
          </div>
        </.form>
      </div>
    </div>
    """
  end
end
