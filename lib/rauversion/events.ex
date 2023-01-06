defmodule Rauversion.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias Rauversion.Repo

  alias Rauversion.Events.Event

  @doc """
  Returns the list of event.

  ## Examples

      iex> list_event()
      [%Event{}, ...]

  """
  def list_event do
    Repo.all(Event)
  end

  def all_events do
    Repo.all(Event)
  end

  def list_events(state \\ "published") when is_binary(state) do
    from(pi in Event,
      where: pi.state == ^state,
      preload: [:category, user: :avatar_blob]
    )

    # |> Repo.all()
  end

  def list_events(query, state) do
    query
    |> where([p], p.state == ^state)
    |> preload(user: :avatar_blob)

    # |> Repo.all()
  end

  def list_events(user = %Rauversion.Accounts.User{}) do
    user
    |> Ecto.assoc(:events)
    |> preload(user: :avatar_blob)

    # |> Repo.all()
  end

  def public_events() do
    from(pi in Event,
      where: pi.private == false,
      where: pi.state == ^"published",
      preload: [user: :avatar_blob]
    )
  end

  def public_events(query) do
    query
    |> where([e], e.private == false)
    |> where([e], e.state == "published")
  end

  def upcoming_events(query) do
    query
    |> where([e], e.event_start >= ^Timex.now())
    |> order_by(asc: :event_start)
  end

  def past_events(query) do
    query
    |> where([e], e.event_start <= ^Timex.now())
    |> order_by(desc: :event_start)
  end

  def list_tickets(event) do
    from(a in Rauversion.Events.Event,
      where: a.id == ^event.id,
      join: t in Rauversion.EventTickets.EventTicket,
      on: a.id == t.event_id,
      join: pt in Rauversion.PurchasedTickets.PurchasedTicket,
      on: t.id == pt.event_ticket_id,
      # group_by: [pt.id],
      limit: 10000,
      select: pt
      # order_by: [desc: count(t.id)],
      # preload: [
      #  :user
      # ]
    )
    |> Repo.all()
    |> Repo.preload([:user, :event_ticket])
  end

  def purchased_tickets(event) do
    from(a in Rauversion.Events.Event,
      where: a.id == ^event.id,
      join: t in Rauversion.EventTickets.EventTicket,
      on: a.id == t.event_id,
      join: pt in Rauversion.PurchasedTickets.PurchasedTicket,
      on: t.id == pt.event_ticket_id,
      select: count(pt)
    )
  end

  def purchased_tickets(event, event_ticket_id) do
    from(a in Rauversion.Events.Event,
      where: a.id == ^event.id,
      join: t in Rauversion.EventTickets.EventTicket,
      on: a.id == t.event_id and t.id == ^event_ticket_id,
      join: pt in Rauversion.PurchasedTickets.PurchasedTicket,
      on: t.id == pt.event_ticket_id,
      select: count(pt)
    )
  end

  # TODO: use this to identify specific individual or groups of tickets to filter with
  def purchased_tickets_by_user_id(event, user_id) do
    from(a in Rauversion.Events.Event,
      where: a.id == ^event.id,
      join: t in Rauversion.EventTickets.EventTicket,
      on: a.id == t.event_id,
      join: pt in Rauversion.PurchasedTickets.PurchasedTicket,
      on: t.id == pt.event_ticket_id and pt.user_id == ^user_id,
      select: pt.id
    )
  end

  def has_access_to_streaming?(event, _user = %Rauversion.Accounts.User{id: id}) do
    purchased_tickets_by_user_id(event, id) |> Repo.all() |> Enum.any?()
  end

  def has_access_to_streaming?(_event, _user = nil) do
    false
  end

  def get_purchased_ticket_count_for(event, event_ticket_id) do
    purchased_tickets(event, event_ticket_id)
  end

  def in_date(query, start_date) do
    # (start_date BETWEEN '2013-01-03'AND '2013-01-09') OR
    # (To_date BETWEEN '2013-01-03' AND '2013-01-09') OR
    # (start_date <= '2013-01-03' AND To_date >= '2013-01-09')

    conditions =
      dynamic(
        [p],
        ^start_date >= p.selling_start and ^start_date <= p.selling_end
      )

    # conditions =
    #  dynamic(
    #    [t],
    #    fragment(
    #      "? BETWEEN ? AND ?",
    #      ^start_date,
    #      t.selling_start,
    #      t.selling_end
    #    ) or
    #      ^conditions
    #  )

    query
    |> where([t], ^conditions)
  end

  def public_event_tickets(event) do
    start_date = Timex.now()

    event
    |> Ecto.assoc(:event_tickets)
    |> in_date(start_date)
    |> where([t], fragment("(settings ->> ?)::boolean = ?", "hidden", false))
    |> Rauversion.Repo.all()
  end

  def private_in_date_event_tickets(event) do
    start_date = Timex.now()

    event
    |> Ecto.assoc(:event_tickets)
    |> in_date(start_date)
    |> Rauversion.Repo.all()
  end

  def all_event_tickets(event) do
    event
    |> Ecto.assoc(:event_tickets)
    |> Rauversion.Repo.all()
  end

  def sales_count(event) do
    from(a in Rauversion.Events.Event,
      where: a.id == ^event.id,
      join: t in Rauversion.EventTickets.EventTicket,
      on: a.id == t.event_id,
      join: pt in Rauversion.PurchasedTickets.PurchasedTicket,
      on: t.id == pt.event_ticket_id,
      select: sum(fragment("(?->>'price')::integer", pt.data))
    )
    |> Repo.one()
  end

  def purchased_tickets_count(event) do
    purchased_tickets(event) |> Repo.one()
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)
  def get_by_slug!(id), do: Repo.get_by!(Event, slug: id)
  def get_by_slug(id), do: Repo.get_by(Event, slug: id)

  def get_host!(event, id) do
    event |> Ecto.assoc(:event_hosts) |> where([c], c.id == ^id) |> Repo.one()
  end

  def get_hosts(event) do
    event
    |> Ecto.assoc(:event_hosts)
    |> Repo.all()
    |> Repo.preload([:avatar_blob, :avatar_attachment, :user])
  end

  def get_hosts(event, listed) do
    event
    |> Ecto.assoc(:event_hosts)
    |> where([c], c.listed_on_page == ^listed)
    |> Repo.all()
    |> Repo.preload([:avatar_blob, :avatar_attachment, :user])
  end

  def hosts_count(event, listed \\ true) do
    event
    |> Ecto.assoc(:event_hosts)
    |> where([c], c.listed_on_page == ^listed)
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Rauversion.BlobUtils.process_one_upload(attrs, "cover")
    |> Repo.update()
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  def new_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
  end

  def event_dates(
        %{event_start: _event_start = nil, event_ends: _event_ends = nil},
        _timezone
      ) do
    ""
  end

  def event_dates(struct, timezone \\ "UTC") do
    start = Rauversion.Dates.convert_date(struct.event_start, timezone)
    ends = Rauversion.Dates.convert_date(struct.event_ends, timezone)

    case Cldr.Date.Interval.to_string(start, ends, Rauversion.Cldr) do
      {:ok, d} ->
        d

      _ ->
        start
    end
  end

  def simple_date_for(date, format \\ :long) do
    case Cldr.Date.to_string(date, format: format) do
      {:ok, d} -> d
      _ -> date
    end
  end

  def country_name(name) do
    case Countries.filter_by(:alpha2, name) do
      [%{name: country_name} | _] -> country_name
      _ -> name
    end
  end

  def presicion_for_currency(event) do
    case event.event_settings.ticket_currency do
      "usd" -> 2
      "clp" -> 0
    end
  end

  def publish_event!(event) do
    event
    |> Event.changeset(%{state: "published"})
    |> Repo.update()
  end

  def unpublish_event!(event) do
    event
    |> Event.changeset(%{state: "draft"})
    |> Repo.update()
  end

  def streaming_access_for(event) do
    Phoenix.Token.sign(RauversionWeb.Endpoint, "event", event.id)
  end

  def verify_streaming_access_for(token) do
    case Phoenix.Token.verify(RauversionWeb.Endpoint, "event", token) do
      {:ok, event_id} -> get_event!(event_id)
      _ -> nil
    end
  end

  def find_event_by_user(user, event_id) do
    event =
      user
      |> Ecto.assoc(:events)
      |> Repo.get_by(%{slug: event_id})
      |> Repo.preload([:event_tickets, :event_hosts])

    case event do
      nil ->
        Rauversion.Accounts.find_managed_event(user, event_id)
        |> Rauversion.Repo.one()
        |> Repo.preload([:event_tickets, :event_hosts])

      _ ->
        event
    end
  end

  def private_streaming_link(event) do
    RauversionWeb.Router.Helpers.events_streaming_show_path(
      RauversionWeb.Endpoint,
      :show,
      event.slug,
      streaming_access_for(event)
    )
  end

  def get_recording(event, id) do
    event |> Ecto.assoc(:event_recordings) |> where(id: ^id) |> Repo.one()
  end
end
