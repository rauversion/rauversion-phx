defmodule RauversionWeb.MyMusicPurchasesController do
  use RauversionWeb, :controller

  def show(
        %{assigns: %{current_user: current_user = %Rauversion.Accounts.User{id: user_id}}} = conn,
        %{
          "signed_id" => token
        }
      ) do
    entries =
      Rauversion.AlbumPurchaseOrders.AlbumPurchaseOrder.album_entries_by_token(
        token,
        user_id
      )

    stream = Packmatic.build_stream(entries)
    stream |> Packmatic.Conn.send_chunked(conn, "download.zip")
  end

  def show(conn, _) do
    conn
    |> put_status(:not_found)
    |> send_resp(404, "not found")
    |> halt
  end
end
