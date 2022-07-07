defmodule Rauversion.Playlists.Playlist.TitleSlug do
  use EctoAutoslugField.Slug, from: :title, to: :slug
end

defmodule Rauversion.Playlists.Playlist do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rauversion.Playlists.Playlist.TitleSlug

  use ActiveStorage.Attached.Model
  use ActiveStorage.Attached.HasOne, name: :cover, model: "Playlist"

  schema "playlists" do
    field :description, :string
    embeds_one :metadata, Rauversion.Playlists.PlaylistMetadata, on_replace: :delete

    field :slug, :string
    field :title, TitleSlug.Type
    field :private, :boolean
    belongs_to :user, Rauversion.Accounts.User
    has_many :track_playlists, Rauversion.TrackPlaylists.TrackPlaylist
    has_many :tracks, through: [:track_playlists, :tracks]
    # many_to_many :tracks, Rauversion.Tracks.Track,
    #  join_through: Rauversion.TrackPlaylists.TrackPlaylist

    has_many :likes, Rauversion.PlaylistLikes.PlaylistLike

    # cover image
    has_one(:cover_attachment, ActiveStorage.Attachment,
      where: [record_type: "Playlist", name: "cover"],
      foreign_key: :record_id
    )

    has_one(:cover_blob, through: [:cover_attachment, :blob])

    timestamps()
  end

  @doc false
  def changeset(playlist, attrs) do
    playlist
    |> cast(attrs, [:description, :private, :title, :user_id])
    |> cast_embed(:metadata, with: &Rauversion.Playlists.PlaylistMetadata.changeset/2)
    # |> cast_assoc(:tracks)
    |> cast_assoc(:track_playlists)
    |> validate_required([:title, :user_id])
    |> TitleSlug.maybe_generate_slug()
    |> TitleSlug.unique_constraint()
  end
end
