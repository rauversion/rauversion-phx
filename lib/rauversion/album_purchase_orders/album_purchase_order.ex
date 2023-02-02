defmodule Rauversion.AlbumPurchaseOrders.AlbumPurchaseOrder do
  use Ecto.Schema

  schema "album_purchase_orders" do
    belongs_to :purchase_order, Rauversion.PurchaseOrders.PurchaseOrder
    belongs_to :playlist, Rauversion.Playlists.Playlist
    timestamps()
  end

  def url_for_download(order, user_id) do
    RauversionWeb.Router.Helpers.my_music_purchases_url(
      RauversionWeb.Endpoint,
      :show,
      __MODULE__.signed_id(order, user_id)
    )
  end

  def signed_id(order, user_id) do
    Phoenix.Token.sign(RauversionWeb.Endpoint, "#{user_id}", order.id, max_age: 315_360_000_000)
  end

  def find_by_signed_id!(token, user_id) do
    case Phoenix.Token.verify(RauversionWeb.Endpoint, "#{user_id}", token) do
      {:ok, playlist_id} ->
        Rauversion.Repo.get(Rauversion.AlbumPurchaseOrders.AlbumPurchaseOrder, playlist_id)

      _ ->
        nil
    end
  end

  def album_entries_by_token(token, user_id) do
    order = find_by_signed_id!(token, user_id)

    playlist =
      Rauversion.Playlists.get_playlist!(order.playlist_id)
      |> Rauversion.Repo.preload([:user, :cover_blob, [track_playlists: [track: [:audio_blob]]]])

    entries =
      Enum.map(playlist.track_playlists, fn item ->
        [
          source: {
            :url,
            Application.get_env(:rauversion, :domain) <>
              Rauversion.BlobUtils.blob_proxy_url(item.track, :audio)
          },
          path: "/#{playlist.slug}/#{String.replace(item.track.audio_blob.filename, " ", "-")}"
        ]
      end)

    MIME.extensions("")

    IO.inspect(entries)
    entries
  end
end
