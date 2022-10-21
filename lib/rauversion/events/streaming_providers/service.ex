defmodule Rauversion.Events.StreamingProviders.Service do
  alias RauversionWeb.Router.Helpers, as: Routes

  def webhook_url(id, struct) do
    message = %{event_id: id, type: "jitsy"}
    key = Plug.Crypto.MessageVerifier.sign(Jason.encode!(message), secret())
    conn = RauversionWeb.Endpoint
    Routes.event_webhooks_path(conn, :create, key)
  end

  def find_by_key(key) do
    with {:ok, json} <- Plug.Crypto.MessageVerifier.verify(key, secret()),
         {:ok, %{"event_id" => _event_id, "type" => _type} = data} <- Jason.decode(json) do
      data
    else
      # nil -> {:error, ...} an example that we can match here too
      err ->
        require IEx
        IEx.pry()
        err
    end
  end

  def secret() do
    "abcd"
  end

  def process_by_key(key) do
    case find_by_key(key) do
      %{"event_id" => _, "type" => type} = data ->
        find_module_by_type(type) |> process(data)

      _ ->
        nil
    end
  end

  def find_module_by_type(type) do
    case type do
      "jitsi" -> Rauversion.Events.StreamingProviders.Jitsi
      "whereby" -> Rauversion.Events.StreamingProviders.Whereby
      "mux" -> Rauversion.Events.StreamingProviders.Mux
      "zoom" -> Rauversion.Events.StreamingProviders.Zoom
      "restream" -> Rauversion.Events.StreamingProviders.Restream
      "twitch" -> Rauversion.Events.StreamingProviders.Twitch
      "stream_yard" -> Rauversion.Events.StreamingProviders.StreamYard
      _ -> nil
    end
  end

  def process(mod, data) do
    case mod do
      nil -> nil
      _ -> mod.process(data)
    end
  end
end
