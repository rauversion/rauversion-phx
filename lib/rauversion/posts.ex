defmodule Rauversion.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias Rauversion.Repo

  alias Rauversion.Posts.Post

  @doc """
  Returns the list of post.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """

  def all_posts do
    Repo.all(Post)
  end

  def list_posts(state) when is_binary(state) do
    from(pi in Post,
      where: pi.state == ^state,
      preload: [:category, user: :avatar_blob]
    )

    # |> Repo.all()
  end

  def list_posts(state) when is_nil(state) do
    from(pi in Post,
      preload: [:category, user: :avatar_blob]
    )
  end

  def list_posts(query, state) when is_nil(state) do
    query
    |> preload([:category, user: :avatar_blob])
  end

  def list_posts(query, state) do
    query
    |> where([p], p.state == ^state)
    |> preload([:category, user: :avatar_blob])
  end

  def with_category(query, category) do
    query
    |> where([c], c.category_id == ^category.id)
  end

  def order(query) do
    query |> order_by([p], desc: p.inserted_at)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  def get_post_by_slug!(id), do: Repo.get_by!(Post, slug: id)

  def new_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Post.process_cover(attrs)
    |> Repo.update()
  end

  def update_post_attributes(%Post{} = post, attrs) do
    post
    |> Post.update_changeset(attrs)
    |> Post.process_cover(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  def date(date, format \\ :short) do
    case Cldr.DateTime.to_string(
           date,
           Rauversion.Cldr,
           format: format
         ) do
      {:ok, d} -> d
      _ -> date
    end
  end

  def proxy_cover_representation_url(struct, options \\ %{resize_to_fill: "250x250"}) do
    Rauversion.BlobUtils.blob_representation_proxy_url(struct, "cover", options)
  end

  defdelegate blob_url(user, kind), to: Rauversion.BlobUtils

  defdelegate blob_for(track, kind), to: Rauversion.BlobUtils

  defdelegate blob_proxy_url(user, kind), to: Rauversion.BlobUtils

  defdelegate variant_url(track, kind, options), to: Rauversion.BlobUtils

  defdelegate blob_url_for(track, kind), to: Rauversion.BlobUtils
end
