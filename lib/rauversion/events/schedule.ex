defmodule Rauversion.Events.Schedule do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime
    field :schedule_type, :string
    field :name, :string
    field :description, :string
    embeds_many :schedulings, Rauversion.Events.Scheduling, on_replace: :delete
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:start_date, :end_date, :schedule_type, :name, :description])
    |> cast_embed(:schedulings, with: &Rauversion.Events.Scheduling.changeset/2)
    |> validate_required([:start_date, :end_date, :schedule_type, :name])
  end
end
