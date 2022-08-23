defmodule Rauversion.OauthCredentials.OauthCredential do
  use Ecto.Schema
  import Ecto.Changeset

  schema "oauth_credentials" do
    embeds_one :data, Rauversion.OauthCredentials.OauthCredentialData, on_replace: :update

    field :token, :string
    field :uid, :string
    field :provider, :string
    belongs_to :user, Rauversion.Accounts.User
    timestamps()
  end

  @doc false
  def changeset(oauth_credential, attrs) do
    oauth_credential
    |> cast(attrs, [:uid, :token, :user_id, :provider])
    |> cast_embed(:data, with: &Rauversion.OauthCredentials.OauthCredentialData.changeset/2)
    |> validate_required([:uid, :token, :user_id, :provider])
    |> unsafe_validate_unique([:uid, :provider], Rauversion.Repo)
    |> foreign_key_constraint(:user_id)
  end
end

defmodule Rauversion.OauthCredentials.OauthCredentialData do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :token, :string
    field :refresh_token, :string
    field :expires, :boolean
    field :expires_at, :integer
    field :scopes, {:array, :string}
    field :secret, :string
    field :token_type, :string
  end

  @required_fields [:token]
  @optional_fields [
    :refresh_token,
    :expires,
    :expires_at,
    :scopes,
    :secret,
    :token_type
  ]

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
