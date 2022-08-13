defmodule Rauversion.PreviewCards do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rauversion.Repo

  schema "preview_cards" do
    field :author_name, :string
    field :author_url, :string
    field :description, :string
    field :html, :string
    field :title, :string
    field :type, :string
    field :url, :string
    field :image, :string
    timestamps()
  end

  @doc false
  def changeset(preview_cards, attrs) do
    preview_cards
    # |> Ecto.Changeset.unique_constraint(:url)
    |> cast(attrs, [
      :url,
      :title,
      :description,
      # :type,
      :author_name,
      :author_url,
      :html,
      :image
    ])
    |> validate_required([:url])
  end

  def find_by_url(url) do
    Repo.get_by(Rauversion.PreviewCards, url: url)
  end

  def find_or_create(attrs \\ %{}) do
    Repo.get_by(Rauversion.PreviewCards, url: attrs.url) ||
      create(attrs)
  end

  def create(attrs \\ %{}) do
    IO.inspect(attrs)

    %Rauversion.PreviewCards{}
    |> changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, card} -> card
      {:error, _} -> Repo.get_by!(Rauversion.PreviewCards, url: attrs.url)
    end
  end

  def images(struct) do
    # image_url = image.attached? ? url_for(image) : nil
    # [{ url: image_url }]
    [%{url: struct.image}]
  end

  def provider_url(struct) do
    case URI.parse(struct.url) do
      %{host: host} -> host
      _ -> nil
    end
  end

  def media(struct) do
    %{html: struct.html}
  end

  def as_oembed_json(struct, opts \\ {}) do
    %{
      url: struct.url,
      title: struct.title,
      description: struct.description,
      html: struct.html,
      provider_url: provider_url(struct),
      media: media(struct),
      images: images(struct)
    }
  end
end
