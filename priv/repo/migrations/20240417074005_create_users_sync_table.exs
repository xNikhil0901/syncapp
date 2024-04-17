defmodule Syncapp.Repo.Migrations.CreateUsersSyncTable do
  use Ecto.Migration

  def up do
    create table(:users_sync_table, primary_key: false) do
      add :users_sync_table_id, :bigserial, primary_key: true
      add :user_id, :bigint
      add :last_synced_datetime, :naive_datetime, default: nil
      add :sync_table_id, :integer
    end

    alter table(:users_sync_table) do
      modify(
        :sync_table_id,
        references(:synced_tables, name: :sync_table_id, column: :sync_table_id)
      )
    end
  end

  def down do
    execute "DROP TABLE users_sync_table CASCADE"
  end
end
