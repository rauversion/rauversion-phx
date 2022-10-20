defmodule RauversionWeb.EventWebhooksController do
  use RauversionWeb, :controller

  def create(conn, _params = %{"webhook_key" => webhook_key}) do
    case process_webhook(webhook_key) do
      record = {:ok, _data} ->
        conn
        |> put_resp_header("content-type", "application/json; charset=utf-8")
        |> Plug.Conn.send_resp(
          200,
          Jason.encode!(
            %{a: :ok},
            pretty: true
          )
        )

      _ ->
        conn
        |> Plug.Conn.send_resp(422, "not found")
    end
  end

  def process_webhook(key) do
    Rauversion.Events.StreamingProviders.Service.process_by_key(key)
  end
end
