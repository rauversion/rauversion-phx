defmodule Rauversion.Events.Schedule do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime
    field :schedule_type, :string
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:start_date, :end_date, :schedule_type])
    |> validate_required([:start_date, :end_date, :schedule_type])
  end
end
