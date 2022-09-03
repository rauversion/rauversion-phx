defmodule RauversionWeb.WebhooksController do
  use RauversionWeb, :controller

  alias Rauversion.Accounts

  def create(
        conn,
        params = %{
          "account" => account_id,
          "type" => "checkout.session.completed",
          "data" => %{"object" => object}
        }
      ) do
    order = Rauversion.PurchaseOrders.get_purchase_order_by_stripe_payment!(object["id"])

    case Rauversion.PurchaseOrders.generate_purchased_tickets(order) do
      {:error, :purchased_tickets, _, _} ->
        conn
        |> Plug.Conn.resp(200, "Not found")
        |> Plug.Conn.send_resp()

      _ ->
        conn
        |> Plug.Conn.resp(200, "Not found")
        |> Plug.Conn.send_resp()
    end
  end
end
