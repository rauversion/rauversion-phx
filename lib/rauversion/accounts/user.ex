defmodule Rauversion.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  use ActiveStorage.Attached.Model
  use ActiveStorage.Attached.HasOne, name: :avatar, model: "User"

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true
    field :confirmed_at, :naive_datetime
    field :country, :string
    field :city, :string
    field :bio, :string

    embeds_one :notification_settings, Rauversion.Accounts.NotificationSettings,
      on_replace: :update

    # field :settings
    has_many :articles, Rauversion.Posts.Post, on_delete: :nilify_all

    has_many :track_comments, Rauversion.TrackComments.TrackComment
    has_many :tracks, Rauversion.Tracks.Track, on_delete: :delete_all
    has_many :playlists, Rauversion.Playlists.Playlist, on_delete: :delete_all

    has_many :followings, Rauversion.UserFollows.UserFollow,
      foreign_key: :following_id,
      on_delete: :delete_all

    has_many :followers, Rauversion.UserFollows.UserFollow,
      foreign_key: :follower_id,
      on_delete: :delete_all

    has_many :liked_playlists, Rauversion.PlaylistLikes.PlaylistLike, on_delete: :delete_all

    has_many :liked_tracks, Rauversion.TrackLikes.TrackLike, on_delete: :delete_all
    has_many :reposted_tracks, Rauversion.Reposts.Repost, on_delete: :delete_all

    has_one(:avatar_attachment, ActiveStorage.Attachment,
      where: [record_type: "User", name: "avatar"],
      foreign_key: :record_id
    )

    has_one(:avatar_blob, through: [:avatar_attachment, :blob])

    timestamps()
  end

  def record_type() do
    "User"
  end

  def profile_changeset(user, attrs, _opts \\ []) do
    user
    |> validate_contact_fields(attrs)
    |> process_avatar(attrs)
  end

  def notifications_changeset(user, attrs, _opts \\ []) do
    user
    |> cast(attrs, [:username, :first_name, :last_name, :country, :bio, :city])
    |> cast_embed(:notification_settings,
      with: &Rauversion.Accounts.NotificationSettings.changeset/2
    )
  end

  def changeset(user, attrs, opts \\ []) do
    user
    |> validate_contact_fields(attrs)
    |> registration_changeset(attrs, opts)
  end

  def process_avatar(user, attrs) do
    case attrs do
      %{"avatar" => _avatar = nil} ->
        user

      %{"avatar" => _avatar} ->
        blob =
          ActiveStorage.Blob.create_and_upload!(
            %ActiveStorage.Blob{},
            io: {:path, attrs["avatar"].path},
            filename: attrs["avatar"].filename,
            content_type: attrs["avatar"].content_type,
            identify: true
          )

        avatar = user.data.__struct__.avatar(user.data)
        avatar.__struct__.attach(avatar, blob)

        user

      _ ->
        user
    end
  end

  @doc """
  A user changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email, :password, :username])
    |> validate_required([:username])
    |> validate_email()
    |> validate_password(opts)
    |> unique_constraint(:username)
  end

  defp validate_contact_fields(changeset, attrs) do
    changeset
    |> cast(attrs, [:username, :first_name, :last_name, :country, :bio, :city])
    |> validate_required([:username, :first_name, :last_name])
    |> unsafe_validate_unique(:username, Rauversion.Repo)
    |> unique_constraint(:username)
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, Rauversion.Repo)
    |> unique_constraint(:email)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 72)
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # If using Bcrypt, then further validate it is at most 72 bytes long
      |> validate_length(:password, max: 72, count: :bytes)
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  @doc """
  A user changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  def email_changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_email()
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  @doc """
  A user changeset for changing the password.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password(opts)
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(user, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%Rauversion.Accounts.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end
end
