defmodule Rauversion.Accounts.Settings do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :pst_enabled, :boolean
    field :tbk_commerce_code, :string
    field :tbk_test_mode, :boolean
  end

  @required_fields []
  @optional_fields [
    :pst_enabled,
    :tbk_commerce_code,
    :tbk_test_mode
  ]

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
