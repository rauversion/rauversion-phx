defmodule Rauversion.UserFollows.UserFollow do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_follows" do
    # field :follower_id, :id
    # field :following_id, :id

    belongs_to :follower, Rauversion.Accounts.User, foreign_key: :follower_id
    belongs_to :following, Rauversion.Accounts.User, foreign_key: :following_id

    timestamps()
  end

  @doc false
  def changeset(user_follow, attrs) do
    user_follow
    |> cast(attrs, [:follower_id, :following_id])
    |> validate_required([:follower_id, :following_id])
  end
end
