defmodule RauversionWeb.TrackLive.TrackListingComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component
  alias Rauversion.{Tracks, Repo}

  @impl true
  def mount(socket) do
    # socket = assign(socket, :tracks, Tracks.list_tracks())
    {:ok, socket, temporary_assigns: [messages: []]}
  end

  @impl true
  def handle_event("paginate", %{}, socket) do
    {:noreply,
     socket
     |> assign(:page, socket.assigns.page + 1)
     |> assign(:tracks, list_tracks(socket.assigns))}
  end

  @impl true
  def update(assigns, socket) do
    tracks = list_tracks(assigns)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(page: 1)
     |> assign(tracks: tracks)}
  end

  defp list_tracks(page) do
    Tracks.list_public_tracks()
    |> Rauversion.Repo.paginate(page: page, page_size: 5)
  end

  @impl true
  def handle_event("delete-track", %{"id" => id}, socket) do
    track = Tracks.get_track!(id)

    case RauversionWeb.LiveHelpers.authorize_user_resource(socket, track.user_id) do
      {:ok, socket} ->
        {:ok, _} = Tracks.delete_track(track)
        {:noreply, push_event(socket, "remove-item", %{id: "track-item-#{track.id}"})}

      _err ->
        {:noreply, socket}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div
      class="grid grid-cols-1 gap-y-10 sm:grid-cols-2 gap-x-6 lg:grid-cols-3 xl:grid-cols-4 xl:gap-x-8"
      id="infinite-scroll"
      phx-hook="InfiniteScroll"
      phx-update="append"
      data-page={@page}
      data-paginate-end={'assigns.playlists.total_pages == @page'}>

      <%= for track <- @tracks do %>
        <%= live_redirect to: Routes.track_show_path(@socket, :show, track), id: "track-item-#{track.id}" , class: "group" do %>
          <div class="w-full aspect-w-1 aspect-h-1 bg-gray-200 rounded-lg overflow-hidden xl:aspect-w-7 xl:aspect-h-8">
            <%= img_tag(Rauversion.Tracks.blob_url(track, "cover"), class: "w-full h-full object-center object-cover group-hover:opacity-75") %>
          </div>
          <h3 class="mt-4 text-sm text-gray-700">
            <%= track.title %>
          </h3>
          <p class="mt-1 text-lg font-medium text-gray-900">
            <%= track.user.username %>
          </p>
        <% end %>
      <% end %>
    </div>
    """
  end
end
