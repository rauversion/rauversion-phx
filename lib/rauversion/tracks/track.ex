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
    # field :metadata, :map, default: %{}
    embeds_one :metadata, Rauversion.Tracks.TrackMetadata, on_replace: :delete

    field :notification_settings, :map, default: %{}
    field :private, :boolean, default: false
    field :slug, TitleSlug.Type
    field :title, :string

    has_many :track_playlists, Rauversion.TrackPlaylists.TrackPlaylist
    has_many :playlists, through: [:track_playlists, :playlist]

    has_many :likes, Rauversion.TrackLikes.TrackLike
    has_many :reposts, Rauversion.Reposts.Repost

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
      :caption
      # :slug,
      # :caption,
      # :notification_settings,
      # :metadata
    ])
    |> cast_embed(:metadata, with: &Rauversion.Tracks.TrackMetadata.changeset/2)
    |> validate_required([
      :title
      # :description
      # :private
      # :slug,
      # :caption
      # :notification_settings,
      # :metadata
    ])
    |> TitleSlug.maybe_generate_slug()
    |> TitleSlug.unique_constraint()
  end

  def new_changeset(track, attrs) do
    track
    |> cast(attrs, [:title, :user_id, :private, :caption, :description])
    |> cast_embed(:metadata, with: &Rauversion.Tracks.TrackMetadata.changeset/2)
    |> validate_required([:user_id, :title])
    |> TitleSlug.maybe_generate_slug()
    |> TitleSlug.unique_constraint()
  end

  def process_one_upload(struct, attrs, kind) do
    case struct do
      %{valid?: true} ->
        case attrs do
          %{^kind => [file | _]} ->
            # Get peaks. maybe detach this processings
            struct =
              if kind == "audio" do
                # copy temp file from live
                file = generate_local_copy(file)

                Rauversion.Tracks.broadcast_change({:ok, struct.data}, [:tracks, :mp3_converting])

                %{path: path, blob: blob} = convert_to_mp3(struct, file)

                duration = blob |> ActiveStorage.Blob.metadata() |> Map.get("duration")

                Rauversion.Tracks.broadcast_change({:ok, struct.data}, [:tracks, :mp3_converted])

                case Rauversion.Services.PeaksGenerator.run_ffprobe(path, duration) do
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

            Rauversion.Tracks.broadcast_change({:ok, struct.data}, [:tracks, :mp3_attaching])

            attach_file_with_blob(struct, kind, file)

            Rauversion.Tracks.broadcast_change({:ok, struct.data}, [:tracks, :mp3_converted])

            struct

          _ ->
            struct
        end

      _ ->
        struct
    end
  end

  def convert_to_mp3(struct, file) do
    IO.inspect("CONVERT MP3 #{file.path}")
    IO.inspect(File.exists?(file.path))
    path = Rauversion.Services.Mp3Converter.run(file.path)

    IO.inspect("CONVERTED MP3!! #{path}")
    IO.inspect(File.exists?(path))

    blob =
      create_blob(file)
      |> ActiveStorage.Blob.analyze()

    attach_file(struct, "mp3_audio", blob)

    %{path: path, blob: blob}
  end

  def generate_local_copy(file) do
    {:ok, dir_path} = Temp.mkdir("my-dir")
    new_path = "#{dir_path}#{file.filename}" |> String.replace(~r/\s+/, "-")
    :ok = File.cp(file.path, new_path)
    %{file | path: new_path}
  end

  def create_blob(file) do
    ActiveStorage.Blob.create_and_upload!(
      %ActiveStorage.Blob{},
      io: {:path, file.path},
      filename: file.filename,
      content_type: file.content_type,
      identify: true
    )
  end

  #  TODO: maybe copy here the live-upload
  def attach_file_with_blob(struct, kind, file) do
    blob = create_blob(file)

    attach_file(struct, kind, blob)
  end

  def attach_file(struct, kind, blob) do
    cover = apply(struct.data.__struct__, :"#{kind}", [struct.data])
    apply(cover.__struct__, :attach, [cover, blob])
  end
end
