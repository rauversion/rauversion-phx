defmodule RauversionWeb.ArtistCheckPlug do
  import Plug.Conn
  # , only: [redirect: 2]
  import Phoenix.Controller
  # , only: [halt: 1]
  import Plug.Conn

  def init(default), do: default

  # def call(%Plug.Conn{params: %{"locale" => loc}} = conn, _default) when loc in @locales do
  #  assign(conn, :locale, loc)
  # end

  def call(
        %Plug.Conn{
          request_path: path,
          assigns: %{current_user: %{type: "artist", username: username}}
        } = conn,
        _default
      )
      when is_nil(username) do
    if(path != "/users/settings") do
      conn
      |> put_flash(:info, "Please update your artist username")
      |> redirect(to: "/users/settings")
      |> halt()
    else
      conn
    end
  end

  def call(conn, _default) do
    conn
  end
end
