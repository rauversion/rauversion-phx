defmodule Rauversion.Tracks.TrackMetadata do
  use Ecto.Schema
  import Ecto.Changeset
  # @primary_key false

  embedded_schema do
    field :peaks, {:array, :float}, default: []
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
    field :release_date, :date
    field :barcode, :string
    field :iswc, :string
    field :p_line, :string
    field :contains_explicit_content, :boolean
    field :copyright, :string
    field :genre, :string
    field :direct_download, :boolean
    field :display_embed, :boolean
    field :enable_comments, :boolean
    field :display_comments, :boolean
    field :display_stats, :boolean
    field :include_in_rss, :boolean
    field :offline_listening, :boolean
    field :enable_app_playblack, :boolean
    field :attribution, :boolean
    field :noncommercial, :boolean
    field :non_derivative_works, :boolean
    field :share_alike, :boolean
    field :copies, :string
    field :price, :decimal
    field :name_your_price, :boolean
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
    :direct_download,
    :display_embed,
    :enable_comments,
    :display_comments,
    :display_stats,
    :include_in_rss,
    :offline_listening,
    :enable_app_playblack,
    :attribution,
    :noncommercial,
    :copies,
    :peaks,
    :price,
    :name_your_price
  ]

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)

    # |> validate_inclusion(:type, ["frame", "content", "submit", "link", "url"])
    # |> validate_prescence_if_type("content", :content_url)
    # |> validate_prescence_url_if(["frame", "link", "url"])
  end

  def form_definitions(_type = "metadata") do
    [
      %{
        name: :genre,
        wrapper_class: "sm:col-span-2",
        type: :select,
        options: Rauversion.CategoryTypes.genres()
      },
      %{
        name: :contains_music,
        wrapper_class: "sm:col-span-2",
        type: :select,
        options: [Yes: true, No: false]
      },
      %{
        name: :artist,
        wrapper_class: "sm:col-span-2",
        type: :text_input
      },
      %{
        name: :publisher,
        wrapper_class: "sm:col-span-2",
        type: :text_input
      },
      %{
        name: :isrc,
        wrapper_class: "sm:col-span-2",
        type: :text_input,
        placeholder: "ISRC code"
      },
      %{
        name: :composer,
        wrapper_class: "sm:col-span-2",
        type: :text_input
      },
      %{
        name: :release_title,
        wrapper_class: "sm:col-span-2",
        type: :text_input
      },
      %{
        name: :buy_link,
        wrapper_class: "sm:col-span-4",
        type: :text_input
      },
      # %{name: :buy_link_title, field_type: :text_field, wrapper_class: "sm:col-span-2", type: :text_input},
      # %{name: :buy, field_type: :text_field, wrapper_class: "sm:col-span-2", type: :text_input},
      %{
        name: :album_title,
        wrapper_class: "sm:col-span-2",
        type: :text_input
      },
      %{
        name: :record_label,
        wrapper_class: "sm:col-span-2",
        type: :text_input
      },
      %{
        name: :release_date,
        wrapper_class: "sm:col-span-2",
        type: :date_input
      },
      %{
        name: :barcode,
        wrapper_class: "sm:col-span-4",
        type: :text_input
      },
      %{name: :iswc, field_type: :text_field, wrapper_class: "sm:col-span-2", type: :text_input},
      %{
        name: :p_line,
        wrapper_class: "sm:col-span-4",
        type: :text_input
      },
      %{
        name: :contains_explicit_content,
        wrapper_class: "sm:col-span-2",
        type: :select,
        options: [Yes: true, No: false]
      }
    ]
  end

  def form_definitions(_type = "permissions") do
    [
      %{
        name: :direct_download,
        wrapper_class: "sm:col-span-2",
        type: :checkbox,
        checked_hint:
          "This track will be available for direct download in the original format it was uploaded.",
        unchecked_hint:
          "This track will not be available for direct download in the original format it was uploaded."
      },
      %{
        name: :display_embed,
        wrapper_class: "sm:col-span-2",
        type: :checkbox,
        checked_hint: "This track’s embedded-player code will be displayed publicly.",
        unchecked_hint: "This track’s embedded-player code will only be displayed to you."
      },
      %{
        name: :enable_comments,
        wrapper_class: "sm:col-span-2",
        type: :checkbox,
        checked_hint: "Enable comments",
        unchecked_hint: "Comments disabled."
      },
      %{
        name: :display_comments,
        wrapper_class: "sm:col-span-2",
        type: :checkbox,
        checked_hint: "Display comments",
        unchecked_hint: "Don't display public comments."
      },
      %{
        name: :display_stats,
        wrapper_class: "sm:col-span-2",
        type: :checkbox,
        checked_hint: "Display public stats",
        unchecked_hint: "Don't display public stats."
      },
      %{
        name: :include_in_rss,
        wrapper_class: "sm:col-span-2",
        type: :checkbox,
        checked_hint: "This track will be included in your RSS feed if it is public.",
        unchecked_hint: "This track will not be included in your RSS feed."
      },
      %{
        name: :offline_listening,
        wrapper_class: "sm:col-span-2",
        type: :checkbox,
        checked_hint: "This track can be played on devices without an internet connection.",
        unchecked_hint:
          "Playing this track will not be possible on devices without an internet connection."
      },
      %{
        name: :enable_app_playblack,
        field_type: :text_fiel,
        wrapper_class: "sm:col-span-2",
        type: :checkbox,
        checked_hint: "This track will be playable outside of Rauversion and its apps.",
        unchecked_hint: "This track will not be playable outside of Rauversion and its apps."
      }
    ]
  end

  def form_definitions(_type = "common") do
    [
      %{
        name: :attribution,
        wrapper_class: "sm:col-span-2",
        type: :checkbox,
        hint:
          "Allow others to copy, distribute, display and perform your copyrighted work but only if they give credit the way you request."
      },
      %{
        name: :noncommercial,
        wrapper_class: "sm:col-span-2",
        type: :checkbox,
        hint:
          "Allow others to distribute, display and perform your work—and derivative works based upon it—but for noncommercial purposes only."
      },
      %{
        name: :copies,
        label: "Non derivative works",
        wrapper_class: "sm:col-span-2",
        type: :radio,
        value: "non_derivative_works",
        hint:
          "Allow others to copy, distribute, display and perform only verbatim copies of your work, not derivative works based upon it."
      },
      %{
        name: :copies,
        wrapper_class: "sm:col-span-2",
        label: "Share Alike",
        type: :radio,
        value: "share_alike",
        hint:
          "Allow others to distribute derivative works only under a license identical to the license that governs your work."
      }
    ]
  end

  # TODO: move this to another store / module
end
