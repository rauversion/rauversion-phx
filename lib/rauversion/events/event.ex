defmodule Rauversion.Events.Event.TitleSlug do
  use EctoAutoslugField.Slug, from: :title, to: :slug
end

defmodule Rauversion.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rauversion.Events.Event.TitleSlug

  use ActiveStorage.Attached.Model
  use ActiveStorage.Attached.HasOne, name: :cover, model: "Track"

  schema "events" do
    field :age_requirement, :string

    field :attendee_list_settings, :map
    field :order_form, :map
    field :tax_rates_settings, :map
    field :widget_button, :map

    embeds_many :scheduling_settings, Rauversion.Events.Schedule
    embeds_many :tickets, Rauversion.Events.Ticket
    embeds_one :event_settings, Rauversion.Events.Settings

    field :city, :string
    field :country, :string
    field :location, :string
    field :postal, :string
    field :province, :string
    field :lat, :decimal
    field :lng, :decimal

    field :description, :string
    field :eticket, :boolean, default: false
    field :event_capacity, :boolean, default: false
    field :event_capacity_limit, :integer
    field :event_ends, :utc_datetime
    field :event_start, :utc_datetime

    field :event_short_link, :string
    field :online, :boolean, default: false
    field :private, :boolean, default: false
    field :slug, :string
    field :state, :string
    field :street, :string
    field :street_number, :string
    field :timezone, :string
    field :title, :string

    field :will_call, :boolean, default: false

    # field :user_id, :id

    belongs_to :user, Rauversion.Accounts.User

    timestamps()

    # cover image
    has_one(:cover_attachment, ActiveStorage.Attachment,
      where: [record_type: "Track", name: "cover"],
      foreign_key: :record_id
    )

    has_one(:cover_blob, through: [:cover_attachment, :blob])
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [
      :title,
      :description,
      :slug,
      :state,
      :timezone,
      :event_start,
      :event_ends,
      :private,
      :online,
      :location,
      :street,
      :street_number,
      :country,
      :city,
      :province,
      :postal,
      :lat,
      :lng,
      :age_requirement,
      :event_capacity,
      :event_capacity_limit,
      :eticket,
      :will_call,
      :order_form,
      :widget_button,
      :event_short_link,
      :tax_rates_settings,
      :attendee_list_settings,
      :user_id
    ])
    |> validate_required([
      # :event,
      :title,
      :description
      # :slug,
      # :state,
      # :timezone,
      # :event_start,
      # :event_ends,
      # :private,
      # :online,
      # :location,
      # :street,
      # :street_number,
      # :country,
      # :city,
      # :province,
      # :postal,
      # :age_requirement,
      # :event_capacity,
      # :event_capacity_limit,
      # :eticket,
      # :will_call,
      # :order_form,
      # :widget_button,
      # :event_short_link,
      # :tax_rates_settings,
      # :attendee_list_settings,
      # :event_settings
    ])
    |> cast_embed(:scheduling_settings, with: &Rauversion.Events.Schedule.changeset/2)
    |> cast_embed(:tickets, with: &Rauversion.Events.Ticket.changeset/2)
    |> cast_embed(:event_settings, with: &Rauversion.Events.Settings.changeset/2)
    |> TitleSlug.maybe_generate_slug()
    |> TitleSlug.unique_constraint()
  end

  defdelegate blob_url(user, kind), to: Rauversion.BlobUtils

  defdelegate blob_for(track, kind), to: Rauversion.BlobUtils

  defdelegate blob_proxy_url(user, kind), to: Rauversion.BlobUtils

  defdelegate variant_url(track, kind, options), to: Rauversion.BlobUtils

  defdelegate blob_url_for(track, kind), to: Rauversion.BlobUtils
end
