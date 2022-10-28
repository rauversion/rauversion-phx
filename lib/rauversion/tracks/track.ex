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
    field :state, :string, default: "pending"

    # field :metadata, :map, default: %{}
    embeds_one :metadata, Rauversion.Tracks.TrackMetadata, on_replace: :delete

    field :notification_settings, :map, default: %{}
    field :private, :boolean, default: false
    field :slug, TitleSlug.Type
    field :title, :string
    field :likes_count, :integer, default: 0
    field :reposts_count, :integer, default: 0

    has_many :listening_events, Rauversion.TrackingEvents.Event, on_delete: :delete_all
    has_many :track_comments, Rauversion.TrackComments.TrackComment, on_delete: :delete_all
    has_many :track_playlists, Rauversion.TrackPlaylists.TrackPlaylist, on_delete: :delete_all
    has_many :playlists, through: [:track_playlists, :playlist]

    has_many :likes, Rauversion.TrackLikes.TrackLike, on_delete: :delete_all
    has_many :reposts, Rauversion.Reposts.Repost, on_delete: :delete_all

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

  use Fsmx.Struct,
    transitions: %{
      "pending" => ["processing", "processed"],
      "processing" => ["pending", "processed"],
      "processed" => ["pending"]
    }

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
            IO.inspect("kind processing: ")
            IO.inspect(kind)
            # Get peaks. maybe detach this processings
            struct =
              if kind == "audio" do
                # copy temp file from live
                file = generate_local_copy(file)

                IO.inspect("inserting oban job: ")

                %{file: file, track_id: struct.data.id}
                |> Rauversion.Workers.TrackProcessorWorker.new()
                |> Oban.insert()

                struct
              else
                IO.inspect("no job inserting for track processor: ")

                struct
              end

            # Tracks.update_track(struct, %{metadata: %{peaks: data}})
            ####

            Rauversion.Tracks.broadcast_change({:ok, struct.data}, [:tracks, :mp3_attaching])

            Rauversion.BlobUtils.attach_file_with_blob(struct, kind, file)

            Rauversion.Tracks.broadcast_change({:ok, struct.data}, [:tracks, :mp3_converted])

            struct

          ee ->
            IO.inspect("NO PROCESSING")
            IO.inspect(ee)
            struct
        end

      _ ->
        struct
    end
  end

  def process_peaks(struct, blob, path) do
    duration = blob |> ActiveStorage.Blob.metadata() |> Map.get("duration")

    Rauversion.Tracks.broadcast_change({:ok, struct.data}, [:tracks, :mp3_converted])

    struct =
      case Rauversion.Services.PeaksGenerator.run_ffprobe(path, duration) do
        [_ | _] = data ->
          put_change(struct, :metadata, %{peaks: data})
          |> put_change(:state, "processed")

        _ ->
          put_change(struct, :state, "processed")
      end

    struct |> Rauversion.Repo.update()
  end

  def convert_to_mp3(struct, file) do
    IO.inspect("CONVERT MP3 #{file.path}")
    IO.inspect(File.exists?(file.path))

    path = transform_to_mp3(file.path)
    # audio_blob = create_and_analyze_audio(struct, file)
    blob = create_and_analyze_audio(struct, file, "mp3_audio")
    # create_and_analyze_audio(struct, file)

    %{path: path, blob: blob}
  end

  def create_and_analyze_audio(struct, file, kind \\ "audio") do
    blob =
      Rauversion.BlobUtils.create_blob(file)
      |> ActiveStorage.Blob.analyze()

    Rauversion.BlobUtils.attach_file(struct, kind, blob)

    blob
  end

  def transform_to_mp3(path) do
    IO.inspect("CONVERT MP3 #{path}")
    IO.inspect(File.exists?(path))
    path = Rauversion.Services.Mp3Converter.run(path)
    IO.inspect("CONVERTED MP3!! #{path}")
    IO.inspect(File.exists?(path))
    path
  end

  def generate_local_copy(file) do
    {:ok, dir_path} = Temp.mkdir("my-dir")
    new_path = "#{dir_path}#{file.filename}" |> String.replace(~r/\s+/, "-")
    :ok = File.cp(file.path, new_path)
    %{file | path: new_path}
  end
end
