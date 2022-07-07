defmodule RauversionWeb.PlaylistLive.FormComponent do
  use RauversionWeb, :live_component

  alias Rauversion.Playlists

  @impl true
  def update(%{playlist: playlist, track: track, action: :new} = assigns, socket) do
    playlist = playlist |> Rauversion.Repo.preload(:track_playlists)

    # track = Rauversion.Tracks.get_track!(81) |> Rauversion.Repo.preload(:user)
    track_playlist = %{"track_id" => track.id}

    # playlist = %Rauversion.Playlists.Playlist{playlist | track_playlists: [track_playlist]}

    changeset =
      Playlists.change_playlist(playlist, %{
        "track_playlists" => [track_playlist]
      })

    playlists =
      Rauversion.Playlists.list_playlists_by_user(assigns.current_user)
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
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("add-to-tab", %{}, socket) do
    {:noreply, assign(socket, :tab, "add-to-tab")}
  end

  @impl true
  def handle_event("create-playlist-tab", %{}, socket) do
    {:noreply, assign(socket, :tab, "create-playlist-tab")}
  end

  @impl true
  def handle_event("validate", %{"playlist" => playlist_params}, socket) do
    # track = Rauversion.Tracks.get_track!(81)
    # playlist = %Rauversion.Playlists.Playlist{playlist | track_playlists: tracks}
    # track_playlist = %{"track_id" => track.id}
    # playlist_params = playlist_params |> Map.merge(%{"track_playlists" => [track_playlist]})

    # a fucking ugly hack, kind of hate Ecto lack of nested form, or maybe I'm missing something?
    # tracks_params =
    #  playlist_params["track_playlists"]
    #  |> Enum.map(fn k ->
    #    {_, v} = k
    #    v
    #  end)
    #  |> Enum.map(fn x ->
    #    %{"track_id"=> x["id"]}
    #  end)

    changeset =
      socket.assigns.playlist
      |> Playlists.change_playlist(playlist_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"playlist" => playlist_params}, socket) do
    save_playlist(socket, socket.assigns.action, playlist_params)
  end

  defp save_playlist(socket, :edit, playlist_params) do
    case Playlists.update_playlist(socket.assigns.playlist, playlist_params) do
      {:ok, _playlist} ->
        {:noreply,
         socket
         |> put_flash(:info, "Playlist updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_playlist(socket, :new, playlist_params) do
    playlist_params = playlist_params |> Map.merge(%{"user_id" => socket.assigns.user_id})

    # a fucking ugly hack, kind of hate Ecto lack of nested form, or maybe I'm missing something?
    # tracks_params =
    #  playlist_params["track_playlists"]
    #  |> Enum.map(fn k ->
    #    {_, v} = k
    #    v
    #  end)
    #  |> Enum.map(fn x ->
    #    %{"track_id" => x["id"]}
    #  end)

    # IO.inspect(playlist_params)

    # playlist_params = playlist_params |> Map.merge(%{"track_playlists" => tracks_params})

    case Playlists.create_playlist(playlist_params) do
      {:ok, playlist} ->
        {:noreply,
         socket
         |> put_flash(:info, "Playlist created successfully")
         |> assign(:playlist, playlist)}

      # |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
