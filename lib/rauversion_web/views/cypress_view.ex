defmodule RauversionWeb.CypressView do
  use RauversionWeb, :view
  # alias ChaskiqWeb.CypressView

  def render("show.json", %{conn: _conn, result: r} = _bundle) do
    %{data: r, other: "nada"}
  end
end
