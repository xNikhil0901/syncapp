defmodule Syncapp.Repo.Migrations.CreateSyncedTables do
  use Ecto.Migration

  def up do
    create table(:synced_tables, primary_key: false) do
      add :sync_table_id, :serial, primary_key: true
      add :table_name, :string
      add :table_fields, :string
    end
  end

  def down do
    execute "DROP TABLE IF EXISTS synced_tables"
  end
end
