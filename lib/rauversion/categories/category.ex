defmodule Rauversion.Categories.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :category, :string
    field :name, :string
    field :slug, :string

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:category, :name, :slug])
    |> validate_required([:category, :name, :slug])
  end
end
