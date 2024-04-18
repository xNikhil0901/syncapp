defmodule Syncapp.SyncedTables do
  @moduledoc """
  The SyncedTables context.
  """

  import Ecto.Query, warn: false
  alias Syncapp.Repo

  alias Syncapp.SyncedTables.SyncTable

  @doc """
  Returns the list of synced_tables.
  """
  def list_synced_tables do
    Repo.all(SyncTable)
  end

  def get_last_synced_by_table(table_name) do
    SyncTable
    |> where([st], st.table_name == ^table_name)
    |> select([st], st.last_synced_datetime)
    |> Repo.one()
  end

  @doc """
  Creates a sync_table.
  """
  def create_sync_table(attrs \\ %{}) do
    %SyncTable{}
    |> SyncTable.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sync_table.
  """
  def update_sync_table(attrs) do
    result =
      SyncTable
      |> where([st], st.table_name == ^attrs["table_name"] and st.user_id == ^attrs["user_id"])
      |> Repo.one!()

    changes = Ecto.Changeset.change(result, %{last_synced_datetime: NaiveDateTime.local_now()})

    Repo.update(changes)
  end
end
