defmodule Rauversion.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rauversion.Events` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        age_requirement: "some age_requirement",
        attendee_list_settings: %{},
        city: "some city",
        country: "some country",
        description: "some description",
        eticket: true,
        event_capacity: true,
        event_capacity_limit: 42,
        event_ends: ~N[2022-08-12 17:38:00],
        event_settings: %{},
        event_short_link: "some event_short_link",
        event_start: ~U[2022-08-12 17:38:00Z],
        location: "some location",
        online: true,
        order_form: %{},
        postal: "some postal",
        private: true,
        province: "some province",
        slug: "some slug",
        street: "some street",
        street_number: "some street_number",
        tax_rates_settings: %{},
        timezone: "some timezone",
        title: "some title",
        widget_button: %{},
        will_call: true
      })
      |> Rauversion.Events.create_event()

    event
  end
end
