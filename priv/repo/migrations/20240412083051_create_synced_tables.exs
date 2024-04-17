defmodule Syncapp.Repo.Migrations.CreateSyncedTables do
  use Ecto.Migration

  def up do
    create table(:synced_tables) do
      add :table_name, :string
      add :table_fields, :string
      add :user_id, :bigint
      add :last_synced_datetime, :naive_datetime
    end
  end

  def down do
    execute "DROP TABLE IF EXISTS synced_tables"
  end
end
