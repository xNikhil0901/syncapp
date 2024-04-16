defmodule Syncapp.Repo.Migrations.CreateSyncedTables do
  use Ecto.Migration

  def up do
    create table(:synced_tables) do
      add :table_name, :string
      add :table_fields, :string
      add :last_synced_datetime, :naive_datetime, null: false
    end

    create(unique_index(:synced_tables, :table_name))
  end

  def down do
    execute "DROP TABLE IF EXISTS synced_tables"
  end
end
