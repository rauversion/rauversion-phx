defmodule Rauversion.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :map
    field :excerpt, :string
    field :slug, :string
    field :state, :string
    field :title, :string
    # field :user_id, :id
    field :private, :string
    field :settings, :map

    belongs_to :user, Rauversion.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :excerpt, :slug, :state, :user_id])
    |> validate_required([:body])
  end

  def update_changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :excerpt, :slug, :state])
    |> validate_required([:title, :body, :excerpt, :slug, :state])
  end
end
