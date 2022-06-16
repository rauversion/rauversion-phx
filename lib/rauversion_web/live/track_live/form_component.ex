defmodule RauversionWeb.TrackLive.FormComponent do
  use RauversionWeb, :live_component

  alias Rauversion.Tracks

  @impl true
  def update(%{track: track} = assigns, socket) do
    changeset = Tracks.change_track(track)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> allow_upload(:cover, accept: ~w(.jpg .jpeg .png), max_entries: 1)
     |> allow_upload(:audio,
       accept: ~w(.mp3 .mp4 .wav),
       max_entries: 1,
       max_file_size: 200_000_000
     )}
  end

  @impl true
  def handle_event("validate", %{"track" => track_params} = params, socket) do
    track_params = track_params |> Map.put("user_id", socket.assigns.current_user.id)

    changeset =
      socket.assigns.track
      |> Tracks.change_track(track_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"track" => track_params}, socket) do
    track_params = track_params |> Map.put("user_id", socket.assigns.current_user.id)

    save_track(socket, socket.assigns.action, track_params)
  end

  defp save_track(socket, :edit, track_params) do
    # {completed, []} = uploaded_entries(socket, :cover)
    # socket.assigns.uploads.cover

    track_params =
      track_params
      |> Map.put("cover", files_for(socket, :cover))
      |> Map.put("audio", files_for(socket, :audio))

    IO.inspect(track_params)

    case Tracks.update_track(socket.assigns.track, track_params) do
      {:ok, _track} ->
        {:noreply,
         socket
         |> put_flash(:info, "Track updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_track(socket, :new, track_params) do
    case Tracks.create_track(track_params) do
      {:ok, _track} ->
        {:noreply,
         socket
         |> put_flash(:info, "Track created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp files_for(socket, kind) do
    case uploaded_entries(socket, kind) do
      {[_ | _] = entries, []} ->
        uploaded_files =
          Enum.map(entries, fn entry ->
            consume_uploaded_entry(socket, entry, fn %{path: path} = file ->
              {:postpone,
               %{
                 path: path,
                 content_type: entry.client_type,
                 filename: entry.client_name,
                 size: entry.client_size
               }}

              # dest = Path.join("priv/static/uploads", Path.basename(path))
              # File.cp!(path, dest)
              # Routes.static_path(socket, "/uploads/#{Path.basename(dest)}")
            end)
          end)

      _ ->
        []
    end
  end
end
