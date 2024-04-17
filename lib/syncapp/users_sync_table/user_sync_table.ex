defmodule Syncapp.UsersSyncTable.UserSyncTable do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:users_sync_table_id, :id, autogenerate: true}
  schema "users_sync_table" do
    field :user_id, :integer
    field :last_synced_datetime, :naive_datetime
    field :sync_table_id, :integer
  end

  @doc false
  def changeset(user_sync_table, attrs) do
    user_sync_table
    |> cast(attrs, [:users_sync_table_id, :user_id, :last_synced_datetime, :sync_table_id])
    |> validate_required([:user_id, :last_synced_datetime, :sync_table_id])
  end
end
