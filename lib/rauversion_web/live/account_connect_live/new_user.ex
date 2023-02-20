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

    case Rauversion.Accounts.register_user(user_params) do
      {:ok, user} ->
        case Rauversion.ConnectedAccounts.create(%{
               user_id: user.id,
               parent_id: socket.assigns.current_user.id
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
      <p>Please specify an account to add.</p>
      Artist URL http://<%= Application.get_env(:rauversion, :domain) %>/jjj

      ,
      Add via
      Password
      Request access from the artist
      Hide artist
      You can hide and unhide artists later, too.
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
            <%= gettext("New user") %>
          </h2>

          <div class="mt-6 grid grid-cols-1 gap-y-6 gap-x-4 sm:grid-cols-6">
            <%= form_input_renderer(
              f,
              %{
                type: :text_input,
                name: :username,
                wrapper_class: "sm:col-span-6"
              }
            ) %>

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
