defmodule Rauversion.Tracks.Track.TitleSlug do
  use EctoAutoslugField.Slug, from: :title, to: :slug
end

defmodule Rauversion.Tracks.Track do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rauversion.Tracks.Track.TitleSlug

  use ActiveStorage.Attached.Model
  use ActiveStorage.Attached.HasOne, name: :audio, model: "Track"
  use ActiveStorage.Attached.HasOne, name: :mp3_audio, model: "Track"
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

    # original audio
    has_one(:audio_attachment, ActiveStorage.Attachment,
      where: [record_type: "Track", name: "audio"],
      foreign_key: :record_id
    )

    has_one(:audio_blob, through: [:audio_attachment, :blob])

    # mp3 audio
    has_one(:mp3_audio_attachment, ActiveStorage.Attachment,
      where: [record_type: "Track", name: "mp3_audio"],
      foreign_key: :record_id
    )

    has_one(:mp3_audio_blob, through: [:mp3_audio_attachment, :blob])

    # cover image
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
      :caption,
      :metadata
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

  def process_one_upload(struct, attrs, kind) do
    case attrs do
      %{^kind => [file | _]} ->
        # Get peaks. maybe detach this processings
        struct =
          if kind == "audio" do
            %{path: path} = convert_to_mp3(struct, file)

            case Rauversion.Services.PeaksGenerator.run_audiowaveform(path) do
              [_ | _] = data ->
                put_change(struct, :metadata, %{peaks: data})

              _ ->
                struct
            end
          else
            struct
          end

        # Tracks.update_track(struct, %{metadata: %{peaks: data}})
        ####

        IO.inspect(struct)

        attach_file_with_blob(struct, kind, file)

        struct

      _ ->
        struct
    end
  end

  def convert_to_mp3(struct, file) do
    path = Rauversion.Services.Mp3Converter.run(file.path)

    blob =
      ActiveStorage.Blob.create_and_upload!(
        %ActiveStorage.Blob{},
        io: {:path, path},
        filename: "audio.mp3",
        content_type: "audio/mpeg",
        identify: true
      )

    attach_file(struct, "mp3_audio", blob)

    %{path: path, blob: blob}
  end

  def attach_file_with_blob(struct, kind, file) do
    blob =
      ActiveStorage.Blob.create_and_upload!(
        %ActiveStorage.Blob{},
        io: {:path, file.path},
        filename: file.filename,
        content_type: file.content_type,
        identify: true
      )

    attach_file(struct, kind, blob)
  end

  def attach_file(struct, kind, blob) do
    cover = apply(struct.data.__struct__, :"#{kind}", [struct.data])
    apply(cover.__struct__, :attach, [cover, blob])
  end
end
