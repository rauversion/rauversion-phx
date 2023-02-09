defmodule RauversionWeb.TrackLive.LikeTrackButtonComponent do
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
      |> assign(:like, nil)
    }
  end

  @impl true
  def update(assigns = %{current_user: _current_user = %Rauversion.Accounts.User{}}, socket) do
    like =
      case assigns.track.likes do
        [like] -> like
        _ -> nil
      end

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:like, like)
    }
  end

  @impl true
  def handle_event(
        "like-track",
        %{"id" => _id},
        socket = %{
          assigns: %{track: track, current_user: current_user = %Rauversion.Accounts.User{}}
        }
      ) do
    attrs = %{user_id: current_user.id, track_id: track.id}

    case socket.assigns.like do
      %Rauversion.TrackLikes.TrackLike{} = track_like ->
        Rauversion.TrackLikes.delete_track_like(track_like)

        track = track |> Map.merge(%{likes_count: track.likes_count - 1})

        {:noreply, assign(socket, :like, nil) |> assign(track: track)}

      _ ->
        {:ok, %Rauversion.TrackLikes.TrackLike{} = track_like} =
          Rauversion.TrackLikes.create_track_like(attrs)

        track = track |> Map.merge(%{likes_count: track.likes_count + 1})

        {
          :noreply,
          assign(socket, :like, track_like) |> assign(track: track)
        }
    end
  end

  @impl true
  def handle_event(
        "like-track",
        %{"id" => _id},
        socket = %{assigns: %{track: _track, current_user: _user = nil}}
      ) do
    # TODO: SHOW MODAL HERE
    {:noreply, socket}
  end

  @impl true
  def render(
        %{
          track: _track,
          like: like
        } = assigns
      ) do
    assigns = assign(assigns, :like_class, active_button_class(like))

    ~H"""
    <div>
      <%= link to: "#", phx_click: "like-track", phx_target: @myself, phx_value_id: @track.id,
          class: @like_class.class do %>
        <%= if @like do %>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-4 w-4"
            viewBox="0 0 20 20"
            fill="currentColor"
          >
            <path
              fill-rule="evenodd"
              d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z"
              clip-rule="evenodd"
            />
          </svg>
        <% else %>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-4 w-4"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
            stroke-width="2"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"
            />
          </svg>
        <% end %>
        <span class="flex space-x-1">
          <span><%= @track.likes_count %></span>
          <span class="hidden sm:block"><%= gettext("Like") %></span>
        </span>
      <% end %>
    </div>
    """
  end
end
