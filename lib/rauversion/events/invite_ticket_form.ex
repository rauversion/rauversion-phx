defmodule Rauversion.Events.InviteTicketForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :email, :string
    field :ticket_id, :id
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:email, :ticket_id])
    |> validate_required([:email, :ticket_id])
    |> validate_email()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
  end
end
