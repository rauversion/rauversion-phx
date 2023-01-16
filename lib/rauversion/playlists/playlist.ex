defmodule Rauversion.Playlists.Playlist.TitleSlug do
  use EctoAutoslugField.Slug, from: :title, to: :slug
end

defmodule Rauversion.Playlists.Playlist do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rauversion.Playlists.Playlist.TitleSlug

  use ActiveStorage.Attached.Model
  use ActiveStorage.Attached.HasOne, name: :cover, model: "Playlist"
  use ActiveStorage.Attached.HasOne, name: :zip, model: "Playlist"

  schema "playlists" do
    field :description, :string
    field :slug, :string
    field :title, TitleSlug.Type
    field :private, :boolean, default: false
    field :genre, :string
    field :custom_genre, :string
    field :playlist_type, :string, default: "playlist"
    # TODO: if user selects album on playlist_type, then the release_date should be required
    field :release_date, :utc_datetime

    field :likes_count, :integer, default: 0

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

    # zip
    has_one(:zip_attachment, ActiveStorage.Attachment,
      where: [record_type: "Playlist", name: "zip"],
      foreign_key: :record_id
    )

    has_one(:zip_blob, through: [:zip_attachment, :blob])

    timestamps()
  end

  def record_type do
    "Playlist"
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
      :custom_genre,
      :playlist_type,
      :release_date
    ])
    |> cast_embed(:metadata, with: &Rauversion.Playlists.PlaylistMetadata.changeset/2)
    |> cast_assoc(:track_playlists)
    |> validate_required([:title, :user_id])
    |> validate_by_type()
    |> validate_by_genre()
    |> TitleSlug.maybe_generate_slug()
    |> TitleSlug.unique_constraint()
  end

  defp validate_by_genre(changeset) do
    case get_field(changeset, :genre) do
      "Custom" ->
        changeset
        |> validate_required([:custom_genre],
          message: "Please enter a value."
        )

      _ ->
        changeset
    end
  end

  defp validate_by_type(changeset) do
    case get_field(changeset, :playlist_type) do
      "playlist" ->
        changeset

      # require release date for everything else
      _ ->
        changeset
        |> validate_required([:release_date],
          message: "Please enter a value."
        )

        # :option ->
        #  changeset |> validate_required([:option_id], message: "Please enter a value.")

        # _ ->
        #  changeset
    end
  end

  def form_definitions(changeset) do
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
        type: :datetime_input
      },
      %{
        name: :genre,
        wrapper_class: "sm:col-span-3",
        type: :select,
        options: ["", "Custom"] ++ Rauversion.CategoryTypes.genres()
      },
      custom_genre_field(changeset)
    ]
    |> Enum.filter(fn x -> !is_nil(x) end)
  end

  def pricing_definitions(_changeset) do
    [
      %{
        name: :price,
        wrapper_class: "sm:col-span-4",
        hint: "zero or more",
        label: "Price",
        type: :text_input
      },
      %{
        name: :name_your_price,
        wrapper_class: "sm:col-span-4",
        # hint: "Let users name the price",
        label: "let fans pay more if they want",
        type: :checkbox
      }
    ]
    |> Enum.filter(fn x -> !is_nil(x) end)
  end

  def custom_genre_field(changeset) do
    case is_custom_genre?(changeset) do
      true ->
        %{
          name: :custom_genre,
          wrapper_class: "sm:col-span-3",
          type: :text_input
        }

      _ ->
        nil
    end
  end

  def is_custom_genre?(changeset) do
    get_field(changeset, :genre) == "Custom"
  end
end
