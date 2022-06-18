defmodule Rauversion.Tracks.Track.TitleSlug do
  use EctoAutoslugField.Slug, from: :title, to: :slug
end

defmodule Rauversion.Tracks.Track do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rauversion.Tracks.Track.TitleSlug

  use ActiveStorage.Attached.Model
  use ActiveStorage.Attached.HasOne, name: :audio, model: "Track"
  use ActiveStorage.Attached.HasOne, name: :cover, model: "Track"

  schema "tracks" do
    field :caption, :string
    field :description, :string
    field :metadata, :map, default: %{}
    field :notification_settings, :map, default: %{}
    field :private, :boolean, default: false
    field :slug, TitleSlug.Type
    field :title, :string

    belongs_to(:user, Rauversion.Accounts.User)

    has_one(:audio_attachment, ActiveStorage.Attachment,
      where: [record_type: "Track", name: "audio"],
      foreign_key: :record_id
    )

    has_one(:audio_blob, through: [:audio_attachment, :blob])

    has_one(:cover_attachment, ActiveStorage.Attachment,
      where: [record_type: "Track", name: "cover"],
      foreign_key: :record_id
    )

    has_one(:cover_blob, through: [:cover_attachment, :blob])

    timestamps()
  end

  def record_type() do
    "Track"
  end

  @doc false
  def changeset(track, attrs) do
    track
    |> cast(attrs, [
      :title,
      :description,
      :private,
      :user_id,
      :caption
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
    |> TitleSlug.maybe_generate_slug()
    |> TitleSlug.unique_constraint()
  end

  def process_one_upload(user, attrs, kind) do
    case attrs do
      %{^kind => [file | _]} ->
        blob =
          ActiveStorage.Blob.create_and_upload!(
            %ActiveStorage.Blob{},
            io: {:path, file.path},
            filename: file.filename,
            content_type: file.content_type,
            identify: true
          )

        cover = apply(user.data.__struct__, :"#{kind}", [user.data])
        apply(cover.__struct__, :attach, [cover, blob])

        user

      _ ->
        user
    end
  end
end
