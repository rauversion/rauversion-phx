defmodule RauversionWeb.RepostLive.FormComponent do
  use RauversionWeb, :live_component

  alias Rauversion.Reposts

  @impl true
  def update(%{repost: repost} = assigns, socket) do
    changeset = Reposts.change_repost(repost)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"repost" => repost_params}, socket) do
    changeset =
      socket.assigns.repost
      |> Reposts.change_repost(repost_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"repost" => repost_params}, socket) do
    save_repost(socket, socket.assigns.action, repost_params)
  end

  defp save_repost(socket, :edit, repost_params) do
    case Reposts.update_repost(socket.assigns.repost, repost_params) do
      {:ok, _repost} ->
        {:noreply,
         socket
         |> put_flash(:info, "Repost updated successfully")
         |> push_patch(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_repost(socket, :new, repost_params) do
    case Reposts.create_repost(repost_params) do
      {:ok, _repost} ->
        {:noreply,
         socket
         |> put_flash(:info, "Repost created successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
