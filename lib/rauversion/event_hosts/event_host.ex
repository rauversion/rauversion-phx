defmodule Rauversion.EventHosts.EventHost do
  use Ecto.Schema
  import Ecto.Changeset

  use ActiveStorage.Attached.Model
  use ActiveStorage.Attached.HasOne, name: :avatar, model: "EventHost"

  schema "event_host" do
    field :description, :string
    field :name, :string
    belongs_to :event, Rauversion.Events.Event
    belongs_to :user, Rauversion.Accounts.User
    field :listed_on_page, :boolean
    field :event_manager, :boolean

    has_one(:avatar_attachment, ActiveStorage.Attachment,
      where: [record_type: "EventHost", name: "avatar"],
      foreign_key: :record_id
    )

    has_one(:avatar_blob, through: [:avatar_attachment, :blob])

    timestamps()
  end

  def record_type() do
    "EventHost"
  end

  @doc false
  def changeset(event_host, attrs) do
    event_host
    |> cast(attrs, [:name, :description, :listed_on_page, :event_manager, :user_id, :event_id])
    |> validate_required([:event_id])
    |> unsafe_validate_unique([:user_id, :event_id], Rauversion.Repo)
  end
end
