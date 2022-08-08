defmodule RauversionWeb.TrackLive.TrackListingComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component
  alias Rauversion.{Tracks, Repo}

  @impl true
  def mount(socket) do
    tracks = list_tracks(1)
    tracks_meta = track_meta(tracks)

    socket =
      socket
      |> assign(page: 1)
      |> assign(:track_meta, tracks_meta)
      |> assign(:tracks, tracks.entries)

    {:ok, socket, temporary_assigns: [tracks: []]}
  end

  defp track_meta(tracks) do
    %{
      page_number: tracks.page_number,
      page_size: tracks.page_size,
      total_entries: tracks.total_entries,
      total_pages: tracks.total_pages
    }
  end

  defp list_tracks(page) do
    Tracks.list_public_tracks()
    |> Rauversion.Tracks.with_processed()
    |> Repo.paginate(page: page, page_size: 5)
  end

  @impl true
  def handle_event("paginate", %{}, socket) do
    if socket.assigns.page == socket.assigns.track_meta.total_pages do
      {:noreply, socket}
    else
      page = socket.assigns.page + 1
      tracks = list_tracks(page)

      tracks_meta = %{
        page_number: tracks.page_number,
        page_size: tracks.page_size,
        total_entries: tracks.total_entries,
        total_pages: tracks.total_pages
      }

      {:noreply,
       socket
       |> assign(page: page)
       |> assign(:track_meta, tracks_meta)
       |> assign(tracks: tracks.entries)}
    end
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
      phx-target={@myself}
      data-total-pages={assigns.track_meta.total_pages}
      data-paginate-end={assigns.track_meta.total_pages == @page}>

      <%= for track <- @tracks do %>
        <%= live_redirect to: Routes.track_show_path(@socket, :show, track), id: "track-item-#{track.id}" , class: "group" do %>
          <div class="w-full aspect-w-1 aspect-h-1 bg-gray-200 dark:bg-gray-900 rounded-lg overflow-hidden xl:aspect-w-7 xl:aspect-h-8">
            <%= img_tag(Rauversion.Tracks.blob_url(track, "cover"), class: "w-full h-full object-center object-cover group-hover:opacity-75") %>
          </div>
          <h3 class="mt-4 text-sm text-gray-700 dark:text-gray-300">
            <%= track.title %>
          </h3>
          <p class="mt-1 text-lg font-medium text-gray-900 dark:text-gray-100 ">
            <%= track.user.username %>
          </p>
        <% end %>
      <% end %>
    </div>
    """
  end
end
