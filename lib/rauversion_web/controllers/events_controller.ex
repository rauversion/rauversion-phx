defmodule RauversionWeb.EventsController do
  use RauversionWeb, :controller

  def show(conn, params = %{"track_id" => track_id}) do
    # lookup = GeoIP.lookup("8.8.8.8")
    # require IEx
    # IEx.pry()

    track = Rauversion.Tracks.get_track!(track_id)
    ua = get_req_header(conn, "user-agent") |> List.last()

    options = %{
      remote_ip: conn.remote_ip |> Tuple.to_list() |> Enum.join("."),
      country: "",
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
      Rauversion.Events.Event.changeset(
        %Rauversion.Events.Event{},
        options
      )

    event
    |> Rauversion.Events.WriteBuffer.insert()

    conn |> Plug.Conn.send_resp(200, Jason.encode!(options, pretty: true))
  end
end
