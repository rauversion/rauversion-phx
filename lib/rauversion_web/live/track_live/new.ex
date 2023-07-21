defmodule RauversionWeb.TrackLive.Step do
  @moduledoc "Describe a step in the multi-step form and where it can go."
  defstruct [:name, :prev, :next]
end

defmodule RauversionWeb.TrackLive.New do
  use RauversionWeb, :live_view

  alias Rauversion.Tracks
  alias Rauversion.Tracks.Track
  alias RauversionWeb.TrackLive.Step

  @steps [
    %Step{name: "upload", prev: nil, next: "info"},
    %Step{name: "info", prev: "upload", next: "share"},
    %Step{name: "share", prev: "info", next: nil}
  ]

  @impl true
  def mount(_params, session, socket) do
    user = Rauversion.Accounts.get_user_by_session_token(session["user_token"])

    socket =
      socket
      |> assign(:current_user, user)
      |> assign(:blob, nil)
      |> assign(:tracks, list_tracks())

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("audio_uploaded", %{"contents" => contents}, socket) do
    {
      :noreply,
      socket
      |> assign(:blob, contents)
      |> assign(:step, %Step{name: "info", prev: "upload", next: "share"})
    }
  end

  defp apply_action(socket, :new, _params) do
    # track = Tracks.get_track!(1) |> Rauversion.Repo.preload([:user, :cover_blob])
    socket
    |> assign(:page_title, "New Track")
    |> assign(:step, List.first(@steps))
    |> assign(:blob, nil)
    |> assign(:track, %Track{})
  end

  defp list_tracks do
    Tracks.list_tracks()
  end
end
