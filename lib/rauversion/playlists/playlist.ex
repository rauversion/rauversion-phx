defmodule Rauversion.Playlists.Playlist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "playlists" do
    field :description, :string
    field :metadata, :map
    field :slug, :string
    field :title, :string
    belongs_to :user, Rauversion.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(playlist, attrs) do
    playlist
    |> cast(attrs, [:slug, :description, :title, :metadata])
    |> validate_required([:slug, :description, :title, :metadata])
  end
end
