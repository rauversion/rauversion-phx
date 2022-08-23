defmodule RauversionWeb.TrackingEventsController do
  use RauversionWeb, :controller

  def show(conn, params = %{"track_id" => track_id}) do
    remote_ip = conn.remote_ip |> Tuple.to_list() |> Enum.join(".")

    lookup_data =
      case GeoIP.lookup(remote_ip) do
        {:ok, %{city: city, country: country}} ->
          %{city: city, country: country}

        _ ->
          %{city: nil, country: nil}
      end

    track = Rauversion.Tracks.get_track!(track_id)
    ua = get_req_header(conn, "user-agent") |> List.last()

    options = %{
      remote_ip: conn.remote_ip |> Tuple.to_list() |> Enum.join("."),
      country: lookup_data.country,
      city: lookup_data.city,
      ua: ua,
      lang: get_req_header(conn, "lang") |> List.last() || "en",
      referer: get_req_header(conn, "referer") |> List.last(),
      utm_medium: params["utm_medium"],
      utm_source: params["utm_source"],
      utm_campaign: params["utm_campaign"],
      utm_content: params["utm_content"],
      utm_term: params["utm_term"],
      browser_name: Browser.name(ua),
      browser_version: Browser.version(ua),
      modern: Browser.modern?(ua),
      platform: Browser.platform(ua) |> to_string,
      device_type: Browser.device_type(ua) |> to_string,
      bot: Browser.bot?(ua),
      search_engine: Browser.search_engine?(ua),
      track_id: track.id
    }

    user_id =
      case conn.assigns[:current_user] do
        %Rauversion.Accounts.User{id: id} -> id
        _ -> nil
      end

    options =
      options
      |> Map.put(:session_id, "session_id")
      |> Map.put(:user_id, user_id)
      |> Map.put(:resource_profile_id, track.user_id)
      |> Map.put(:inserted_at, DateTime.utc_now())
      |> Map.put(:updated_at, DateTime.utc_now())

    event =
      Rauversion.TrackingEvents.Event.changeset(
        %Rauversion.TrackingEvents.Event{},
        options
      )

    event
    |> Rauversion.TrackingEvents.WriteBuffer.insert()

    conn |> Plug.Conn.send_resp(200, Jason.encode!(options, pretty: true))
  end
end
