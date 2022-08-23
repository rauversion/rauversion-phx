defmodule Ueberauth.Strategy.Twitter do
  @moduledoc """
  Twitter Strategy for Überauth.
  """
  use Ueberauth.Strategy,
    oauth2_module: Ueberauth.Strategy.Twitter.OAuth,
    ignores_csrf_attack: true

  alias Ueberauth.Auth.Info
  alias Ueberauth.Auth.Credentials
  alias Ueberauth.Auth.Extra

  @doc """
  Handles the initial redirect to the Twitter authentication page.
  You can also include a `state` param that Twitter will return to you.
  """
  def handle_request!(conn) do
    opts =
      [
        redirect_uri: callback_url(conn)
      ]
      |> put_state_option(conn)

    params = [
      scope: "tweet.read users.read offline.access",
      code_challenge: "challenge",
      code_challenge_method: "plain",
      state: "state"
    ]

    module = option(conn, :oauth2_module)

    redirect!(conn, apply(module, :authorize_url!, [params, opts]))
  end

  defp put_state_option(opts, %{params: %{"state" => state}}) do
    Keyword.put(opts, :state, state)
  end

  defp put_state_option(opts, _), do: opts

  @doc """
  Handles the callback from Twitter.
  """
  def handle_callback!(%Plug.Conn{params: %{"code" => code}} = conn) do
    params = [code: code]
    module = option(conn, :oauth2_module)
    opts = [redirect_uri: callback_url(conn)]

    case apply(module, :get_token, [params, opts]) do
      {:ok, %{token: %OAuth2.AccessToken{} = token}} ->
        conn
        |> put_private(:twitter_token, token)
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
    |> put_private(:twitter_user, nil)
    |> put_private(:twitter_token, nil)
  end

  @doc """
  Fetches the uid field from the response.
  """
  def uid(conn) do
    conn.private.twitter_user["id"]
  end

  @doc """
  Includes the credentials from the Twitter response.
  """
  def credentials(conn) do
    token = conn.private.twitter_token
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
    user = conn.private.twitter_user

    %Info{
      email: nil,
      first_name: user["name"],
      image: user["profile_image_url"],
      last_name: nil,
      name: user["name"],
      urls:
        %{
          # personal_meeting_url: user["personal_meeting_url"],
          # vanity_url: user["vanity_url"]
        }
    }
  end

  @doc """
  Stores the raw information (including the token) obtained from the Twitter callback.
  """
  def extra(conn) do
    %Extra{
      raw_info: %{
        token: conn.private.twitter_token,
        user: conn.private.twitter_user
      }
    }
  end

  # API Requests
  defp fetch_user(conn, token) do
    module = option(conn, :oauth2_module)

    case apply(module, :get, [
           token,
           "/2/users/me?&user.fields=created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld"
         ]) do
      {:ok, %{status_code: 200, body: user}} ->
        put_private(conn, :twitter_user, user["data"])

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
