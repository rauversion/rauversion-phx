defmodule RauversionWeb.WebhooksController do
  use RauversionWeb, :controller

  # alias Rauversion.Accounts

  def create(
        conn,
        _params = %{
          "account" => _account_id,
          "type" => "checkout.session.completed",
          "data" => %{"object" => object}
        }
      ) do
    order = Rauversion.PurchaseOrders.get_purchase_order_by_stripe_payment!(object["id"])

    order |> Rauversion.Repo.preload([:albums, :tracks])

    order =
      case Rauversion.PurchaseOrders.update_purchase_order(order, %{
             state: object["payment_status"]
           }) do
        {:ok, purchase_order} -> order
      end

    # this will not run if it have data, but we should validate if the trx is from events
    case Rauversion.PurchaseOrders.generate_purchased_tickets(order) do
      {:error, :purchased_tickets, _, _} ->
        conn
        |> Plug.Conn.resp(200, "Not found")
        |> Plug.Conn.send_resp()

      _ ->
        conn
        |> Plug.Conn.resp(200, "ok found")
        |> Plug.Conn.send_resp()
    end
  end
end
