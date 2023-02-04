defmodule Rauversion.Workers.OrderNotificationJob do
  use Oban.Worker, queue: :default, max_attempts: 10

  def perform(%_{args: %{"order_id" => order_id}}) do
    Rauversion.PurchaseOrders.notify_music_order_to_buyer(order_id)
    Rauversion.PurchaseOrders.notify_music_order_to_author(order_id)
    :ok
  end
end
