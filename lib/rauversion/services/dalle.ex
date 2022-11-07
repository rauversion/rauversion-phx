defmodule Rauversion.Services.OpenAi do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://api.openai.com/v1/"

  plug Tesla.Middleware.JSON

  @moduledoc """
  client = Rauversion.Services.OpenAi.new
  c = Rauversion.OauthCredentials.get_oauth_credential!(1)
  Rauversion.Services.OpenAi.images(client, prompt)
  """

  def new(token \\ nil) do
    token =
      case token do
        nil ->
          Application.get_env(:rauversion, :openai_api_key)

        t ->
          t
      end

    Tesla.client([
      {Tesla.Middleware.BearerAuth, token: token}
    ])
  end

  @doc """
  prompt
    string Required
    A text description of the desired image(s). The maximum length is 1000 characters.

    n
    integer Optional Defaults to 1
    The number of images to generate. Must be between 1 and 10.

    size string Optional
    Defaults to 1024x1024
    The size of the generated images. Must be one of 256x256, 512x512, or 1024x1024.

    response_format string
    Optional Defaults to url
    The format in which the generated images are returned. Must be one of url or b64_json.

    user string Optional
    A unique identifier representing your end-user, which will help OpenAI to monitor and detect abuse. Learn more.
  """
  def images(client, prompt) do
    options = %{prompt: prompt}

    case handle_response(post(client, "/images/generations", options)) do
      {:ok, %{"data" => [%{"url" => url}]}} -> {:ok, url}
      _ -> {:error, nil}
    end
  end

  defp handle_response({:ok, %{body: %{"error" => error}}}) do
    {:error, error}
  end

  defp handle_response({:ok, %{body: body}}) do
    {:ok, body}
  end
end
