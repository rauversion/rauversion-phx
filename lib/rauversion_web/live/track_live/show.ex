defmodule RauversionWeb.TrackLive.Show do
  use RauversionWeb, :live_view

  alias Rauversion.{Tracks, Repo, Accounts}
  alias RauversionWeb.TrackLive.Step

  @impl true
  def mount(_params, session, socket) do
    socket =
      RauversionWeb.LiveHelpers.get_user_by_session(socket, session)
      |> assign(:share_track, nil)

    {:ok, socket}
  end

  @impl true
  def handle_params(
        %{"id" => id} = _params,
        _,
        socket = %{assigns: %{live_action: :show, current_user: _user = nil}}
      ) do
    track = Tracks.get_by_slug!(id) |> Repo.preload(:user)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:track, track)
     |> assign(
       :oembed_json,
       oembed_meta(socket, track)
     )
     |> assign(:meta_tags, metatags(socket, track))}
  end

  @impl true
  def handle_params(
        %{"id" => id} = _params,
        _,
        socket = %{assigns: %{live_action: :show, current_user: user = %Accounts.User{}}}
      ) do
    track =
      Tracks.get_by_slug_query(id)
      |> Rauversion.Tracks.preload_tracks_preloaded_by_user(user)
      |> Rauversion.Repo.one()
      |> Rauversion.Repo.preload([:user])

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:track, track)
     |> assign(
       :oembed_json,
       oembed_meta(socket, track)
     )
     |> assign(:meta_tags, metatags(socket, track))}
  end

  @impl true
  def handle_params(
        %{"id" => signed_id} = _params,
        _,
        socket = %{assigns: %{live_action: :private}}
      ) do
    track = Rauversion.Tracks.find_by_signed_id!(signed_id) |> Repo.preload(:user)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:track, track)
     |> assign(
       :oembed_json,
       oembed_meta(socket, track)
     )}
  end

  @impl true
  def handle_params(%{"id" => id} = _params, _, socket = %{assigns: %{live_action: :edit}}) do
    socket =
      socket
      |> assign(:step, %Step{name: "info", prev: "upload", next: "share"})
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:current_tab, "basic-info-tab")
      |> assign(:track, Tracks.get_by_slug!(id) |> Repo.preload(:user))

    case RauversionWeb.LiveHelpers.authorize_user_resource(socket, socket.assigns.track.user_id) do
      {:ok, socket} ->
        {:noreply, socket}

      {:err, err} ->
        {:noreply, err}
    end
  end

  @impl true
  def handle_params(%{"slug" => id}, _, socket = %{assigns: %{live_action: :payment_success}}) do
    track =
      Tracks.get_by_slug!(id)
      |> Rauversion.Repo.preload([:user, :cover_blob])

    {:noreply,
     socket
     |> assign(track: track)
     |> assign(:payment_success, true)}
  end

  @impl true
  def handle_params(%{"slug" => id}, _, socket = %{assigns: %{live_action: :payment_failure}}) do
    event =
      Tracks.get_by_slug!(id)
      |> Rauversion.Repo.preload([:user, :cover_blob])

    {:noreply, socket |> assign(:track, event) |> assign(:payment_failure, true)}
  end

  @impl true
  def handle_event("close-modal", %{}, socket) do
    {
      :noreply,
      socket
    }

    #  assign(socket, :action, nil)
    #  |> assign(:share_track, nil)
    # }
  end

  @impl true
  def handle_event("metadata-tab" = tab, _, socket) do
    {:noreply, socket |> assign(:current_tab, tab)}
  end

  @impl true
  def handle_event("basic-info-tab" = tab, _, socket) do
    {:noreply, socket |> assign(:current_tab, tab)}
  end

  @impl true
  def handle_event("permissions-tab" = tab, _, socket) do
    {:noreply, socket |> assign(:current_tab, tab)}
  end

  @impl true
  def handle_event("pricing-tab" = tab, _, socket) do
    {:noreply, socket |> assign(:current_tab, tab)}
  end

  @impl true
  def handle_event("share-tab" = tab, _, socket) do
    {:noreply, socket |> assign(:current_tab, tab)}
  end

  @impl true
  def handle_event("share-track-modal", %{"id" => id}, socket) do
    {:noreply,
     assign(
       socket,
       :share_track,
       Tracks.get_track!(id) |> Rauversion.Repo.preload(user: :avatar_attachment)
     )}
  end

  def get_supporters(track_id) do
    a =
      Rauversion.Tracks.purchases_for_track(track_id)
      |> Rauversion.Repo.all()

    IO.inspect(a)
    a
  end

  defp page_title(:private), do: "Show Track · private preview"
  defp page_title(:show), do: "Show Track"
  defp page_title(:edit), do: "Edit Track"

  defp metatags(socket, track) do
    # "https://chaskiq.ngrok.io"
    domain = Application.get_env(:rauversion, :domain)

    %{
      url: Routes.articles_show_url(socket, :show, track.id),
      title: "#{track.title} on Rauversion",
      description: "Stream #{track.title} by #{track.user.username} on Rauversion.",
      image:
        domain <>
          Rauversion.Tracks.variant_url(track, "cover", %{resize_to_limit: "360x360"}),
      "twitter:player": domain <> Routes.embed_path(socket, :show, track),
      twitter: %{
        card: "player",
        player: %{
          stream: domain <> (Rauversion.Tracks.blob_proxy_url(track, "mp3_audio") || ""),
          "stream:content_type": "audio/mpeg",
          width: 290,
          height: 58
        }
      }
      # url: "https://phoenix.meta.tags",
      # image: "https://phoenix.meta.tags/logo.png"
    }
  end

  defp oembed_meta(socket, track = %{private: false}) do
    Routes.embed_url(socket, :oembed_show, track, %{format: :json})
  end

  defp oembed_meta(socket, track = %{private: true}) do
    Routes.embed_url(socket, :oembed_private_show, Rauversion.Tracks.signed_id(track), %{
      format: :json
    })
  end
end
