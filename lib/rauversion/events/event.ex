defmodule Rauversion.Events.Event.TitleSlug do
  use EctoAutoslugField.Slug, from: :title, to: :slug

  def build_slug(sources) do
    # See docs:
    # https://hexdocs.pm/ecto_autoslug_field/EctoAutoslugField.SlugBase.html#build_slug/1
    # => will receive default slug: my-todo
    slug = super(sources)

    if Rauversion.Events.get_by_slug(slug) do
      slug <> "-" <> Ecto.UUID.generate()
    else
      slug
    end
  end
end

defmodule Rauversion.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset
  import PolymorphicEmbed

  alias Rauversion.Events.Event.TitleSlug

  use ActiveStorage.Attached.Model
  use ActiveStorage.Attached.HasOne, name: :cover, model: "Track"

  schema "events" do
    field :age_requirement, :string

    field :attendee_list_settings, :map
    field :order_form, :map
    field :tax_rates_settings, :map
    field :widget_button, :map

    has_many :event_hosts, Rauversion.EventHosts.EventHost, on_replace: :delete

    has_many :event_tickets, Rauversion.EventTickets.EventTicket, on_replace: :delete

    embeds_many :scheduling_settings, Rauversion.Events.Schedule, on_replace: :delete
    # embeds_many :tickets, Rauversion.Events.Ticket
    embeds_one :event_settings, Rauversion.Events.Settings

    polymorphic_embeds_one(:streaming_service,
      types: [
        jitsi: Rauversion.Events.Schemas.Jitsi,
        whereby: Rauversion.Events.Schemas.Whereby,
        mux: Rauversion.Events.Schemas.Mux,
        zoom: Rauversion.Events.Schemas.Zoom,
        twitch: Rauversion.Events.Schemas.Twitch,
        restream: Rauversion.Events.Schemas.Restream,
        stream_yard: Rauversion.Events.Schemas.StreamYard
        # email: MyApp.Channel.Email
      ],
      on_type_not_found: :raise,
      on_replace: :update
    )

    field :venue, :string
    field :city, :string
    field :country, :string
    field :location, :string
    field :postal, :string
    field :province, :string
    field :lat, :decimal
    field :lng, :decimal

    field :timezone, :string
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
    field :state, :string, default: "draft"
    field :street, :string
    field :street_number, :string
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

  def record_type() do
    "Event"
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [
      :venue,
      :title,
      :description,
      :slug,
      :state,
      :event_start,
      :event_ends,
      :private,
      :online,
      :location,
      :street,
      :timezone,
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
    |> cast_polymorphic_embed(:streaming_service, required: false)
    |> cast_embed(:scheduling_settings, with: &Rauversion.Events.Schedule.changeset/2)
    # |> cast_embed(:tickets, with: &Rauversion.Events.Ticket.changeset/2)
    |> cast_assoc(:event_hosts, with: &Rauversion.EventHosts.EventHost.changeset/2)
    |> cast_assoc(:event_tickets, with: &Rauversion.EventTickets.EventTicket.changeset/2)
    |> cast_embed(:event_settings, with: &Rauversion.Events.Settings.changeset/2)
    |> TitleSlug.maybe_generate_slug()
    |> TitleSlug.unique_constraint()

    # |> handle_tz_for(:event_start)
    # |> handle_tz_for(:event_ends)
  end

  defdelegate blob_url(user, kind), to: Rauversion.BlobUtils

  defdelegate blob_for(track, kind), to: Rauversion.BlobUtils

  defdelegate blob_proxy_url(user, kind), to: Rauversion.BlobUtils

  defdelegate variant_url(track, kind, options), to: Rauversion.BlobUtils

  defdelegate blob_url_for(track, kind), to: Rauversion.BlobUtils
end
