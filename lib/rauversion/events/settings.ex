defmodule Rauversion.Events.Settings do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :participant_label, :string, default: "speakers"
    field :participant_description, :string
    field :accept_sponsors, :boolean
    field :sponsors_label, :string
    field :sponsors_description, :string

    field :scheduling_label, :string
    field :scheduling_description, :string
  end

  @required_fields []
  @optional_fields [
    :participant_label,
    :participant_description,
    :accept_sponsors,
    :sponsors_label,
    :sponsors_description,
    :scheduling_label,
    :scheduling_description
  ]

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
