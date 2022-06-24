defmodule RauversionWeb.TrackLive.FormComponent do
  use RauversionWeb, :live_component

  alias Rauversion.Tracks
  alias RauversionWeb.TrackLive.Step

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

  # the save on create, upload step!, it will only bring an audio file
  def handle_event(
        "save",
        %{"track" => track_params} = params,
        socket = %{
          assigns: %{
            step: %{name: "upload"},
            uploads: %{audio: %{entries: [audio]}}
          }
        }
      ) do
    track_params = %{
      "track" =>
        track_params
        |> Map.merge(%{
          "user_id" => socket.assigns.current_user.id,
          "title" => audio.client_name
        })
    }

    save_track(socket, socket.assigns.action, track_params)
  end

  # info step handle submit
  def handle_event(
        "save",
        %{} = track_params,
        socket = %{
          assigns: %{
            step: %{name: "info"}
          }
        }
      ) do
    save_track(socket, socket.assigns.action, track_params)
  end

  def handle_event("save", %{"track" => track_params}, socket) do
    track_params = track_params |> Map.put("user_id", socket.assigns.current_user.id)
    save_track(socket, socket.assigns.action, track_params)
  end

  defp save_track(socket, :edit, %{"track" => track_params}) do
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

  defp save_track(socket, :new, %{"track" => track_params} = params) do
    case socket.assigns.step do
      %{name: "upload"} ->
        case Tracks.create_track(track_params) do
          {:ok, track} ->
            IO.inspect("SUCCESSS!")

            step = %Step{name: "info", prev: "upload", next: "share"}

            {:noreply,
             socket
             |> assign(changeset: Tracks.change_track(track))
             |> assign(track: track)
             |> assign(step: step)
             |> put_flash(:info, "Track created successfully")}

          # |> push_redirect(to: socket.assigns.return_to)}

          {:error, %Ecto.Changeset{} = changeset} ->
            IO.inspect("ERORORORR")
            IO.inspect(changeset)
            {:noreply, assign(socket, changeset: changeset)}
        end

      %{name: "info"} ->
        save_track(socket, :edit, params)

      _ ->
        IO.inspect("NO STEP!!!")
        {:noreply, socket}
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
