defmodule RauversionWeb.ActiveStorage.Blobs.RedirectController do
  use RauversionWeb, :controller

  action_fallback RauversionWeb.FallbackController

  def show(conn, %{"signed_id" => signed_id}) do
    case ActiveStorage.Verifier.verify(signed_id) do
      {:ok, id} ->
        conn
        |> put_resp_header("cache-control", "max-age=#{ActiveStorage.service_urls_expire_in()}")
        |> handle_redirect(id)

      _ ->
        conn |> error_response(422, "Wrong provider key")
    end
  end

  defp handle_redirect(conn, id) do
    presigned =
      ActiveStorage.get_storage_blob!(id)
      |> ActiveStorage.url()

    case presigned do
      nil ->
        conn |> error_response(422, "Invalid blob id")

      url ->
        IO.inspect("REDIRECT TO #{url}")
        conn |> redirect(external: url) |> halt()
    end
  end

  defp error_response(conn, status, message) do
    conn
    |> put_status(status)
    |> json(%{
      status: :error,
      message: message
    })
  end
end
