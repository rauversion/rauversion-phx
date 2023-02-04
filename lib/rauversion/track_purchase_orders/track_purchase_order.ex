defmodule Rauversion.TrackPurchaseOrders.TrackPurchaseOrder do
  use Ecto.Schema

  schema "track_purchase_orders" do
    belongs_to :purchase_order, Rauversion.PurchaseOrders.PurchaseOrder
    belongs_to :track, Rauversion.Tracks.Track
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
    Phoenix.Token.sign(RauversionWeb.Endpoint, "#{user_id}", %{id: order.id, resource: "track"},
      max_age: 315_360_000_000
    )
  end

  def find_by_signed_id!(token, user_id) do
    case Phoenix.Token.verify(RauversionWeb.Endpoint, "#{user_id}", token) do
      {:ok, %{id: track_id}} ->
        Rauversion.Repo.get(Rauversion.TrackPurchaseOrders.TrackPurchaseOrder, track_id)

      _ ->
        nil
    end
  end

  def entries_by_token(token, user_id) do
    order = find_by_signed_id!(token, user_id)

    track =
      Rauversion.Tracks.get_track!(order.track_id)
      |> Rauversion.Repo.preload([:user, :cover_blob, :audio_blob])

    entries = [
      [
        source: {
          :url,
          Application.get_env(:rauversion, :domain) <>
            Rauversion.BlobUtils.blob_proxy_url(track, :audio)
        },
        path: "/#{track.slug}/#{String.replace(track.audio_blob.filename, " ", "-")}"
      ]
    ]

    IO.inspect(entries)
    entries
  end

  def is_downloadable?(%{purchase_order: order}) do
    order.state == "paid" or order.state == "free_access"
  end
end
