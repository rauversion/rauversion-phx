defmodule RauversionWeb.AccountConnectLive.ExistingUser do
  use RauversionWeb, :live_component
  alias Rauversion.{Accounts, Repo}

  @impl true
  def handle_event("search", params, socket) do
    page = 0

    artists =
      Accounts.artists()
      |> Accounts.latests()
      |> Accounts.search_by_username(params["search"])
      |> Accounts.not_in(socket.assigns.current_user.id)
      |> Repo.paginate(page: page, page_size: 12)

    {:noreply, socket |> assign(:collection, artists)}
  end

  @impl true
  def handle_event("select-artist", %{"artist" => artist}, socket) do
    selected_artist = Rauversion.Accounts.get_user!(artist)

    {:noreply,
     socket
     |> assign(:selected_artist, selected_artist)
     |> assign(:collection, [])}
  end

  @impl true
  def handle_event("confirm", _, socket) do
    # TODO: do the theng
    case Rauversion.ConnectedAccounts.create(%{
           parent_id: socket.assigns.current_user.id,
           user_id: socket.assigns.selected_artist.id
         }) do
      {:ok, _ac} ->
        {:noreply,
         socket
         |> put_flash(:info, "Artist linked successfully")
         |> push_redirect(to: "/#{socket.assigns.current_user.username}/artists")}

      {:error, changeset} ->
        errors = convert_changeset_errors(changeset)
        {:noreply, socket |> assign(:errors, errors)}
    end
  end

  @impl true
  def handle_event("cancel", _, socket) do
    {:noreply, socket |> assign(:errors, nil) |> assign(:selected_artist, nil)}
  end

  def convert_changeset_errors(changeset) do
    out = "errors connecting the account"

    out
  end

  def render(assigns) do
    ~H"""
    <div class="space-y-4">
      <%= if !@selected_artist do %>
        <form>
          <div class="mt-1 flex rounded-md shadow-sm md:col-span-6">
            <span class="inline-flex items-center px-3 rounded-l-md border border-r-0 dark:border-gray-700 bg-blue-gray-50 text-blue-gray-500 sm:text-sm">
              <%= gettext("search artist") %>/
            </span>

            <input
              phx-change="search"
              phx-target={@myself}
              phx-dbounce="500"
              name="search"
              autocomplete="off"
              type="text"
              class="autofill:!bg-yellow-200 dark:bg-gray-900 appearance-none block w-full px-3 py-2 border border-gray-300 dark:border-gray-700 flex-1 block w-full min-w-0 border-blue-gray-300 rounded-none rounded-r-md shadow-sm placeholder-gray-400 dark:placeholder-gray-600 focus:outline-none focus:ring-brand-500 focus:border-brand-500 sm:text-sm"
            />
          </div>
        </form>

        <%= for artist <- @collection do %>
          <div class="dark:bg-gray-900 bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
            <dt class="text-sm font-medium text-gray-500">
              <%= artist.username %>
            </dt>
            <dd class="mt-1 text-sm text-gray-900 sm:col-span-2 sm:mt-0">
              <button
                type="button"
                phx-click="select-artist"
                class="font-medium text-indigo-600 hover:text-indigo-500 dark:text-indigo-300 dark:hover:text-indigo-200"
                phx-value-artist={artist.id}
                phx-target={@myself}
              >
                <%= gettext("select") %>
              </button>
            </dd>
          </div>
        <% end %>
      <% end %>

      <div :if={@selected_artist} class="space-y-4">
        <p>Selected! <%= @selected_artist.username %> Send the connect invitation to the artist</p>

        <div class="flex items-center space-x-4">
          <button
            phx-click="confirm"
            phx-target={@myself}
            class="w-full rounded-md border border-transparent bg-indigo-600 py-3 px-4 text-base font-medium text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 focus:ring-offset-gray-50"
          >
            <%= gettext("Send connect request") %>
          </button>

          <button type="button" phx-click="cancel" phx-target={@myself}>
            <%= gettext("cancel") %>
          </button>
        </div>

        <p :if={@errors} class="text-red-600"><%= @errors %></p>
      </div>
    </div>
    """
  end
end
