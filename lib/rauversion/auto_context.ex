defmodule Rauversion.AutoContext do
  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      import Ecto.Query, warn: false
      alias Rauversion.Repo

      def list do
        Repo.all(unquote(opts))
      end

      def get!(id), do: Repo.get!(unquote(opts), id)

      def create(attrs \\ %{}) do
        %unquote(opts){}
        |> unquote(opts).changeset(attrs)
        |> Repo.insert()
      end

      def update(%unquote(opts){} = connected_account, attrs) do
        connected_account
        |> unquote(opts).changeset(attrs)
        |> Repo.update()
      end

      def delete(%unquote(opts){} = connected_account) do
        Repo.delete(connected_account)
      end

      def change(
            %unquote(opts){} = connected_account,
            attrs \\ %{}
          ) do
        unquote(opts).changeset(connected_account, attrs)
      end

      defoverridable list: 0, get!: 1, create: 1, update: 2, delete: 1, change: 1
    end
  end
end
