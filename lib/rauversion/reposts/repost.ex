defmodule Rauversion.Reposts.Repost do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reposts" do
    field :user_id, :id
    field :track_id, :id

    timestamps()
  end

  @doc false
  def changeset(repost, attrs) do
    repost
    |> cast(attrs, [:user_id, :track_id])
    |> validate_required([:user_id, :track_id])
  end
end
