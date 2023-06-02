defmodule Rauversion.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Rauversion.Repo

  alias Rauversion.Accounts.{User, UserToken, UserNotifier}

  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(Rauversion.PubSub, @topic)
  end

  def broadcast_change({:ok, result}, event) do
    Phoenix.PubSub.broadcast(Rauversion.PubSub, @topic, {__MODULE__, event, result})
    {:ok, result}
  end

  def broadcast_change({:error, result}, _event) do
    {:error, result}
  end

  def list_accounts(limit \\ 20) do
    User |> limit(^limit) |> Repo.all()
  end

  def tracks_count(user) do
    user
    |> Ecto.assoc(:tracks)
    |> Repo.aggregate(:count, :id)
  end

  def unfollowed_users(user) do
    from(u in User,
      left_join: m in assoc(u, :followings),
      on: [follower_id: ^user.id],
      where: not is_nil(u.username),
      where: u.type == "user",
      where: is_nil(m.id),
      preload: [:avatar_blob, :avatar_attachment]
    )
  end

  def unfollowed_artists(user) do
    from(u in User,
      left_join: m in assoc(u, :followings),
      on: [follower_id: ^user.id],
      where: not is_nil(u.username),
      where: u.type == "artist",
      where: is_nil(m.id),
      preload: [:avatar_blob, :avatar_attachment]
    )
  end

  def unfollowed_artists() do
    unfollowed_users(nil)
    |> artists()
  end

  def latests(query) do
    query |> order_by([c], desc: c.id)
  end

  def artists(query) do
    query
    |> where(type: ^"artist")
    |> where([u], not is_nil(u.username))
  end

  def search_by_username(query, term) do
    query |> where([u], like(u.username, ^"#{term}%"))
  end

  def artists() do
    from(u in User,
      where: [type: ^"artist"],
      preload: [:avatar_blob, :avatar_attachment]
    )
    |> where([u], not is_nil(u.username))
  end

  ## Database getters

  @doc """
  Gets a user by email.

  ## Examples

      iex> get_user_by_email("foo@example.com")
      %User{}

      iex> get_user_by_email("unknown@example.com")
      nil

  """
  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Gets a user by username.

  ## Examples

      iex> get_user_by_username("foo@example.com")
      %User{}

      iex> get_user_by_username("unknown@example.com")
      nil

  """
  def get_user_by_username(username) when is_binary(username) do
    Repo.get_by(User, username: username)
  end

  @doc """
  Gets a user by email and password.

  ## Examples

      iex> get_user_by_email_and_password("foo@example.com", "correct_password")
      %User{}

      iex> get_user_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = Repo.get_by(User, email: email)
    if User.valid_password?(user, password), do: user
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def not_in(query, id) do
    query
    |> where([u], u.id != ^id)
  end

  ## User registration

  @doc """
  Registers a user.

  ## Examples

      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user_registration(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_registration(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs, hash_password: false)
  end

  ## Settings

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user email.

  ## Examples

      iex> change_user_email(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_email(user, attrs \\ %{}) do
    User.email_changeset(user, attrs)
  end

  def change_user_profile(user, attrs \\ %{}) do
    User.profile_changeset(user, attrs)
  end

  def change_user_notifications(user, attrs \\ %{}) do
    User.notifications_changeset(user, attrs)
  end

  def update_user_profile(user, attrs \\ %{}) do
    User.profile_changeset(user, attrs)
    |> Repo.update()
  end

  def is_label?(user) do
    user.label
  end

  def update_label(user, attrs \\ %{}) do
    User.label_changeset(user, attrs)
    |> Repo.update()
  end

  def update_notifications(user, attrs \\ %{}) do
    User.notifications_changeset(user, attrs)
    |> Repo.update()
  end

  def update_transbank(user, attrs \\ %{}) do
    User.transbank_changeset(user, attrs)
    |> Repo.update()
  end

  def update_user_type(user, type) do
    User.type_changeset(user, %{type: type})
    |> Repo.update()
  end

  def avatar_url(profile, size) do
    case size do
      :medium ->
        Rauversion.BlobUtils.variant_url(profile, :avatar, %{resize_to_fill: "200x200"})

      :large ->
        Rauversion.BlobUtils.variant_url(profile, :avatar, %{resize_to_fill: "500x500"})

      :small ->
        Rauversion.BlobUtils.variant_url(profile, :avatar, %{resize_to_fill: "50x50"})

      _ ->
        Rauversion.BlobUtils.variant_url(profile, :avatar, %{resize_to_fill: "200x200"})
    end
  end

  def avatar_url(user) do
    # a = Rauversion.Accounts.get_user_by_username("michelson") |> Rauversion.Repo.preload(:avatar_blob)
    case user do
      nil ->
        Rauversion.BlobUtils.fallback_image("/images/sai-harish-kjNwiW4BjJE-unsplash-sqr.png")

      %{avatar_blob: nil} ->
        Rauversion.BlobUtils.fallback_image("/images/sai-harish-kjNwiW4BjJE-unsplash-sqr.png")

      %{avatar_blob: %ActiveStorage.Blob{} = avatar_blob} ->
        avatar_blob |> ActiveStorage.url()

      %{avatar_blob: %Ecto.Association.NotLoaded{}} ->
        user = user |> Rauversion.Repo.preload(:avatar_blob)
        Rauversion.Accounts.avatar_url(user)
    end
  end

  @doc """
  Emulates that the email will change without actually changing
  it in the database.

  ## Examples

      iex> apply_user_email(user, "valid password", %{email: ...})
      {:ok, %User{}}

      iex> apply_user_email(user, "invalid password", %{email: ...})
      {:error, %Ecto.Changeset{}}

  """
  def apply_user_email(user, password, attrs) do
    user
    |> User.email_changeset(attrs)
    |> User.validate_current_password(password)
    |> Ecto.Changeset.apply_action(:update)
  end

  @doc """
  Updates the user email using the given token.

  If the token matches, the user email is updated and the token is deleted.
  The confirmed_at date is also updated to the current time.
  """
  def update_user_email(user, token) do
    context = "change:#{user.email}"

    with {:ok, query} <- UserToken.verify_change_email_token_query(token, context),
         %UserToken{sent_to: email} <- Repo.one(query),
         {:ok, _} <- Repo.transaction(user_email_multi(user, email, context)) do
      :ok
    else
      _ -> :error
    end
  end

  defp user_email_multi(user, email, context) do
    changeset =
      user
      |> User.email_changeset(%{email: email})
      |> User.confirm_changeset()

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, [context]))
  end

  @doc """
  Delivers the update email instructions to the given user.

  ## Examples

      iex> deliver_update_email_instructions(user, current_email, &Routes.user_update_email_url(conn, :edit, &1))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_update_email_instructions(%User{} = user, current_email, update_email_url_fun)
      when is_function(update_email_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "change:#{current_email}")

    Repo.insert!(user_token)
    UserNotifier.deliver_update_email_instructions(user, update_email_url_fun.(encoded_token))
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user password.

  ## Examples

      iex> change_user_password(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_password(user, attrs \\ %{}) do
    User.password_changeset(user, attrs, hash_password: false)
  end

  @doc """
  Updates the user password.

  ## Examples

      iex> update_user_password(user, "valid password", %{password: ...})
      {:ok, %User{}}

      iex> update_user_password(user, "invalid password", %{password: ...})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_password(user, password, attrs) do
    changeset =
      user
      |> User.password_changeset(attrs)
      |> User.validate_current_password(password)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  @doc """
  Gets the user with the given signed token.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_session_token(token) do
    Repo.delete_all(UserToken.token_and_context_query(token, "session"))
    :ok
  end

  ## Confirmation

  @doc """
  Delivers the confirmation email instructions to the given user.

  ## Examples

      iex> deliver_user_confirmation_instructions(user, &Routes.user_confirmation_url(conn, :edit, &1))
      {:ok, %{to: ..., body: ...}}

      iex> deliver_user_confirmation_instructions(confirmed_user, &Routes.user_confirmation_url(conn, :edit, &1))
      {:error, :already_confirmed}

  """
  def deliver_user_confirmation_instructions(%User{} = user, confirmation_url_fun)
      when is_function(confirmation_url_fun, 1) do
    if user.confirmed_at do
      {:error, :already_confirmed}
    else
      {encoded_token, user_token} = UserToken.build_email_token(user, "confirm")
      Repo.insert!(user_token)
      UserNotifier.deliver_confirmation_instructions(user, confirmation_url_fun.(encoded_token))
    end
  end

  @doc """
  Confirms a user by the given token.

  If the token matches, the user account is marked as confirmed
  and the token is deleted.
  """
  def confirm_user(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "confirm"),
         %User{} = user <- Repo.one(query),
         {:ok, %{user: user}} <- Repo.transaction(confirm_user_multi(user)) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  defp confirm_user_multi(user) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.confirm_changeset(user))
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, ["confirm"]))
  end

  ## Reset password

  @doc """
  Delivers the reset password email to the given user.

  ## Examples

      iex> deliver_user_reset_password_instructions(user, &Routes.user_reset_password_url(conn, :edit, &1))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_user_reset_password_instructions(%User{} = user, reset_password_url_fun)
      when is_function(reset_password_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "reset_password")
    Repo.insert!(user_token)
    UserNotifier.deliver_reset_password_instructions(user, reset_password_url_fun.(encoded_token))
  end

  @doc """
  Gets the user by reset password token.

  ## Examples

      iex> get_user_by_reset_password_token("validtoken")
      %User{}

      iex> get_user_by_reset_password_token("invalidtoken")
      nil

  """
  def get_user_by_reset_password_token(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "reset_password"),
         %User{} = user <- Repo.one(query) do
      user
    else
      _ -> nil
    end
  end

  @doc """
  Resets the user password.

  ## Examples

      iex> reset_user_password(user, %{password: "new long password", password_confirmation: "new long password"})
      {:ok, %User{}}

      iex> reset_user_password(user, %{password: "valid", password_confirmation: "not the same"})
      {:error, %Ecto.Changeset{}}

  """
  def reset_user_password(user, attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.password_changeset(user, attrs))
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def find_by_credential_uid(uid) do
    Rauversion.OauthCredentials.get_oauth_credential_by_uid!(uid) |> Repo.preload(:user)
  end

  def find_by_credential_provider(provider, user_id) do
    Repo.get_by(Rauversion.OauthCredentials.OauthCredential, %{
      provider: provider,
      user_id: user_id
    })
  end

  def get_or_create_user(user_data) do
    # %{
    #  avatar: "https://lh3.googleusercontent.com/a-/AFdZucqqdrPKRYQdJKA2ClMex-anYYwHjRrihFERqtcvcw=s96-c",
    #  email: "miguelmichelson@gmail.com",
    #  id: "gakETMlISPCYrkeR6SlYHA",
    #  name: "miguel michelson"
    # }
    case find_by_credential_uid(user_data.id) do
      %Rauversion.OauthCredentials.OauthCredential{user: user} ->
        {:ok, %{user: user}}

      nil ->
        create_user_from_identity(user_data)
    end
  end

  def create_user_from_identity(user_data = %{email: _email = nil}) do
    {:error, %{user_data: user_data}}
  end

  def create_user_from_identity(user_data = %{email: email}) when is_binary(email) do
    [username, _] = email |> String.split("@")

    # returns user and data, in case user exists the attrs are empty
    user_changeset =
      case get_user_by_email(user_data.email) do
        %User{} = user ->
          Rauversion.Accounts.User.oauth_registration_update(user, %{})

        _ ->
          attrs = %{
            email: user_data.email,
            username: username || user_data.username,
            first_name: user_data.name || username,
            password: SecureRandom.urlsafe_base64(10)
          }

          Rauversion.Accounts.User.oauth_registration(%User{}, attrs)
      end

    Ecto.Multi.new()
    |> Ecto.Multi.insert_or_update(
      :user,
      user_changeset
    )
    |> Ecto.Multi.run(:credential, fn _repo, %{user: user} ->
      create_oauth_credential(user, user_data)
      |> Repo.insert()
    end)
    |> Repo.transaction()
  end

  def create_oauth_credential(user, user_data) do
    credentials_attrs = %{
      uid: user_data.id,
      token: user_data.credentials.token
    }

    Rauversion.OauthCredentials.change_oauth_credential(
      %Rauversion.OauthCredentials.OauthCredential{},
      credentials_attrs
      |> Map.merge(%{
        user_id: user.id,
        provider: to_string(user_data.provider),
        data: Map.from_struct(user_data.credentials)
      })
    )
  end

  def get_oauth_credential(user, provider) do
    user
    |> Ecto.assoc(:oauth_credentials)
    |> where([c], c.provider == ^provider)
    |> Repo.one()
  end

  def user_host_events(user) do
    from(p in Rauversion.Events.Event,
      join: c in assoc(p, :event_hosts),
      where: c.user_id == ^user.id,
      preload: [:user],
      select: p
    )
  end

  def find_managed_event(user, event_id) do
    user_host_events(user) |> where([c], c.slug == ^event_id)
  end

  # invitations

  def invite_artist(%User{} = user, attrs \\ %{}) do
    attrs = Map.merge(attrs, %{password: SecureRandom.urlsafe_base64(10), type: "artist"})

    User.invitation_changeset(user, attrs)
    |> Repo.insert()
  end

  def invite_user(%User{} = user, attrs \\ %{}) do
    attrs = Map.merge(attrs, %{password: SecureRandom.urlsafe_base64(10)})

    User.invitation_changeset(user, attrs)
    |> Repo.insert()
  end

  def use_invitation(%User{} = user) do
    from(u in User,
      where: u.id == ^user.id
    )
    |> Rauversion.Repo.update_all(inc: [invitations_count: -1])
  end

  def change_user_invitation(%User{} = user, attrs \\ %{}) do
    User.invitation_changeset(user, attrs)
  end

  def deliver_user_invitation_instructions(%User{} = user, invitation_url_fun)
      when is_function(invitation_url_fun, 1) do
    if user.confirmed_at do
      {:error, :already_confirmed}
    else
      {encoded_token, user_token} = UserToken.build_email_token(user, "invitation")
      Repo.insert!(user_token)
      UserNotifier.deliver_invitation_instructions(user, invitation_url_fun.(encoded_token))
    end
  end

  def fetch_user_from_invitation(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "invitation"),
         %User{} = user <- Repo.one(query) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  def accept_invitation(token, user_params) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "invitation"),
         %User{} = user <- Repo.one(query),
         {:ok, changeset} <- valid_invitation_changeset(user, user_params),
         {:ok, %{user: user}} <- Repo.transaction(accept_invitation_multi(user, changeset)) do
      {:ok, user}
    else
      {:error, %Ecto.Changeset{} = ch} -> {:error, ch}
      _ -> :error
    end
  end

  defp valid_invitation_changeset(user, params) do
    changeset = User.accept_invitation_changeset(user, params)

    case changeset.valid? do
      true -> {:ok, changeset}
      false -> {:error, changeset}
    end
  end

  defp accept_invitation_multi(user, user_update_changeset) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, user_update_changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, ["invitation"]))
  end

  # tickets

  def get_event_ticket(current_user = %Rauversion.Accounts.User{}, ticket) do
    ticket
    |> Ecto.assoc(:purchased_tickets)
    |> where([p], p.user_id == ^current_user.id)
    |> where([p], p.event_ticket_id == ^ticket.id)
    |> limit(1)
    |> Repo.one()
  end

  def get_event_ticket(_current_user = nil, _ticket) do
    nil
  end

  ### album orders

  def get_playlist!(user, id) do
    user |> Ecto.assoc(:playlists) |> Repo.get!(id)
  end

  def get_playlist_by_slug!(user, id) do
    user |> Ecto.assoc(:playlists) |> Repo.get_by(slug: id)
  end

  def track_orders_query(current_user) do
    id = current_user.id

    from(p in Rauversion.TrackPurchaseOrders.TrackPurchaseOrder,
      join: c in Rauversion.PurchaseOrders.PurchaseOrder,
      on: c.id == p.purchase_order_id and c.user_id == ^id
    )
    |> preload([:track, :purchase_order])
    |> order_by([c], desc: c.id)
  end

  def get_track_orders(current_user) do
    q = track_orders_query(current_user)

    query =
      from([p, c] in q,
        where: c.state == "paid" or c.state == "free_access"
      )

    query
    |> Repo.all()
  end

  def album_orders_query(current_user) do
    id = current_user.id

    from(p in Rauversion.AlbumPurchaseOrders.AlbumPurchaseOrder,
      join: c in Rauversion.PurchaseOrders.PurchaseOrder,
      on: c.id == p.purchase_order_id and c.user_id == ^id
    )
    |> preload([:playlist, :purchase_order])
    |> order_by([c], desc: c.id)
  end

  def get_album_orders(current_user) do
    q = album_orders_query(current_user)

    query =
      from([p, c] in q,
        where: c.state == "paid" or c.state == "free_access"
      )

    query
    |> Repo.all()
  end

  def get_pending_album_orders(current_user) do
    q = album_orders_query(current_user)

    query =
      from([p, c] in q,
        where: c.state == "pending"
      )

    query
    |> Repo.all()
  end

  # sales

  def get_sales(current_user, section) do
    case section do
      "all_music" -> albums_sales_for(current_user) |> Repo.all()
      "all_tracks" -> tracks_sales_for(current_user) |> Repo.all()
    end
  end

  def tracks_sales_for(current_user) do
    q =
      from(
        p in Rauversion.TrackPurchaseOrders.TrackPurchaseOrder,
        join: c in Rauversion.PurchaseOrders.PurchaseOrder,
        on: c.id == p.purchase_order_id,
        join: t in Rauversion.Tracks.Track,
        on: t.id == p.track_id and t.user_id == ^current_user.id
      )
      |> preload([:track, purchase_order: :user])
      |> order_by([c], desc: c.id)

    query =
      from([p, c] in q,
        where: c.state == "paid"
      )

    query
  end

  def albums_sales_for(current_user) do
    q =
      from(
        p in Rauversion.AlbumPurchaseOrders.AlbumPurchaseOrder,
        join: c in Rauversion.PurchaseOrders.PurchaseOrder,
        on: c.id == p.purchase_order_id,
        join: t in Rauversion.Playlists.Playlist,
        on: t.id == p.playlist_id and t.user_id == ^current_user.id
      )
      |> preload([:playlist, purchase_order: :user])
      |> order_by([c], desc: c.id)

    query =
      from([p, c] in q,
        where: c.state == "paid"
      )

    query
  end

  ### connected accounts

  def active_connected_accounts(user) do
    from(p in Rauversion.ConnectedAccounts.ConnectedAccount)
    |> where(parent_id: ^user.id)
    |> where(state: "active")
    |> Rauversion.Repo.all()
    |> Repo.preload(:user)
  end

  def is_child_of?(user, child_user_id) do
    from(p in Rauversion.ConnectedAccounts.ConnectedAccount)
    |> where(parent_id: ^user.id)
    |> where(state: "active")
    |> where([c], ^child_user_id == c.user_id)
    |> Rauversion.Repo.one()
  end
end
