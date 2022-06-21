defmodule Rauversion.BlobUtils do
  def fallback_image(url \\ nil) do
    RauversionWeb.Router.Helpers.static_path(
      RauversionWeb.Endpoint,
      url || "/images/daniel-schludi-mbGxz7pt0jM-unsplash.jpg"
    )
  end

  def blob_url(user, kind) do
    kind_blob = :"#{kind}_blob"

    case user do
      nil ->
        Rauversion.BlobUtils.fallback_image()

      %{^kind_blob => nil} ->
        Rauversion.BlobUtils.fallback_image()

      %{^kind_blob => %ActiveStorage.Blob{} = blob} ->
        blob |> ActiveStorage.url()

      %{^kind_blob => %Ecto.Association.NotLoaded{}} ->
        user = user |> Rauversion.Repo.preload(kind_blob)

        apply(__MODULE__, :blob_url, [user, kind])
    end
  end

  def blob_for(track, kind) do
    kind_blob = :"#{kind}_blob"

    # a = Rauversion.Accounts.get_user_by_username("michelson") |> Rauversion.Repo.preload(:avatar_blob)
    case track do
      nil ->
        nil

      %{^kind_blob => nil} ->
        nil

      %{^kind_blob => %ActiveStorage.Blob{} = blob} ->
        blob

      %{^kind_blob => %Ecto.Association.NotLoaded{}} ->
        track = track |> Rauversion.Repo.preload(kind_blob)
        apply(__MODULE__, :blob_for, [track, kind])
    end
  end

  def variant_url(track, kind, options \\ %{resize_to_limit: "100x100"}) do
    case blob_for(track, kind) do
      nil ->
        fallback_image()

      blob ->
        variant =
          ActiveStorage.Blob.Representable.variant(blob, options)
          |> ActiveStorage.Variant.processed()

        ActiveStorage.storage_redirect_url(variant, options)
        # |> ActiveStorage.Variant.url()
    end
  end

  def blob_url_for(track, kind) do
    blob = blob_for(track, kind)
    ActiveStorage.service_blob_url(blob)
  end

  def blob_proxy_url(track, kind) do
    blob = blob_for(track, kind)
    ActiveStorage.blob_proxy_url(blob)
  end
end
