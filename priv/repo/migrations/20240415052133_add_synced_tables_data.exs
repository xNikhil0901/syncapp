defmodule Syncapp.Repo.Migrations.AddSyncedTablesData do
  use Ecto.Migration

  @tables_to_sync ~w(test cities)s
  @time_in_hours 24
  @time Application.fetch_env!(:syncapp, :startup_time)
  @users [1, 4, 67, 89]

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
    Enum.flat_map(@users, fn user ->
      Enum.map(@tables_to_sync, fn table ->
        %{
          table_name: table,
          table_fields: build_data(table),
          last_synced_datetime: @time,
          user_id: user
        }
      end)
    end)
  end

  defp build_data(table) do
    str = Syncapp.Tables.Info.get_columns(table) |> Enum.join(" ")

    "~w(" <> str <> ")a"
  end

  defp get_datetime do
    NaiveDateTime.local_now() |> NaiveDateTime.add(-@time_in_hours, :hour)
  end
end
