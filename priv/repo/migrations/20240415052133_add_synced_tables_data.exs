defmodule Syncapp.Repo.Migrations.AddSyncedTablesData do
  use Ecto.Migration

  @tables_to_sync ~w(test cities)s

  def up do
    seed()
  end

  def down do
    execute "DROP TABLE IF EXISTS synced_tables"
  end

  defp seed do
    Syncapp.Repo.insert_all(Syncapp.SyncedTables.SyncTable, default_data())
  end

  defp default_data do
    Enum.map(@tables_to_sync, fn table ->
      %{
        table_name: table,
        table_fields: build_data(table)
      }
    end)
  end

  defp build_data(table) do
    str = Syncapp.Tables.Info.get_columns(table) |> Enum.join(" ")

    "~w(" <> str <> ")a"
  end
end
