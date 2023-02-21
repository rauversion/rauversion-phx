defmodule RauversionWeb.AccountConnectLive.ExistingUser do
  use RauversionWeb, :live_component
  alias Rauversion.{Accounts, Repo}

  def handle_event("search", params, socket) do
    IO.inspect(params)
    page = 0

    artists =
      Accounts.artists()
      |> Accounts.latests()
      |> Accounts.search_by_username(params["search"])
      |> Accounts.not_in(socket.assigns.current_user.id)
      |> Repo.paginate(page: page, page_size: 12)

    {:noreply, socket |> assign(:collection, artists)}
  end

  def handle_event("select-artist", %{"artist" => artist}, socket) do
    selected_artist = Rauversion.Accounts.get_user!(artist)
    {:noreply, socket |> assign(:selected_artist, selected_artist)}
  end

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

      _ ->
        {:noreply, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <div>
      live components here existing user
      <form>
        <input
          phx-change="search"
          phx-target={@myself}
          phx-dbounce="500"
          name="search"
          type="text"
          class="bg-black border border-white"
        />
      </form>

      <%= for artist <- @collection do %>
        <p phx-click="select-artist" phx-value-artist={artist.id} phx-target={@myself}>
          <%= artist.username %>
        </p>
      <% end %>

      <div :if={@selected_artist}>
        Selected! <%= @selected_artist.username %> Send the connect invitation to the artist
        <button phx-click="confirm" phx-target={@myself}>
          Go!
        </button>
      </div>
    </div>
    """
  end
end
