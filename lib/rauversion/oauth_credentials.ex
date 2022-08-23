defmodule Rauversion.OauthCredentials do
  @moduledoc """
  The OauthCredentials context.
  """

  import Ecto.Query, warn: false
  alias Rauversion.Repo

  alias Rauversion.OauthCredentials.OauthCredential

  @doc """
  Returns the list of oauth_credentials.

  ## Examples

      iex> list_oauth_credentials()
      [%OauthCredential{}, ...]

  """
  def list_oauth_credentials do
    Repo.all(OauthCredential)
  end

  @doc """
  Gets a single oauth_credential.

  Raises `Ecto.NoResultsError` if the Oauth credential does not exist.

  ## Examples

      iex> get_oauth_credential!(123)
      %OauthCredential{}

      iex> get_oauth_credential!(456)
      ** (Ecto.NoResultsError)

  """
  def get_oauth_credential!(id), do: Repo.get!(OauthCredential, id)
  def get_oauth_credential_by_uid!(id), do: Repo.get_by(OauthCredential, %{uid: id})

  @doc """
  Creates a oauth_credential.

  ## Examples

      iex> create_oauth_credential(%{field: value})
      {:ok, %OauthCredential{}}

      iex> create_oauth_credential(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_oauth_credential(attrs \\ %{}) do
    %OauthCredential{}
    |> OauthCredential.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a oauth_credential.

  ## Examples

      iex> update_oauth_credential(oauth_credential, %{field: new_value})
      {:ok, %OauthCredential{}}

      iex> update_oauth_credential(oauth_credential, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_oauth_credential(%OauthCredential{} = oauth_credential, attrs) do
    oauth_credential
    |> OauthCredential.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a oauth_credential.

  ## Examples

      iex> delete_oauth_credential(oauth_credential)
      {:ok, %OauthCredential{}}

      iex> delete_oauth_credential(oauth_credential)
      {:error, %Ecto.Changeset{}}

  """
  def delete_oauth_credential(%OauthCredential{} = oauth_credential) do
    Repo.delete(oauth_credential)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking oauth_credential changes.

  ## Examples

      iex> change_oauth_credential(oauth_credential)
      %Ecto.Changeset{data: %OauthCredential{}}

  """
  def change_oauth_credential(%OauthCredential{} = oauth_credential, attrs \\ %{}) do
    OauthCredential.changeset(oauth_credential, attrs)
  end
end
