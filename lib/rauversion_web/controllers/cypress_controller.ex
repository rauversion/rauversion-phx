defmodule RauversionWeb.CypressController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use RauversionWeb, :controller
  alias Rauversion.Accounts

  # alias Rauversion.Repo
  # import Ecto.Query

  def create(conn, _aaa) do
    {:ok, body, conn} = Plug.Conn.read_body(conn)

    case Jason.decode(body) do
      {:error, _} ->
        conn
        |> put_status(406)
        |> render("show.json", result: "error json")

      {:ok, a} ->
        response =
          case a do
            %{"name" => "clean"} ->
              # Ecto.Adapters.SQL.Sandbox.checkout(Chaskiq.Repo)
              Surgex.DatabaseCleaner.call(Rauversion.Repo)
              %{ok: "ok"}

            %{"name" => "scenarios/basic", "options" => options = %{}} ->
              basic(options)

            %{"name" => "scenarios/artist", "options" => options = %{}} ->
              artist(options)

            %{"name" => "eval"} ->
              {result, _} = Code.eval_string(a["options"], [])
              result

            any ->
              IO.puts("UNHANDLED!")
              IO.inspect(any)
              "ok"
          end

        conn
        |> put_status(200)
        |> render("show.json", result: response)
    end
  end

  defp basic(options) do
    Accounts.register_user(options)
    %{status: :ok}
  end

  defp artist(options) do
    {:ok, user} = Accounts.register_user(options)
    Accounts.update_user_type(user, "artist")

    %{status: :ok}
  end
end
