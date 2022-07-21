defmodule Rauversion.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "listening_events" do
    field :remote_ip, :string
    field :country, :string
    field :ua, :string
    field :lang, :string
    field :referer, :string
    field :utm_medium, :string
    field :utm_source, :string
    field :utm_campaign, :string
    field :utm_content, :string
    field :utm_term, :string
    field :browser_name, :string
    field :browser_version, :string
    field :modern, :boolean
    field :platform, :string
    field :device_type, :string
    field :bot, :boolean
    field :search_engine, :boolean
    # field :track_id, :integer
    belongs_to :track, Rauversion.Tracks.Track
    # field :user_id, :integer
    belongs_to :user, Rauversion.Accounts.User

    # field :resource_profile_id, :integer
    belongs_to :resource_profile, Rauversion.Accounts.User, foreign_key: :resource_profile_id

    field :action, :string, virtual: true
    timestamps()
  end

  @required_fields []
  @optional_fields [
    :remote_ip,
    :country,
    :ua,
    :lang,
    :referer,
    :utm_medium,
    :utm_source,
    :utm_campaign,
    :utm_content,
    :utm_term,
    :browser_name,
    :browser_version,
    :modern,
    :platform,
    :device_type,
    :bot,
    :search_engine,
    :track_id,
    :user_id,
    :resource_profile_id,
    :inserted_at,
    :updated_at
  ]

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
