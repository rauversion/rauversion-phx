defmodule CountByDateQuery do
  import Ecto.Query

  @doc "to_char function for formatting datetime as dd MON YYYY"
  defmacro to_char(field, format) do
    quote do
      fragment("to_char(?, ?)", unquote(field), unquote(format))
    end
  end

  @doc "Builds a query with row counts per inserted_at date"
  def row_counts_by_date(model \\ Rauversion.Events.Event) do
    from record in model,
      group_by: to_char(record.inserted_at, "dd Mon YYYY"),
      select: {to_char(record.inserted_at, "dd Mon YYYY"), count(record.id)}
  end

  @doc "Builds a query with row counts per inserted_at date"
  def row_counts_by_month(model \\ Rauversion.Events.Event) do
    from record in model,
      group_by: to_char(record.inserted_at, "Mon YYYY"),
      select: {to_char(record.inserted_at, "Mon YYYY"), count(record.id)}
  end

  @doc "Builds a query with row counts per inserted_at date"
  def row_counts_by_day(model \\ Rauversion.Events.Event) do
    from record in model,
      group_by: to_char(record.inserted_at, "dd Mon"),
      select: {to_char(record.inserted_at, "dd Mon"), count(record.id)}
  end
end
