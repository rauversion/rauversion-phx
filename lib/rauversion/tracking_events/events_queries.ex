defmodule CountByDateQuery do
  import Ecto.Query
  use Timex
  alias Rauversion.Repo
  alias Rauversion.TrackingEvents.Event
  alias Rauversion.Tracks.Track
  alias Rauversion.Accounts.User

  @doc "to_char function for formatting datetime as dd MON YYYY"
  defmacro to_char(field, format) do
    quote do
      fragment("to_char(?, ?)", unquote(field), unquote(format))
    end
  end

  def top_tracks(profile_id) do
    from(a in Track,
      join: t in Event,
      on: a.id == t.track_id and t.resource_profile_id == ^profile_id,
      group_by: [a.id],
      limit: 10,
      select: %{
        count: count(t.id),
        title: a.title,
        track: a
      },
      order_by: [desc: count(t.id)],
      preload: [
        :cover_blob,
        user: [:avatar_blob]
      ]
    )
    |> Repo.all()
  end

  def top_listeners(profile_id) do
    from(a in User,
      join: t in Event,
      on: a.id == t.user_id and t.resource_profile_id == ^profile_id,
      group_by: [a.id],
      limit: 10,
      select: %{
        count: count(t.id),
        user: a
      },
      order_by: [desc: count(t.id)],
      preload: [
        :avatar_blob
      ]
    )
    |> Repo.all()
  end

  def top_countries(profile_id) do
    from(event in Event,
      where: event.resource_profile_id == ^profile_id,
      group_by: [event.country],
      limit: 10,
      select: %{
        count: count(event.country),
        country: event.country
      },
      order_by: [desc: count(event.id)]
    )
    |> Repo.all()
  end

  def series_by_month(profile_id) do
    from(c in Event,
      right_join: day in fragment("select generate_series(
            date_trunc('month', now()) - '12 month'::interval,
            date_trunc('month', now()),
            '1 month'
            )::date AS d"),
      # and c.link_id == 15,
      on:
        day.d == fragment("date_trunc('month', ?)", c.inserted_at) and
          c.resource_profile_id == ^profile_id,
      group_by: day.d,
      order_by: day.d,
      select: %{
        #  fragment("date(?)", day.d),
        day: to_char(day.d, "Mon-YYYY"),
        count: count(c.id)
      }
    )

    # select date(d) as day, count(listening_events.id)
    #  from generate_series(
    #    date_trunc('month', now()) - '12 month'::interval,
    #    date_trunc('month', now()),
    #    '1 month'
    #  ) d
    # left join listening_events on date_trunc('month', listening_events.inserted_at) = d
    # group by day order by day;
  end
end
