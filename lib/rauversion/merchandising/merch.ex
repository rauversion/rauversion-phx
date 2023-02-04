defmodule Rauversion.Merchandising.Merch do
  use Ecto.Schema
  import Ecto.Changeset

  schema "merchs" do
    field :description, :string
    field :options, :map
    field :pricing, :decimal
    field :private, :boolean, default: false
    field :qty, :integer
    field :shipping_data, :map
    field :title, :string
    field :user_id, :id
    field :album_id, :id
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(merch, attrs) do
    merch
    |> cast(attrs, [:title, :description, :pricing, :shipping_data, :qty, :private, :options])
    |> validate_required([
      :title,
      :description,
      :pricing,
      :shipping_data,
      :qty,
      :private,
      :options
    ])
  end
end
