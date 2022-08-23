defmodule Ueberauth.Strategy.Twitter.OAuthStrategy do
  alias OAuth2.Client

  @callback client(Keyword.t()) :: Client.t()
  @callback authorize_url!(Client.params(), Keyword.t()) :: Client.t()
  @callback get_token(Client.params(), opts :: Keyword.t()) ::
              {:ok, Client.t()} | {:error, OAuth2.Response.t()} | {:error, OAuth2.Error.t()}
  @callback get(Client.t(), url :: String.t(), Client.headers(), opts :: Keyword.t()) ::
              {:ok, Client.t()} | {:error, OAuth2.Response.t()} | {:error, OAuth2.Error.t()}
end
