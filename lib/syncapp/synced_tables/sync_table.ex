defmodule Syncapp.SyncedTables.SyncTable do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:sync_table_id, :id, autogenerate: true}
  schema "synced_tables" do
    field :table_name, :string
    field :table_fields, :string

    has_many(:user_sync_table, Syncapp.UsersSyncTable.UserSyncTable,
      foreign_key: :sync_table_id,
      references: :sync_table_id
    )
  end

  @doc false
  def changeset(sync_table, attrs) do
    sync_table
    |> cast(attrs, [:table_name, :table_fields])
    |> validate_required([:table_name])
  end
end
