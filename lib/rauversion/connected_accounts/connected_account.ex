defmodule Rauversion.ConnectedAccounts.ConnectedAccount do
  use Ecto.Schema
  import Ecto.Changeset

  schema "connected_accounts" do
    field :state, :string
    # field :parent_id, :id
    # field :user_id, :id

    belongs_to :inviter, Rauversion.Accounts.User, foreign_key: :parent_id
    belongs_to :user, Rauversion.Accounts.User, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(connected_account, attrs) do
    connected_account
    |> cast(attrs, [:state, :parent_id, :user_id])
    |> validate_required([:state])
  end
end
