defmodule RauversionWeb.MyMusicPurchasesController do
  use RauversionWeb, :controller

  def show(
        %{assigns: %{current_user: %Rauversion.Accounts.User{id: user_id}}} = conn,
        %{
          "signed_id" => token
        }
      ) do
    entries = resource_entries_by_token(user_id, token)
    Packmatic.build_stream(entries) |> Packmatic.Conn.send_chunked(conn, "download.zip")
  end

  def show(conn, _) do
    conn
    |> put_status(:not_found)
    |> send_resp(404, "not found")
    |> halt
  end

  defp resource_entries_by_token(user_id, token) do
    case Phoenix.Token.verify(RauversionWeb.Endpoint, "#{user_id}", token) do
      {:ok, %{resource: "album", id: _id}} ->
        Rauversion.AlbumPurchaseOrders.AlbumPurchaseOrder.album_entries_by_token(
          token,
          user_id
        )

      {:ok, %{resource: "track", id: _id}} ->
        Rauversion.TrackPurchaseOrders.TrackPurchaseOrder.entries_by_token(
          token,
          user_id
        )
    end
  end
end
