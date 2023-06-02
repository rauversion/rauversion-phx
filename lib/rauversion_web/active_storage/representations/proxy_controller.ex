# frozen_string_literal: true

# Proxy files through application. This avoids having a redirect and makes files easier to cache.
# class ActiveStorage::Representations::ProxyController < ActiveStorage::Representations::BaseController
#   include ActiveStorage::SetHeaders
#
#   def show
#     http_cache_forever public: true do
#       set_content_headers_from @representation.image
#       stream @representation
#     end
#   end
# end

defmodule RauversionWeb.ActiveStorage.Representations.ProxyController do
  use RauversionWeb, :controller

  action_fallback RauversionWeb.FallbackController

  # def show
  #   http_cache_forever public: true do
  #     set_content_headers_from @representation.image
  #     stream @representation
  #   end
  # end

  def show(conn, params) do
    blob = ActiveStorage.Blob.find_signed!(params["signed_blob_id"] || params["signed_id"])

    processed = set_representation(blob, params)

    content_disposition =
      ActiveStorage.Service.content_disposition_with(
        disposition: "inline",
        filename: ActiveStorage.Blob.filename(blob).filename
      )

    # url = processed.__struct__.url(processed)
    conn
    |> put_resp_header("cache-control", "max-age=3155695200, public")
    |> put_resp_header("content-disposition", content_disposition)
    |> put_resp_header("content-type", blob.content_type)
    |> send_blob_stream(processed)
  end

  def set_representation(blob, params) do
    representation = blob.__struct__.representation(blob, params["variation_key"])
    representation.__struct__.processed(representation)
  end

  def send_blob_stream(conn, blob, options \\ []) do
    defaults = [disposition: nil]
    options = Keyword.merge(defaults, options)

    variant_blob = blob.record |> Ecto.assoc(:image_blob) |> Rauversion.Repo.one()

    conn =
      conn
      |> put_resp_content_type(variant_blob.content_type)
      |> send_chunked(200)

    downloaded_stream =
      ActiveStorage.Blob.download(variant_blob, fn chunk_data ->
        chunk(conn, chunk_data)
      end)

    case downloaded_stream do
      {:ok, conn} -> conn
      _ -> conn
    end
  end
end
