defmodule Rauversion.EventRecordings.EventRecording do
  use Ecto.Schema
  import Ecto.Changeset

  schema "event_recordings" do
    field :properties, :map
    field :type, :string
    field :title, :string
    field :description, :string
    field :iframe, :string
    field :position, :integer
    field :event_id, :id

    timestamps()
  end

  @doc false
  def changeset(event_recording, attrs) do
    event_recording
    |> cast(attrs, [:type, :title, :iframe, :description, :properties, :event_id])
    |> validate_required([:title, :iframe, :description, :event_id])
  end
end
