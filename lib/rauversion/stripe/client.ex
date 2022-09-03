defmodule Rauversion.Stripe.Client do
  use Tesla

  # "https://api.stripe.com/v1"
  # "https://hookb.in/VGzMnEaPMziDebxDwpQl"
  plug Tesla.Middleware.BaseUrl, "https://api.stripe.com/v1"

  plug Tesla.Middleware.FormUrlencoded,
    encode: &Plug.Conn.Query.encode/1,
    decode: &Plug.Conn.Query.decode/1

  # plug Tesla.Middleware.Headers, [{"authorization", "token xyz"}]
  plug Tesla.Middleware.JSON

  @moduledoc """
  client = Rauversion.Stripe.Client.new
  c = Rauversion.OauthCredentials.get_oauth_credential!(1)
  Rauversion.Stripe.Client.accounts(client, c.uid)

  ref: https://stripe.com/docs/connect/destination-charges
  """

  def new(token \\ nil) do
    token =
      case token do
        nil ->
          Application.get_env(:ueberauth, Ueberauth.Strategy.Stripe.OAuth)
          |> Keyword.get(:client_secret)

        t ->
          t
      end

    Tesla.client([
      {Tesla.Middleware.BearerAuth, token: token}
    ])
  end

  def accounts(client, account) do
    handle_response(get(client, "/accounts/" <> account))
  end

  def balance(client, account) do
    prepare_request(client, :get, "/balance", account)
  end

  @doc """
  PRODUCTS
  """

  @doc """
  Rauversion.Stripe.Client.create_price(client, c.uid, %{name: "123})
  """
  def create_product(client, account, params) do
    prepare_request(client, :post, "/products", account, params)
  end

  @doc """
  Rauversion.Stripe.Client.get_price(client, c.uid, "xxxx")
  """
  def get_product(client, account, product_id) do
    prepare_request(client, :get, "/products/#{product_id}", account)
  end

  def list_products(client, account, params) do
    prepare_request(client, :get, "/products/", account, params)
  end

  @doc """
  Rauversion.Stripe.Client.update_product(client, c.uid, "xxxxx", %{"metadata"=> %{"order_id"=> "6735"}})
  """
  def update_product(client, account, product_id, params) do
    prepare_request(client, :post, "/products/#{product_id}", account, params)
  end

  # charges

  @doc """

   curl https://api.stripe.com/v1/payment_intents \
   -u xxxxx: \
   -d amount=1000 \
   -d currency="usd" \
   -d "automatic_payment_methods[enabled]"=true \
   -d "transfer_data[amount]"="877"
   -d "transfer_data[destination]"="{{CONNECTED_STRIPE_ACCOUNT_ID}}"

  """

  def payment_intent(
        client,
        params = %{
          "amount" => _payment,
          "currency" => _currency,
          "automatic_payment_methods" => %{"enabled" => _enabled},
          "transfer_data" => %{
            "amount" => _amount,
            "destination" => _destination
          }
        }
      ) do
    post(client, "/payment_intents", params, [])
  end

  @doc """
  curl https://api.stripe.com/v1/refunds \
  -u xxxxxx: \
  -d charge="{CHARGE_ID}" \
  -d reverse_transfer=true \
  """

  def refunds(
        client,
        params = %{
          "charge" => _charge_id,
          "reverse_transfer" => _
        }
      ) do
    post(client, "/refunds", params, [])
  end

  @doc """
  https://stripe.com/docs/connect/creating-a-payments-page?ui=checkout&destination-or-direct=direct-charges
  """
  def create_session(
        client,
        account,
        params
      ) do
    # post(client, "/checkout/sessions", params, [])

    prepare_request(client, :post, "/checkout/sessions", account, params)

    #  curl https://api.stripe.com/v1/checkout/sessions \
    # -u sk_test_51La9aMCM97FuPMA98QN5mL06tlCXp6UQbrvm4U3vLUvrhNPkC7VMBayrapx6DaI9Zc1gMy9ZuPLBqFPcwJvzmXMB0058FygMKs: \
    # -d "line_items[][name]"="Kavholm rental" \
    # -d "line_items[][amount]"=1000 \
    # -d "line_items[][currency]"="usd" \
    # -d "line_items[][quantity]"=1 \
    # -d "payment_intent_data[application_fee_amount]"=123 \
    # -d "payment_intent_data[transfer_data][destination]"="{{CONNECTED_STRIPE_ACCOUNT_ID}}" \
    # -d "mode"="payment" \
    # -d "success_url"="https://example.com/success" \
    # -d "cancel_url"="https://example.com/cancel"
  end

  def balance_transactions(client, account, limit \\ 3) do
    prepare_request(client, :get, "/balance_transactions", account, %{"limit" => limit})
  end

  def list_charges(client, account, limit \\ 3) do
    prepare_request(client, :get, "/charges", account, %{"limit" => limit})
  end

  def delete_product(client, account, product_id) do
    prepare_request(client, :delete, "/products/#{product_id}", account)
  end

  defp prepare_request(client, method, path, account, params \\ [])

  defp prepare_request(client, :post, path, account, params) do
    opts = [
      headers: [
        {"Stripe-Account", account}
      ]
    ]

    handle_response(post(client, path, params, opts))
  end

  defp prepare_request(client, :get, path, account, params) do
    opts = [
      headers: [{"Stripe-Account", account}],
      query: params
    ]

    handle_response(get(client, path, opts))
  end

  defp prepare_request(client, :delete, path, account, params) do
    opts = [
      headers: [{"Stripe-Account", account}],
      query: params
    ]

    handle_response(delete(client, path, opts))
  end

  defp handle_response({:ok, %{body: %{"error" => error}}}) do
    {:error, error}
  end

  defp handle_response({:ok, %{body: body}}) do
    {:ok, body}
  end
end
