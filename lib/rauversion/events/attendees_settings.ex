defmodule Rauversion.Events.AttendeesSettings do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime
    field :schedule_type, :string
  end

  @required_fields []
  @optional_fields []

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
