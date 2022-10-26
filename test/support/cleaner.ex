case Code.ensure_loaded(Ecto) do
  {:module, _} ->
    defmodule Surgex.DatabaseCleaner do
      @moduledoc """
      This code was extracted from https://github.com/surgeventures/surgex/blob/master/lib/surgex/database_cleaner/database_cleaner.ex
      Cleans tables in a database represented by an Ecto repo.
      ## Usage
      Here's a basic example:
          Surgex.DatabaseCleaner.call(MyProject.Repo)
          Surgex.DatabaseCleaner.call(MyProject.Repo, method: :delete_all)
          Surgex.DatabaseCleaner.call(MyProject.Repo, only: ~w(posts users))
          Surgex.DatabaseCleaner.call(MyProject.Repo, only: [Post, User])
          Surgex.DatabaseCleaner.call(MyProject.Repo, except: [Project])
      This module may come in handy as a tool for configuring integration tests. You may use it globally
      if you want to clean before all tests as following:
          setup do
            :ok = Ecto.Adapters.SQL.Sandbox.checkout(MyProject.Repo)
            # ...
            Surgex.DatabaseCleaner.call(MyProject.Repo)
            :ok
          end
      Also, in order not to ruin test performance and the general experience of the Ecto sandbox, you
      may want to clean repo only after those tests that are tagged not to run in the sandbox. It can be
      achieved via the following `on_exit` callback:
          setup do
            if tags[:sandbox] == false do
              :ok = Ecto.Adapters.SQL.Sandbox.checkout(MyProject.Repo, sandbox: false)
              on_exit(fn ->
                :ok = Ecto.Adapters.SQL.Sandbox.checkout(MyProject.Repo, sandbox: false)
                Surgex.DatabaseCleaner.call(MyProject.Repo)
              end)
            else
              # ...
            end
            :ok
          end
      """

      @doc """
      Cleans selected or all tables in given repo using specified method.
      ## Options
      - `method`: one of `:truncate` (default), `:delete_all`
      - `only`: cleans specified tables/schemas (defaults to all tables)
      - `except`: cleans all tables/schemas except specified ones
      """
      def call(repo, opts \\ []) do
        method = Keyword.get(opts, :method, :truncate)
        only = Keyword.get(opts, :only)
        except = Keyword.get(opts, :except)

        repo
        |> get_all_tables(only)
        |> filter_tables(except)
        |> clean_tables(repo, method)

        :ok
      end

      defp get_all_tables(repo, nil) do
        import Ecto.Query

        query =
          from(
            t in "tables",
            where: t.table_schema == "public" and t.table_type == "BASE TABLE",
            select: t.table_name
          )

        prefixed_query = Map.put(query, :prefix, "information_schema")

        repo
        |> apply(:all, [prefixed_query])
        |> List.delete("schema_migrations")
        |> Enum.map(&get_table_name/1)
      end

      defp get_all_tables(_repo, tables), do: Enum.map(tables, &get_table_name/1)

      defp filter_tables(all_tables, nil), do: all_tables

      defp filter_tables(all_tables, except),
        do: all_tables -- Enum.map(except, &get_table_name/1)

      defp get_table_name(name) when is_binary(name), do: name

      defp get_table_name(schema) do
        schema.__schema__(:source)
      end

      defp clean_tables(tables, repo, :delete_all) do
        Enum.each(tables, fn table ->
          apply(repo, :delete_all, [table])
        end)
      end

      defp clean_tables(tables, repo, :truncate) do
        Enum.each(tables, fn table ->
          sql = "TRUNCATE TABLE #{table} RESTART IDENTITY CASCADE"

          apply(repo, :query!, [sql, []])
        end)
      end
    end

  _ ->
    nil
end
