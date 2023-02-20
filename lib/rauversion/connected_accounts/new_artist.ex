defmodule Rauversion.ConnectedAccounts.NewArtist do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :username, :string
    field :genre, :string
    field :hidden, :string
  end

  # Artist name
  # Location
  # e.g. Seattle, WA
  # Genre
  # select one
  # Your genre selection determines where your music appears in Bandcamp Discover. It’s OK if you don’t fit perfectly within one of these – just use the genre tag field, below, to provide more granularity.

  # Genre tags
  # URL http://
  # .com
  # You can point your own URL/custom domain here later.

  # Hide artist
  # You can hide and unhide artists later, too.
  # Photo

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:username, :genre, :hidden])
    |> validate_required([:username])

    # |> validate_email()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
  end
end
