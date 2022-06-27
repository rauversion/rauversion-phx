defmodule RauversionWeb.EmbedController do
  use RauversionWeb, :controller

  def show(conn, %{"track_id" => track_id}) do
    track = Rauversion.Tracks.get_public_track!(track_id)

    conn =
      conn
      |> assign(:track, track)
      |> delete_resp_header("x-frame-options")

    render(conn, "show.html")
  end
end
