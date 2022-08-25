defmodule Rauversion.Events.Scheduling do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :title, :string
    field :short_description, :string
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [
      :title,
      :start_date,
      :end_date,
      :short_description
    ])
    |> validate_required([:title, :start_date, :end_date, :short_description])
  end
end
