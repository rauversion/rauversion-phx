defmodule RauversionWeb.OEmbedController do
  use RauversionWeb, :controller
  alias Rauversion.Services.FetchCardLink
  alias Rauversion.PreviewCards

  def create(conn, _params = %{"url" => url}) do
    case FetchCardLink.call(url) do
      record ->
        conn
        |> Plug.Conn.send_resp(
          200,
          Jason.encode!(
            PreviewCards.as_oembed_json(record),
            pretty: true
          )
        )

      _ ->
        conn
        |> Plug.Conn.send_resp(422, "not found")
    end

    # res = Rauversion.FetchLinkCardService.new.call(params[:url])
    # render json: res.as_oembed_json
  end
end
