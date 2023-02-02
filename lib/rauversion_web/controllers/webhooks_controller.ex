defmodule RauversionWeb.WebhooksController do
  use RauversionWeb, :controller

  # alias Rauversion.Accounts

  def create(
        conn,
        %{
          "account" => _account_id,
          "type" => "checkout.session.completed",
          "data" => %{"object" => object}
        }
      ) do
    conn |> process_order(object)
  end

  def create(
        conn,
        %{
          "type" => "checkout.session.completed",
          "data" => %{"object" => object}
        }
      ) do
    conn |> process_order(object)
  end

  defp process_order(conn, object) do
    order = Rauversion.PurchaseOrders.get_purchase_order_by_stripe_payment!(object["id"])

    order |> Rauversion.Repo.preload([:albums, :tracks])

    case Rauversion.PurchaseOrders.update_purchase_order(order, %{
           state: object["payment_status"]
         }) do
      {:ok, purchase_order} ->
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

      _ ->
        conn
        |> Plug.Conn.resp(404, "purchase order not ok")
        |> Plug.Conn.send_resp()
    end
  end
end
