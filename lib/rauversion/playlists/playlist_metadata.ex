defmodule Rauversion.Playlists.PlaylistMetadata do
  use Ecto.Schema
  import Ecto.Changeset
  # @primary_key false

  embedded_schema do
    field :buy_link, :string
    field :buy_link_title, :string
    field :buy, :boolean
    field :record_label, :string
  end

  @required_fields []
  @optional_fields [
    :buy_link,
    :buy_link_title,
    :buy,
    :record_label
  ]

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
