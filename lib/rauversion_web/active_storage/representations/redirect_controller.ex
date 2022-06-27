# frozen_string_literal: true

# Take a signed permanent reference for a blob representation and turn it into an expiring service URL for download.
# Note: These URLs are publicly accessible. If you need to enforce access protection beyond the
# security-through-obscurity factor of the signed blob and variation reference, you'll need to implement your own
# authenticated redirection controller.
# class ActiveStorage::Representations::RedirectController < ActiveStorage::Representations::BaseController
#   def show
#     expires_in ActiveStorage.service_urls_expire_in
#     redirect_to @representation.url(disposition: params[:disposition])
#   end
# end

defmodule RauversionWeb.ActiveStorage.Representations.RedirectController do
  use RauversionWeb, :controller

  action_fallback RauversionWeb.FallbackController

  def show(conn, params) do
    conn |> set_blob(params) |> set_representation(params)

    # def set_blob
    #  @blob = blob_scope.find_signed!(params[:signed_blob_id] || params[:signed_id])
    # rescue ActiveSupport::MessageVerifier::InvalidSignature
    #  head :not_found
    # end

    # case ActiveStorage.Verifier.verify(signed_id) do
    #  {:ok, id} -> conn |> handle_redirect(id)
    #  _ -> conn |> error_response(422, "Wrong provider key")
    # end
  end

  def set_blob(conn, params) do
    try do
      blob = ActiveStorage.Blob.find_signed!(params["signed_blob_id"] || params["signed_id"])
      conn |> assign(:blob, blob)
    rescue
      RuntimeError ->
        conn
        |> put_status(:not_found)
        |> render(:"404")
        |> halt
    end
  end

  def set_representation(conn, params) do
    try do
      representation =
        conn.assigns.blob.__struct__.representation(conn.assigns.blob, params["variation_key"])

      processed = representation.__struct__.processed(representation)

      # attached = processed.__struct__.image(processed)
      url = processed.__struct__.url(processed)
      redirect(conn, to: url) |> halt
      # @representation = conn.assigns.blob.representation(params["variation_key"]).processed
      # conn |> assign(:representation, representation)
    rescue
      RuntimeError ->
        conn
        |> put_status(:not_found)
        |> render(:"404")
        |> halt
    end
  end

  def blob_scope() do
    ActiveStorage.Blob
  end
end
