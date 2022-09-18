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

  def list_tickets(event) do
    from(a in Rauversion.Events.Event,
      where: a.id == ^event.id,
      join: t in Rauversion.EventTickets.EventTicket,
      on: a.id == t.event_id,
      join: pt in Rauversion.PurchasedTickets.PurchasedTicket,
      on: t.id == pt.event_ticket_id,
      # group_by: [pt.id],
      limit: 10,
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

  def get_host!(event, id) do
    event |> Ecto.assoc(:event_hosts) |> where([c], c.id == ^id) |> Repo.one()
  end

  def get_hosts(event, listed \\ true) do
    event
    |> Ecto.assoc(:event_hosts)
    |> where([c], c.listed_on_page == ^listed)
    |> Repo.all()
    |> Repo.preload([:avatar_blob, :avatar_attachment])
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

  def event_dates(struct) do
    case Cldr.Interval.to_string(struct.event_start, struct.event_ends, Rauversion.Cldr) do
      {:ok, d} ->
        d

      _ ->
        struct.event_start
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
end
