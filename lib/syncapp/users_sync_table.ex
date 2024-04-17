defmodule Syncapp.UsersSyncTable do
  @moduledoc """
  The UsersSyncTable context.
  """

  import Ecto.Query, warn: false
  alias Syncapp.Repo
  alias Syncapp.SyncedTables.SyncTable
  alias Syncapp.UsersSyncTable.UserSyncTable

  @doc """
  Returns the list of users_sync_table.
  """
  def list_users_sync_table do
    Repo.all(UserSyncTable)
  end

  @doc """
  Returns sync information of a user for a specific table.
  """
  def get_synced_tables_info(table, user_id) do
    query =
      from us in UserSyncTable,
        join: t in SyncTable,
        on: t.sync_table_id == us.sync_table_id,
        where: t.table_name == ^table and us.user_id == ^user_id

    Repo.one(query)
  end

  @doc """
  Creates a user_sync_table.
  """
  def create_user_sync_table(attrs \\ %{}) do
    %UserSyncTable{}
    |> UserSyncTable.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_sync_table.
  """
  def update_user_sync_table(table_name, user_id) do
    result = get_synced_tables_info(table_name, user_id)

    changes =
      Ecto.Changeset.change(result, %{last_synced_datetime: NaiveDateTime.local_now()})

    Repo.update(changes)
  end
end
