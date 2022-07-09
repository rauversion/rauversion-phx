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
    field :slug, :string
    field :title, TitleSlug.Type
    field :private, :boolean
    field :genre, :string
    field :playlist_type, :string
    # TODO: if user selects album on playlist_type, then the release_date should be required
    field :release_date, :utc_datetime

    belongs_to :user, Rauversion.Accounts.User
    embeds_one :metadata, Rauversion.Playlists.PlaylistMetadata, on_replace: :delete
    has_many :track_playlists, Rauversion.TrackPlaylists.TrackPlaylist, on_delete: :delete_all
    has_many :tracks, through: [:track_playlists, :tracks]
    has_many :likes, Rauversion.PlaylistLikes.PlaylistLike, on_delete: :delete_all
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
    |> cast(attrs, [
      :description,
      :private,
      :title,
      :user_id,
      :genre,
      :playlist_type,
      :release_date
    ])
    |> cast_embed(:metadata, with: &Rauversion.Playlists.PlaylistMetadata.changeset/2)
    |> cast_assoc(:track_playlists)
    |> validate_required([:title, :user_id])
    |> TitleSlug.maybe_generate_slug()
    |> TitleSlug.unique_constraint()
  end

  def form_definitions() do
    [
      %{
        name: :title,
        wrapper_class: "sm:col-span-4",
        type: :text_input
      },
      %{
        name: :description,
        wrapper_class: "sm:col-span-6",
        type: :textarea
      },
      %{
        name: :playlist_type,
        wrapper_class: "sm:col-span-2",
        type: :select,
        options: Rauversion.CategoryTypes.playlist_types()
      },
      %{
        name: :release_date,
        wrapper_class: "sm:col-span-2",
        type: :date_input
      },
      %{
        name: :genre,
        wrapper_class: "sm:col-span-3",
        type: :select,
        options: Rauversion.CategoryTypes.genres()
      }
    ]
  end
end
