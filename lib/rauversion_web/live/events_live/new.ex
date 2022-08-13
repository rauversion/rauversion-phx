defmodule RauversionWeb.EventsLive.New do
  use RauversionWeb, :live_view
  on_mount RauversionWeb.UserLiveAuth

  alias Rauversion.{Accounts, Events, Repo, Events}

  @impl true
  def mount(_params, _session, socket) do
    # @current_user

    {
      :ok,
      socket
      |> assign(:open, false)
      |> assign(
        :event,
        Events.new_event(%{})
      )
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
  def handle_event("toggle-panel", %{"value" => ""}, socket) do
    {:noreply, socket |> assign(:open, !socket.assigns.open)}
  end

  @impl true
  def handle_event(
        "update-content",
        %{"content" => content},
        socket = %{
          assigns: %{event: %Ecto.Changeset{}, current_user: %Accounts.User{} = current_user}
        }
      ) do
    with {:ok, event} <-
           Events.create_event(%{
             user_id: current_user.id,
             body: content
           }) do
      {:noreply,
       socket
       |> assign(:content, content)
       |> assign(:event, event)
       |> assign(:content, event.body)
       |> push_patch(to: "/articles/edit/#{event.id}", replace: true)}
    else
      err ->
        IO.inspect(err)
        # nil -> {:error, ...} an example that we can match here too
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event(
        "update-content",
        %{"content" => content},
        socket = %{
          assigns: %{
            event: %Events.Event{} = event,
            current_user: %Accounts.User{} = current_user
          }
        }
      ) do
    with {:ok, updated_event} <-
           Events.update_event(event, %{
             user_id: current_user.id,
             body: content
           }) do
      {:noreply,
       socket
       # |> assign(:content, content)
       |> assign(:content, event.body)
       |> assign(:event, updated_event)}
    else
      err ->
        IO.inspect(err)
        {:noreply, socket}
    end
  end

  defp apply_action(socket, :index, _) do
    socket
  end

  defp apply_action(socket, :new, _) do
    socket
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    event = socket.assigns.current_user |> Ecto.assoc(:articles) |> Repo.get!(id)

    socket
    |> assign(:event, event)
    |> assign(:content, event.body)
  end

  defp apply_action(socket, :edit, %{"slug" => id}) do
    event = socket.assigns.current_user |> Ecto.assoc(:articles) |> Repo.get_by!(%{slug: id})

    socket
    |> assign(:event, event)
    |> assign(:content, event.body)
  end
end
