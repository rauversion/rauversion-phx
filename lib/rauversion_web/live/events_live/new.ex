defmodule RauversionWeb.EventsLive.New do
  use RauversionWeb, :live_view
  on_mount RauversionWeb.UserLiveAuth

  alias Rauversion.{Events, Repo}

  @impl true
  def mount(_params, session, socket) do
    user = Rauversion.Accounts.get_user_by_session_token(session["user_token"])

    {
      :ok,
      socket
      |> assign(:open, false)
      |> assign(:current_user, user)
      |> assign(
        :changeset,
        Events.new_event(%{})
      )
      |> assign(:event, %Events.Event{})
      |> allow_upload(:cover, accept: ~w(.jpg .jpeg .png), max_entries: 1)
      |> assign(:content, "")
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    case apply_action(socket, socket.assigns.live_action, params) do
      {:ok, reply} ->
        {:noreply, reply}

      {:err, err} ->
        {:noreply, err}

      any ->
        {:noreply, any}
    end
  end

  @impl true
  def handle_event("validate", %{"event" => event_params}, socket) do
    changeset =
      socket.assigns.event
      |> Events.change_event(event_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"event" => event_params}, socket) do
    save_event(socket, socket.assigns.live_action, event_params)
  end

  defp save_event(socket, :edit, event_params) do
    event_params =
      event_params
      |> Map.put("cover", files_for(socket, :cover))

    case Events.update_event(socket.assigns.event, event_params) do
      {:ok, _event} ->
        {
          :noreply,
          socket
          |> put_flash(:info, "Playlist updated successfully")
          # |> push_redirect(to: socket.assigns.return_to)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_event(socket, :new, event_params) do
    event_params = event_params |> Map.put("user_id", socket.assigns.current_user.id)

    case Events.create_event(event_params) do
      {:ok, event} ->
        {:noreply,
         socket
         |> put_flash(:info, "Repost created successfully")
         |> push_redirect(to: "/events/#{event.slug}/edit")}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp apply_action(socket, :index, _) do
    socket
  end

  defp apply_action(socket, :new, _) do
    socket
  end

  defp apply_action(socket, :schedule, %{"slug" => id}) do
    edit_response(socket, id)
  end

  defp apply_action(socket, :tickets, %{"slug" => id}) do
    edit_response(socket, id)
  end

  defp apply_action(socket, :order_form, %{"slug" => id}) do
    edit_response(socket, id)
  end

  defp apply_action(socket, :widgets, %{"slug" => id}) do
    edit_response(socket, id)
  end

  defp apply_action(socket, :tax, %{"slug" => id}) do
    edit_response(socket, id)
  end

  defp apply_action(socket, :attendees, %{"slug" => id}) do
    edit_response(socket, id)
  end

  defp apply_action(socket, :sponsors, %{"slug" => id}) do
    edit_response(socket, id)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    edit_response(socket, id)
  end

  defp apply_action(socket, :edit, %{"slug" => id}) do
    edit_response(socket, id)
  end

  defp edit_response(socket, id) do
    event = socket.assigns.current_user |> Ecto.assoc(:events) |> Repo.get_by!(%{slug: id})

    socket
    |> assign(:changeset, Events.change_event(event, %{}))
    |> assign(:event, event)
  end
end
