defmodule Rauversion.PurchaseOrders.PurchaseOrder do
  use Ecto.Schema
  import Ecto.Changeset

  schema "purchase_orders" do
    field(:promo_code, :string)
    field(:total, :decimal)
    # field :data, :map
    field(:payment_id, :string)
    field(:payment_provider, :string)
    field(:state, :string, default: "pending")

    embeds_many(:data, Rauversion.PurchaseOrders.PurchaseOrderTickets, on_replace: :delete)
    belongs_to(:user, Rauversion.Accounts.User)

    many_to_many(:albums, Rauversion.Playlists.Playlist,
      join_through: Rauversion.AlbumPurchaseOrders.AlbumPurchaseOrder
    )

    many_to_many(:tracks, Rauversion.Tracks.Track,
      join_through: Rauversion.TrackPurchaseOrders.TrackPurchaseOrder
    )

    # TODO: associate purchase order tickets instead of embeds

    # polymorphic assocs
    # has_many :album_purchase_orders, Rauversion.AlbumPurchaseOrders.AlbumPurchaseOrder

    # has_many :purchased_albums,
    #  through: [:album_purchase_orders, :playlist]

    # has_many :track_purchase_orders, Rauversion.TrackPurchaseOrders.TrackPurchaseOrder
    # has_many :purchased_tracks,
    #  through: [:track_purchase_orders, :track]

    timestamps()
  end

  @doc false
  def changeset(purchase_order, attrs) do
    purchase_order
    |> cast(attrs, [:total, :promo_code, :user_id, :payment_id, :payment_provider, :state])
    |> cast_embed(:data, with: &Rauversion.PurchaseOrders.PurchaseOrderTickets.changeset/2)
    # |> put_assoc(:albums, required: false)
    # |> put_assoc(:tracks, required: false)
    |> load_albums_assoc(attrs)
    |> load_tracks_assoc(attrs)
    |> validate_required([:user_id])
    |> validate_event_tickets_qty()
  end

  def validate_event_tickets_qty(changeset) do
    changeset
    |> get_field(:data)
    |> Enum.filter(fn x -> x.count > 0 end)
    |> Enum.reduce(changeset, fn item, acc ->
      ticket =
        Rauversion.EventTickets.get_event_ticket!(item.ticket_id)
        |> Rauversion.Repo.preload(:event)

      a = Rauversion.Events.purchased_tickets(ticket.event, ticket.id) |> Rauversion.Repo.one()

      # IO.inspect("AAAAA #{a} #{ticket.qty}")

      case ticket.qty > a do
        true ->
          acc

        false ->
          add_error(
            acc,
            :not_valid,
            "The ticket: \"#{ticket.title}\", is sold out. Please choose a different ticket option"
          )
      end
    end)
  end

  defp load_albums_assoc(order, %{"albums" => albums} = _attrs) do
    # if Repo.exists?(from a in Author, where: a.name == ^attrs["authors"]) do
    #   authors = Repo.all(from a in Author, where: a.name == ^authors)
    #   order
    #   |> Ecto.Changeset.change()
    #   |> Ecto.Changeset.put_assoc(:authors, authors)
    # else
    #   {:ok, %Author{} = authors} = Repo.insert(%Author{name: authors}, returning: true)
    #   authors = Repo.all(from a in Author, where: a.id == ^authors.id)
    #   order
    #   |> Ecto.Changeset.change()
    #   |> Ecto.Changeset.put_assoc(:authors, authors)
    # end
    # Repo.insert_all("authors", [[name: authors, inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()]], on_conflict: :nothing)
    # authors = Repo.all(from a in Author, where: a.name == ^authors)

    order
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:albums, albums)
  end

  defp load_albums_assoc(order, _attrs) do
    order
  end

  defp load_tracks_assoc(order, %{"tracks" => tracks} = _attrs) do
    order
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:tracks, tracks)
  end

  defp load_tracks_assoc(order, _attrs) do
    order
  end
end

defmodule Rauversion.PurchaseOrders.PurchaseOrderTickets do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:ticket_id, :integer)
    field(:count, :integer)
  end

  @required_fields []
  @optional_fields [:ticket_id, :count]

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    # |> validate_number(:count, greater_than: 0)
    |> validate_is_ticket_count_bounds(:count)
  end

  # when is_atom(field) do
  def validate_is_ticket_count_bounds(changeset, field) do
    validate_change(changeset, field, fn _f, count ->
      ticket = Rauversion.EventTickets.get_event_ticket!(changeset.changes.ticket_id)

      max = ticket.settings.max_tickets_per_order
      min = ticket.settings.min_tickets_per_order

      cond do
        is_number(max) && count > max && count != 0 ->
          [{field, "max tickets"}]

        is_number(min) && count < min && count != 0 ->
          [{field, "min tickets"}]

        true ->
          []
      end

      # case String.starts_with?(url, @our_url) do
      #  true -> []
      #  false -> [{field, options[:message] || "Unexpected URL"}]
      # end
    end)
  end
end
