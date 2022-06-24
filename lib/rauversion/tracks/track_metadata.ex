defmodule Rauversion.Tracks.TrackMetadata do
  use Ecto.Schema
  import Ecto.Changeset
  # @primary_key false

  embedded_schema do
    field :peaks, {:array, :float}
    field :contains_music, :boolean
    field :artist, :string
    field :publisher, :string
    field :isrc, :string
    field :composer, :string
    field :release_title, :string
    field :buy_link, :string
    field :buy_link_title, :string
    field :buy, :boolean
    field :album_title, :string
    field :record_label, :string
    field :release_date, :string
    field :barcode, :string
    field :iswc, :string
    field :p_line, :string
    field :contains_explicit_content, :boolean
    field :copyright, :string
    field :genre, :string
    field :direct_upload, :string
    field :display_embed, :boolean
    field :enable_comments, :boolean
    field :display_comments, :boolean
    field :display_stats, :boolean
    field :include_in_rss, :boolean
    field :offline_listening, :boolean
    field :enable_app_playblack, :boolean
  end

  @required_fields []
  @optional_fields [
    :contains_music,
    :artist,
    :publisher,
    :isrc,
    :composer,
    :release_title,
    :buy_link,
    :buy_link_title,
    :buy,
    :album_title,
    :record_label,
    :release_date,
    :barcode,
    :iswc,
    :p_line,
    :contains_explicit_content,
    :copyright,
    :genre,
    :direct_upload,
    :display_embed,
    :enable_comments,
    :display_comments,
    :display_stats,
    :include_in_rss,
    :offline_listening,
    :enable_app_playblack,
    :peaks
  ]

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)

    # |> validate_inclusion(:type, ["frame", "content", "submit", "link", "url"])
    # |> validate_prescence_if_type("content", :content_url)
    # |> validate_prescence_url_if(["frame", "link", "url"])
  end
end
