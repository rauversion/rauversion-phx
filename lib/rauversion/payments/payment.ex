defmodule Rauversion.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :price, :decimal
    field :include_message, :boolean
    field :optional_message, :string
    field :initial_price, :decimal
  end

  @required_fields []
  @optional_fields [
    :include_message,
    :optional_message,
    :initial_price,
    :price
  ]

  def change(%__MODULE__{} = payment, attrs) do
    payment
    |> __MODULE__.changeset(attrs)
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_pricing_bounds()
    |> optional_required()
  end

  def optional_required(changeset) do
    if get_field(changeset, :include_message) do
      val = get_field(changeset, :optional_message)

      if is_nil(val) || String.trim(val) == "" do
        add_error(changeset, :optional_message, "empty message")
      else
        changeset
      end
    else
      changeset
    end
  end

  # when is_atom(field) do
  def validate_pricing_bounds(changeset) do
    validate_change(changeset, :price, fn _f, count ->
      max = get_field(changeset, :initial_price)

      formatted = Number.Currency.number_to_currency(max, precision: 2)

      cond do
        count.coef < max.coef && count.coef != 0 ->
          [{:price, "Min Price should be #{formatted}"}]

        true ->
          []
      end
    end)
  end
end
