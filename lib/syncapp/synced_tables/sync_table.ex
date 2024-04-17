defmodule Syncapp.SyncedTables.SyncTable do
  use Ecto.Schema
  import Ecto.Changeset

  schema "synced_tables" do
    field :table_name, :string
    field :table_fields, :string
    field :user_id, :integer
    field :last_synced_datetime, :naive_datetime
  end

  @doc false
  def changeset(sync_table, attrs) do
    sync_table
    |> cast(attrs, [:table_name, :table_fields, :user_id, :last_synced_datetime])
    |> validate_required([:table_name])
  end
end
