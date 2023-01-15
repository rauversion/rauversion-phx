defmodule Rauversion.Playlists.PlaylistMetadata do
  use Ecto.Schema
  import Ecto.Changeset
  # @primary_key false

  embedded_schema do
    field :buy_link, :string
    field :buy_link_title, :string
    field :buy, :boolean
    field :record_label, :string

    field :attribution, :boolean
    field :noncommercial, :boolean
    field :non_derivative_works, :boolean
    field :share_alike, :boolean
    field :copies, :string
    field :copyright, :string
    field :price, :decimal
    field :name_your_price, :boolean
  end

  @required_fields []
  @optional_fields [
    :buy_link,
    :buy_link_title,
    :buy,
    :record_label,
    :copyright,
    :attribution,
    :noncommercial,
    :copies,
    :price,
    :name_your_price
  ]

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  # TODO: this is the same as the track metadata, consider unify this
end
