defmodule Syncapp.Repo.Migrations.AddSyncedTablesData do
  use Ecto.Migration

  def change do
    seed()
  end

  defp seed do
    Syncapp.Repo.insert_all(Syncapp.SyncedTables.SyncTable, default_data())
  end

  defp default_data do
    [
      %{table_name: "users", last_synced_datetime: NaiveDateTime.local_now()},
      %{table_name: "employees", last_synced_datetime: NaiveDateTime.local_now()}
    ]
  end
end
