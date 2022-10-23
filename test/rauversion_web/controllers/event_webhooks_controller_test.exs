defmodule RauversionWeb.EventWebhooksControllerTest do
  use RauversionWeb.ConnCase, async: true

  import Rauversion.AccountsFixtures

  setup do
    %{user: user_fixture()}
  end

  describe "POST /users/confirm" do
    test "renders the resend confirmation page", %{conn: conn} do
      a = %{service: "jitsi"}
      event_id = 1
      url = Rauversion.Events.StreamingProviders.Service.webhook_url(event_id, a)

      # conn = post(conn, Routes.event_webhooks_path(conn, :create, "123"), %{})
      conn = post(conn, url, %{})

      response = json_response(conn, 200)
      assert response == %{"a" => "ok"}
    end
  end
end

# defmodule RauversionWeb.UserAuthTest do
#  use RauversionWeb.ConnCase, async: true#

#  alias Rauversion.Accounts
#  alias RauversionWeb.UserAuth
#  import Rauversion.AccountsFixtures
