defmodule Rauversion.Posts.Post.TitleSlug do
  use EctoAutoslugField.Slug, from: :title, to: :slug
end

defmodule Rauversion.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rauversion.Posts.Post.TitleSlug

  use ActiveStorage.Attached.Model
  use ActiveStorage.Attached.HasOne, name: :cover, model: "Post"

  schema "posts" do
    field :body, :map
    field :excerpt, :string
    field :slug, :string
    field :state, :string, default: "draft"
    field :title, TitleSlug.Type

    # field :user_id, :id
    field :private, :boolean, default: true
    field :settings, :map

    belongs_to :user, Rauversion.Accounts.User
    belongs_to :category, Rauversion.Categories.Category

    has_one(:cover_attachment, ActiveStorage.Attachment,
      where: [record_type: "Post", name: "cover"],
      foreign_key: :record_id
    )

    has_one(:cover_blob, through: [:cover_attachment, :blob])

    timestamps()
  end

  use Fsmx.Struct,
    transitions: %{
      "draft" => ["published"],
      "published" => ["draft"]
    }

  def record_type() do
    "Post"
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :excerpt, :private, :slug, :state, :user_id, :category_id])
    |> validate_required([:body])
  end

  def update_changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :excerpt, :slug, :state, :category_id])
    |> validate_required([:title, :body, :excerpt])
    |> TitleSlug.maybe_generate_slug()
    |> TitleSlug.unique_constraint()
  end

  def process_cover(struct, attrs) do
    case attrs do
      %{"cover" => _cover = nil} ->
        struct

      %{"cover" => _cover} ->
        blob =
          ActiveStorage.Blob.create_and_upload!(
            %ActiveStorage.Blob{},
            io: {:path, attrs["cover"].path},
            filename: attrs["cover"].filename,
            content_type: attrs["cover"].content_type,
            identify: true
          )

        cover = struct.data.__struct__.cover(struct.data)
        cover.__struct__.attach(cover, blob)

        struct

      _ ->
        struct
    end
  end
end
