defmodule RauversionWeb.TrackLive.RepostTrackButtonComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionWeb, :live_component

  @impl true
  def update(assigns = %{current_user: _user = nil}, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:repost, nil)
    }
  end

  @impl true
  def update(assigns = %{current_user: _current_user = %Rauversion.Accounts.User{}}, socket) do
    repost =
      case assigns.track.reposts do
        [repost] -> repost
        _ -> nil
      end

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:repost, repost)
    }
  end

  @impl true
  def handle_event(
        "repost-track",
        %{"id" => _id},
        socket = %{
          assigns: %{track: track, current_user: current_user = %Rauversion.Accounts.User{}}
        }
      ) do
    attrs = %{user_id: current_user.id, track_id: track.id}

    case socket.assigns.repost do
      %Rauversion.Reposts.Repost{} = repost ->
        Rauversion.Reposts.delete_repost(repost)
        {:noreply, assign(socket, :repost, nil)}

      _ ->
        {:ok, %Rauversion.Reposts.Repost{} = repost} = Rauversion.Reposts.create_repost(attrs)
        {:noreply, assign(socket, :repost, repost)}
    end
  end

  @impl true
  def handle_event(
        "repost-track",
        %{"id" => _id},
        socket = %{assigns: %{track: _track, current_user: user = nil}}
      ) do
    # TODO: SHOW MODAL HERE
    {:noreply, socket}
  end

  @impl true
  def render(
        %{
          track: track,
          repost: repost
        } = assigns
      ) do
    repost_class = active_button_class(repost)

    ~H"""
      <div>
        <%= link to: "#", phx_click: "repost-track", phx_target: @myself, phx_value_id: track.id,
          class: repost_class.class do %>
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M4 2a1 1 0 011 1v2.101a7.002 7.002 0 0111.601 2.566 1 1 0 11-1.885.666A5.002 5.002 0 005.999 7H9a1 1 0 010 2H4a1 1 0 01-1-1V3a1 1 0 011-1zm.008 9.057a1 1 0 011.276.61A5.002 5.002 0 0014.001 13H11a1 1 0 110-2h5a1 1 0 011 1v5a1 1 0 11-2 0v-2.101a7.002 7.002 0 01-11.601-2.566 1 1 0 01.61-1.276z" clip-rule="evenodd" />
          </svg>
          <span>Repost</span>
        <% end %>
      </div>
    """
  end
end
