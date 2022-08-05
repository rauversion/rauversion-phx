# frozen_string_literal: true

# Creates a new blob on the server side in anticipation of a direct-to-service upload from the client side.
# When the client-side upload is completed, the signed_blob_id can be submitted as part of the form to reference
# the blob that was created up front.
# class ActiveStorage::DirectUploadsController < ActiveStorage::BaseController
#   def create
#     blob = ActiveStorage::Blob.create_before_direct_upload!(**blob_args)
#     render json: direct_upload_json(blob)
#   end
#
#   private
#     def blob_args
#       params.require(:blob).permit(:filename, :byte_size, :checksum, :content_type, metadata: {}).to_h.symbolize_keys
#     end
#
#     def direct_upload_json(blob)
#       blob.as_json(root: false, methods: :signed_id).merge(direct_upload: {
#         url: blob.service_url_for_direct_upload,
#         headers: blob.service_headers_for_direct_upload
#       })
#     end
# end

defmodule RauversionWeb.ActiveStorage.DirectUploadsController do
  use RauversionWeb, :controller

  action_fallback RauversionWeb.FallbackController

  def create(conn, params) do
    blob = ActiveStorage.Blob.create_before_direct_upload!(blob_args(params))

    conn
    |> Plug.Conn.send_resp(200, Jason.encode!(direct_upload_json(blob), pretty: true))
  end

  defp blob_args(params) do
    blob = params["blob"]

    %{
      "byte_size" => byte_size,
      "checksum" => checksum,
      "content_type" => content_type,
      "filename" => filename
    } = blob

    [
      filename: filename,
      byte_size: byte_size,
      checksum: checksum,
      content_type: content_type,
      metadata: "{}"
    ]

    # params.require(:blob).permit(:filename, :byte_size, :checksum, :content_type, metadata: {}).to_h.symbolize_keys
  end

  def direct_upload_json(blob) do
    %{
      signed_id: ActiveStorage.Blob.signed_id(blob),
      direct_upload: %{
        url: "ActiveStorage.Blob.url_for_direct_upload(blob)",
        headers: "ActiveStorage.Blob.service_headers_for_direct_upload(blob)"
      }
    }

    # blob.as_json(root: false, methods: :signed_id).merge(direct_upload: {
    #  url: blob.service_url_for_direct_upload,
    #  headers: blob.service_headers_for_direct_upload
    # })
  end
end
