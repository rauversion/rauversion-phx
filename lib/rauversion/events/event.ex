defmodule Rauversion.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "event" do
    field :age_requirement, :string
    field :attendee_list_settings, :map
    field :city, :string
    field :country, :string
    field :description, :string
    field :eticket, :boolean, default: false
    field :event, :string
    field :event_capacity, :boolean, default: false
    field :event_capacity_limit, :integer
    field :event_ends, :naive_datetime
    field :event_settings, :map
    field :event_short_link, :string
    field :event_start, :utc_datetime
    field :location, :string
    field :online, :boolean, default: false
    field :order_form, :map
    field :postal, :string
    field :private, :boolean, default: false
    field :province, :string
    field :slug, :string
    field :state, :string
    field :street, :string
    field :street_number, :string
    field :tax_rates_settings, :map
    field :timezone, :string
    field :title, :string
    field :widget_button, :map
    field :will_call, :boolean, default: false
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:event, :title, :description, :slug, :state, :timezone, :event_start, :event_ends, :private, :online, :location, :street, :street_number, :country, :city, :province, :postal, :age_requirement, :event_capacity, :event_capacity_limit, :eticket, :will_call, :order_form, :widget_button, :event_short_link, :tax_rates_settings, :attendee_list_settings, :event_settings])
    |> validate_required([:event, :title, :description, :slug, :state, :timezone, :event_start, :event_ends, :private, :online, :location, :street, :street_number, :country, :city, :province, :postal, :age_requirement, :event_capacity, :event_capacity_limit, :eticket, :will_call, :order_form, :widget_button, :event_short_link, :tax_rates_settings, :attendee_list_settings, :event_settings])
  end
end
