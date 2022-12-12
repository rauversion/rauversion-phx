defmodule RauversionWeb.EventsLive.Show do
  use RauversionWeb, :live_view
  on_mount RauversionWeb.UserLiveAuth

  alias Rauversion.{Events, Repo}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:open, false)}
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

  defp apply_action(socket, :show, %{"id" => id}) do
    event = Events.get_by_slug!(id) |> Repo.preload([:user])

    socket
    |> assign(:event, event)
    |> assign(:meta_tags, metatags(socket, event))
  end

  defp apply_action(socket, :payment_success, %{"slug" => id, "token_ws" => token}) do
    event = Events.get_by_slug!(id) |> Repo.preload([:user])

    Rauversion.PurchaseOrders.commit_order(event, token)

    socket |> assign(:event, event) |> assign(:payment_success, true)
  end

  defp apply_action(socket, :payment_success, %{"slug" => id}) do
    event = Events.get_by_slug!(id) |> Repo.preload([:user])
    socket |> assign(:event, event) |> assign(:payment_success, true)
  end

  defp apply_action(socket, :payment_failure, %{"slug" => id}) do
    event = Events.get_by_slug!(id) |> Repo.preload([:user])
    socket |> assign(:event, event) |> assign(:payment_failure, true)
  end

  def attending_people(event) do
    Rauversion.Events.purchased_tickets_count(event)
  end

  defp metatags(socket, event) do
    # "https://chaskiq.ngrok.io"
    domain = Application.get_env(:rauversion, :domain)

    %{
      url: Routes.events_show_url(socket, :show, event.slug),
      title: "#{event.title} on Rauversion",
      description: "#{event.description}",
      image:
        domain <>
          Rauversion.Tracks.variant_url(event, "cover", %{resize_to_limit: "360x360"})
    }
  end

  def event_recordings(event) do
    event |> Ecto.assoc(:event_recordings) |> Rauversion.Repo.paginate(page: 1, page_size: 6)
  end
end
