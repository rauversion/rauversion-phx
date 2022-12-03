defmodule RauversionWeb.PlaylistLive.FormComponent do
  use RauversionWeb, :live_component

  alias Rauversion.Playlists

  @impl true
  def update(%{playlist: playlist, track: track, action: :new} = assigns, socket) do
    playlist = playlist |> Rauversion.Repo.preload(track_playlists: [:track])

    # track = Rauversion.Tracks.get_track!(81) |> Rauversion.Repo.preload(:user)
    track_playlist = %{"track_id" => track.id}

    # playlist = %Rauversion.Playlists.Playlist{playlist | track_playlists: [track_playlist]}

    changeset =
      Playlists.change_playlist(playlist, %{
        "track_playlists" => [track_playlist]
      })

    playlists =
      Rauversion.Playlists.list_playlists_by_user_with_track(track, assigns.current_user)
      |> Rauversion.Repo.all()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:tab, "add-to-tab")
     |> assign(playlist: playlist)
     |> assign(playlists: playlists)
     |> assign(new_track: track)
     |> assign(:user_id, assigns.current_user.id)
     |> assign(:changeset, changeset)}

    # IO.inspect(changeset)
    # IO.inspect(changeset.changes)
    # IO.inspect(changeset.data)
  end

  def update(%{playlist: playlist, action: :edit} = assigns, socket) do
    changeset = Playlists.change_playlist(playlist)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:tab, "add-to-tab")
     |> assign(playlist: playlist)
     |> assign(:user_id, assigns.current_user.id)
     |> assign(:changeset, changeset)
     |> allow_upload(:cover, accept: ~w(.jpg .jpeg .png), max_entries: 1)}
  end

  @impl true
  def handle_event("add-to-tab", %{}, socket) do
    {:noreply, assign(socket, :tab, "add-to-tab")}
  end

  @impl true
  def handle_event("create-playlist-tab", %{}, socket) do
    {:noreply, assign(socket, :tab, "create-playlist-tab")}
  end

  # TODO: securize this
  @impl true
  def handle_event("add-to-playlist", %{"playlist" => id}, socket) do
    playlist = Rauversion.Playlists.get_playlist!(id)
    track = socket.assigns.track

    Rauversion.TrackPlaylists.create_track_playlist(%{
      playlist_id: playlist.id,
      track_id: track.id
    })

    playlists =
      Rauversion.Playlists.list_playlists_by_user_with_track(track, socket.assigns.current_user)
      |> Rauversion.Repo.all()

    {:noreply, socket |> assign(:playlists, playlists)}
  end

  # TODO: securize this
  @impl true
  def handle_event(
        "remove-from-playlist",
        %{"playlist" => _playlist_id, "track-playlist" => track_playlist_id},
        socket
      ) do
    track_playlist = Rauversion.TrackPlaylists.get_track_playlist!(track_playlist_id)
    Rauversion.TrackPlaylists.delete_track_playlist(track_playlist)

    playlists =
      Rauversion.Playlists.list_playlists_by_user_with_track(
        socket.assigns.track,
        socket.assigns.current_user
      )
      |> Rauversion.Repo.all()

    {:noreply, socket |> assign(:playlists, playlists)}
  end

  @impl true
  def handle_event("validate", %{"playlist" => playlist_params}, socket) do
    changeset =
      socket.assigns.playlist
      |> Playlists.change_playlist(playlist_params)
      |> Map.put(:action, :validate)
    IO.inspect("validoooooo!")
    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"playlist" => playlist_params}, socket) do
    save_playlist(socket, socket.assigns.action, playlist_params)
  end

  defp save_playlist(socket, :edit, playlist_params) do
    playlist_params =
      playlist_params
      |> Map.put("cover", files_for(socket, :cover))

    case Playlists.update_playlist(socket.assigns.playlist, playlist_params) do
      {:ok, _playlist} ->
        {:noreply,
         socket
         |> put_flash(:info, "Playlist updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_playlist(socket, :new, playlist_params) do
    playlist_params = playlist_params |> Map.merge(%{"user_id" => socket.assigns.user_id})

    case Playlists.create_playlist(playlist_params) do
      {:ok, playlist} ->
        {:noreply,
         socket
         |> put_flash(:info, "Playlist created successfully")
         |> assign(:playlist, playlist)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
