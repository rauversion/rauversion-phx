defmodule Ueberauth.Strategy.Stripe do
  @moduledoc """
  Stripe Strategy for Überauth.
  """
  use Ueberauth.Strategy,
    oauth2_module: Ueberauth.Strategy.Stripe.OAuth,
    ignores_csrf_attack: true

  alias Ueberauth.Auth.Info
  alias Ueberauth.Auth.Credentials
  alias Ueberauth.Auth.Extra

  @doc """
  Handles the initial redirect to the Stripe authentication page.
  You can also include a `state` param that Stripe will return to you.
  """
  def handle_request!(conn) do
    opts =
      [redirect_uri: callback_url(conn)]
      |> put_state_option(conn)

    module = option(conn, :oauth2_module)

    params = [
      scope: "read_write",
      state: "state"
    ]

    redirect!(conn, apply(module, :authorize_url!, [params, opts]))
  end

  defp put_state_option(opts, %{params: %{"state" => state}}) do
    Keyword.put(opts, :state, state)
  end

  defp put_state_option(opts, _), do: opts

  @doc """
  Handles the callback from Stripe.
  """
  def handle_callback!(%Plug.Conn{params: %{"code" => code}} = conn) do
    params = [code: code]
    module = option(conn, :oauth2_module)

    opts = [
      redirect_uri: callback_url(conn),
      headers: [{"authorization", "Bearer #{System.get_env("STRIPE_CLIENT_SECRET")}"}]
    ]

    case apply(module, :get_token, [params, opts]) do
      {:ok, %{token: %OAuth2.AccessToken{} = token}} ->
        conn
        |> put_private(:stripe_token, token)
        |> fetch_user(token)

      err ->
        handle_failure(conn, err)
    end
  end

  @doc false
  def handle_callback!(conn) do
    set_errors!(conn, [error("missing_code", "No code received")])
  end

  @doc false
  def handle_cleanup!(conn) do
    conn
    |> put_private(:stripe_user, nil)
    |> put_private(:stripe_token, nil)
  end

  @doc """
  Fetches the uid field from the response.
  """
  def uid(conn) do
    conn.private.stripe_user["id"]
  end

  @doc """
  Includes the credentials from the Stripe response.
  """
  def credentials(conn) do
    token = conn.private.stripe_token
    scope_string = token.other_params["scope"] || ""
    scopes = String.split(scope_string, " ")

    %Credentials{
      expires: !!token.expires_at,
      expires_at: token.expires_at,
      scopes: scopes,
      token_type: Map.get(token, :token_type),
      refresh_token: token.refresh_token,
      token: token.access_token
    }
  end

  @doc """
  Fetches the fields to populate the info section of the `Ueberauth.Auth` struct.
  """
  def info(conn) do
    user = conn.private.stripe_user

    %Info{
      email: nil,
      first_name: nil,
      image: nil,
      last_name: nil,
      nickname: nil
    }
  end

  @doc """
  Stores the raw information (including the token) obtained from the Stripe callback.
  """
  def extra(conn) do
    %Extra{
      raw_info: %{
        token: conn.private.stripe_token,
        user: conn.private.stripe_user
      }
    }
  end

  # API Requests

  defp fetch_user(conn, token) do
    module = option(conn, :oauth2_module)

    case apply(module, :get, [token, "https://api.stripe.com/v1/account"]) do
      {:ok, %{status_code: 200, body: user}} ->
        put_private(conn, :stripe_user, user)

      err ->
        handle_failure(conn, err)
    end
  end

  # Request failure handling

  defp handle_failure(conn, {:error, %OAuth2.Error{reason: reason}}) do
    set_errors!(conn, [error("OAuth2", reason)])
  end

  defp handle_failure(conn, {:error, %OAuth2.Response{status_code: 401}}) do
    set_errors!(conn, [error("token", "unauthorized")])
  end

  defp handle_failure(
         conn,
         {:error, %OAuth2.Response{body: %{"code" => code, "message" => message}}}
       ) do
    set_errors!(conn, [error("error_code_#{code}", "#{message} (#{code})")])
  end

  defp handle_failure(conn, {:error, %OAuth2.Response{status_code: status_code}}) do
    set_errors!(conn, [error("http_status_#{status_code}", "")])
  end

  # Private helpers

  defp option(conn, key) do
    Keyword.get(options(conn), key, Keyword.get(default_options(), key))
  end
end
