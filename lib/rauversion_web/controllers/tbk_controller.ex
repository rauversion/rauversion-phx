defmodule RauversionWeb.TbkController do
  use RauversionWeb, :controller

  def index do
  end

  def create do
  end

  def send_create do
    # buy_order = params[:buy_order]
    # session_id = params[:session_id]
    # amount = params[:amount]
    # return_url = params[:return_url]
    # @req = params.as_json
    # @resp = Transbank.Webpay.WebpayPlus.Transaction.create(
    #                                                  buy_order: buy_order,
    #                                                  session_id: session_id,
    #                                                  amount: amount,
    #                                                  return_url: return_url
    #                                                  )
    # render 'transaction_created'
  end

  def commit do
    # @req = params.as_json
    #
    # @token = params[:token_ws]
    # @resp = Transbank.Webpay.WebpayPlus.Transaction.commit(token: @token)
    # render 'transaction_committed'
  end

  def refund do
    # @req = params.as_json
    # @token = params[:token]
    # @amount = params[:amount]
    # @resp = Transbank.Webpay.WebpayPlus.Transaction.refund(token: @token, amount: @amount)
  end

  def status do
    # @req = params.as_json
    # @token = params[:token]
    # @resp = Transbank.Webpay.WebpayPlus.Transaction.status(token: @token)
  end

  def mall_create(conn, _params) do
    conn = conn |> assign(:data, %{})
    render(conn, "create.html")
  end

  def send_mall_create(conn, params) do
    # params.permit!
    # @req = params.as_json
    buy_order = params["buy_order"]
    session_id = params["session_id"]
    return_url = params["return_url"]
    details = params["detail"]["details"] |> Enum.reduce([], fn {_, a}, acc -> [a] ++ acc end)

    commerce_code = Transbank.Common.IntegrationCommerceCodes.webpay_plus_mall()
    api_key = Transbank.Common.IntegrationApiKeys.webpay()
    environment = Transbank.Webpay.WebpayPlus.MallTransaction.default_environment()

    trx = Transbank.Webpay.WebpayPlus.MallTransaction.new(commerce_code, api_key, environment)

    resp =
      Transbank.Webpay.WebpayPlus.MallTransaction.create(
        trx,
        buy_order,
        session_id,
        return_url,
        details
      )

    case resp do
      {:ok, data} ->
        conn
        |> assign(:data, data)
        |> render("mall_transaction_created.html")

      _ ->
        conn
        |> send_resp(422, "eroror")
    end

    # render 'mall_transaction_created'
  end

  def mall_commit(conn, params = %{"token_ws" => token}) do
    # @req = params.as_json
    # @resp = Transbank.Webpay.WebpayPlus.MallTransaction.commit(token: @req['token_ws'])
    commerce_code = Transbank.Common.IntegrationCommerceCodes.webpay_plus_mall()
    api_key = Transbank.Common.IntegrationApiKeys.webpay()
    environment = Transbank.Webpay.WebpayPlus.MallTransaction.default_environment()

    trx = Transbank.Webpay.WebpayPlus.MallTransaction.new(commerce_code, api_key, environment)

    {:ok, data} = Transbank.Webpay.WebpayPlus.MallTransaction.commit(trx, token)

    conn
    |> assign(:data, data)
    |> render("mall_transaction_committed.html")
  end

  def mall_events_commit(conn, %{"id" => id, "token_ws" => token}) do
    event = Rauversion.Events.get_by_slug!(id) |> Rauversion.Repo.preload([:user])

    case Rauversion.PurchaseOrders.commit_order(event, token) do
      {:ok, _tickets} ->
        conn |> redirect(to: "/events/#{event.slug}/payment_success")

      order ->
        IO.puts("FAILED ORDER!")
        IO.inspect(order)
        conn |> redirect(to: "/events/#{event.slug}/payment_failure")
    end
  end

  def mall_events_commit(conn, %{"id" => id, "TBK_ID_SESION" => _session}) do
    event = Rauversion.Events.get_by_slug!(id) |> Rauversion.Repo.preload([:user])
    redirect(conn, to: "/events/#{event.slug}/payment_failure")
  end

  def mall_status do
    # @token = params[:token]
    # @resp = Transbank.Webpay.WebpayPlus.MallTransaction.status(token: @token)
    # render 'webpay/mall_transaction_status'
  end

  def mall_refund do
    # @token = params[:token]
    # @child_commerce_code = params[:commerce_code]
    # @child_buy_order = params[:buy_order]
    # @child_amount = params[:amount]
    # @resp = Transbank.Webpay.WebpayPlus.MallTransaction.refund(token: @token,
    #                                                              buy_order: @child_buy_order,
    #                                                              child_commerce_code: @child_commerce_code,
    #                                                              amount: @child_amount)
    # render 'webpay/mall_transaction_refunded'
  end
end
