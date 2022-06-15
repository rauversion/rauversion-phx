defmodule RauversionWeb.TrackLive.FormComponent do
  use RauversionWeb, :live_component

  alias Rauversion.Tracks

  @impl true
  def update(%{track: track} = assigns, socket) do
    changeset = Tracks.change_track(track)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
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
end
