defmodule Rauversion.Tracks.Track do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tracks" do
    field :caption, :string
    field :description, :string
    field :metadata, :map
    field :notification_settings, :map
    field :private, :boolean, default: false
    field :slug, :string
    field :title, :string

    belongs_to(:user, Rauversion.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(track, attrs) do
    track
    |> cast(attrs, [
      :title,
      :description,
      :private,
      :user_id
      # :slug,
      # :caption,
      # :notification_settings,
      # :metadata
    ])
    |> validate_required([
      :title,
      :description
      # :private
      # :slug,
      # :caption
      # :notification_settings,
      # :metadata
    ])
  end
end
