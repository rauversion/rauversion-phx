defmodule RauversionWeb.UserSettingsLive.Invitations do
  use RauversionWeb, :live_component

  alias Rauversion.Accounts

  @impl true
  def handle_event("save", %{"add-team-members" => email}, socket) do
    save_user_invite(socket, :edit, %{"email" => email})
  end

  defp save_user_invite(socket, :edit, %{"email" => email}) do
    case Accounts.get_user_by_email(email) do
      nil ->
        case Accounts.invite_user(%Accounts.User{}, %{
               email: email,
               type: "artist",
               invited_by: socket.assigns.current_user.id
             }) do
          {:ok, user} ->
            {:ok, _} =
              Accounts.deliver_user_invitation_instructions(
                user,
                &Routes.user_invitation_url(socket, :accept, &1)
              )

            Accounts.use_invitation(socket.assigns.current_user)

            {:noreply,
             socket
             |> put_flash(:info, gettext("Invitation sent successfully"))
             |> push_navigate(to: "/users/settings/invitations")}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply,
             assign(socket, :changeset, changeset)
             |> put_flash(:error, gettext("Error, Invitation was not sent"))
             |> push_navigate(to: "/users/settings/invitations")}

          _ ->
            {:noreply,
             socket
             |> put_flash(:error, gettext("There was something wrong sending this invitation"))
             |> push_navigate(to: "/users/settings/invitations")}
        end

      _user ->
        {:noreply,
         socket
         |> put_flash(:error, gettext("Invitation not sent, this person already exists"))
         |> push_navigate(to: "/users/settings/invitations")}
    end
  end

  defp invited_users(current_user) do
    current_user |> Ecto.assoc(:invited_users) |> Rauversion.Repo.all()
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto py-10 px-4 sm:px-6 lg:py-12 lg:px-8">
      <%= if is_creator?(@current_user) do %>
        <h1 class="text-3xl font-extrabold text-blue-gray-900">
          <%= gettext("Invite artists to rauversion") %>
        </h1>

        <h2 class="text-xl font-extrabold text-brand-700">
          <%= gettext("you have %{count} invitations left", %{count: @current_user.invitations_count}) %>
        </h2>

        <div class="space-y-2">
          <div class="space-y-1">
            <.form
              :let={_f}
              for={:tbk}
              id="update_profile"
              phx-target={@myself}
              phx-changesss="validate"
              phx-submit="save"
              class="space-y-2 divide-y divide-gray-200 dark:divide-gray-800"
            >
              <label
                for="add-team-members"
                class="mt-4 block text-sm font-medium text-gray-700 dark:text-gray-300"
              >
                <%= gettext("Invite people") %>
              </label>

              <div class="flex">
                <div class="flex-grow">
                  <input
                    type="text"
                    name="add-team-members"
                    id="add-team-members"
                    class="block w-full rounded-md border-gray-300 dark:bg-gray-900 dark:text-gray-300 dark:border-gray-700 shadow-sm focus:border-sky-500 focus:ring-sky-500 sm:text-sm"
                    placeholder="Email address"
                    aria-describedby="add-team-members-helper"
                  />
                </div>
                <span class="ml-3">
                  <button
                    type="submit"
                    phx_disable_with={gettext("Saving...")}
                    phx-target={@myself}
                    class="inline-flex items-center rounded-md border border-gray-300 dark:border-gray-700 bg-white dark:bg-black px-4 py-2 text-sm font-medium text-gray-700 dark:text-gray-300 shadow-sm hover:bg-gray-50 dark:hover:bg-gray-900 focus:outline-none focus:ring-2 focus:ring-sky-500 focus:ring-offset-2"
                  >
                    <svg
                      class="-ml-2 mr-1 h-5 w-5 text-gray-400"
                      x-description="Heroicon name: mini/plus"
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 20 20"
                      fill="currentColor"
                      aria-hidden="true"
                    >
                      <path d="M10.75 4.75a.75.75 0 00-1.5 0v4.5h-4.5a.75.75 0 000 1.5h4.5v4.5a.75.75 0 001.5 0v-4.5h4.5a.75.75 0 000-1.5h-4.5v-4.5z">
                      </path>
                    </svg>
                    <span><%= gettext("Invite artists") %></span>
                  </button>
                </span>
              </div>
            </.form>
          </div>

          <div class="border-b border-gray-200 dark:border-gray-800">
            <ul role="list" class="divide-y divide-gray-200 dark:divide-gray-800">
              <%= for user <- invited_users(@current_user) do %>
                <li class="flex py-4">
                  <!--<img class="h-10 w-10 rounded-full"
                  src="https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-1.2.1&amp;ixid=eyJhcHBfaWQiOjEyMDd9&amp;auto=format&amp;fit=facearea&amp;facepad=2&amp;w=256&amp;h=256&amp;q=80"
                alt="">-->
                  <div class="ml-3 flex flex-col">
                    <span class="text-sm font-medium text-gray-900 dark:text-gray-100"></span>
                    <span class="text-sm text-gray-500 dark:text-gray-300"><%= user.email %></span>
                  </div>
                </li>
              <% end %>
            </ul>
          </div>
        </div>
      <% else %>
        <.live_component
          id="not-yet-invitations"
          module={RauversionWeb.BlockedView}
          title={gettext("Invitations disabled")}
          subtitle={gettext("Invitations are disabled on your account type")}
          description={gettext("Please send us an email showing us your work")}
          cta={gettext("Request an artist account")}
        />
      <% end %>
    </div>
    """
  end
end
