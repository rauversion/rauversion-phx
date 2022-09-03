defmodule RauversionWeb.QrLive.Index do
  use RauversionWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket, :qr, gen_qr())
     |> assign(:ticket, get_ticket())}

    # {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Reposts")
    |> assign(:repost, nil)
  end

  defp get_ticket() do
    Rauversion.PurchasedTickets.get_purchased_ticket!(28)
    |> Rauversion.Repo.preload([:user, [event_ticket: :event]])
  end

  defp gen_qr() do
    message = Plug.Crypto.MessageVerifier.sign("your_qr_code_content", "PASSWORD")

    qr_code_content = "http://oogle.com/a?#{message}"

    # To SVG
    qr_code_content
    |> QRCodeEx.encode()
    |> QRCodeEx.svg(width: 120)
  end
end
