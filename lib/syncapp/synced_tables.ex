defmodule Syncapp.SyncedTables do
  @moduledoc """
  The SyncedTables context.
  """

  import Ecto.Query, warn: false
  alias Syncapp.Repo

  alias Syncapp.SyncedTables.SyncTable

  @doc """
  Returns the list of synced_tables.

  ## Examples

      iex> list_synced_tables()
      [%SyncTable{}, ...]

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
  Gets a single sync_table.

  Raises `Ecto.NoResultsError` if the Sync table does not exist.

  ## Examples

      iex> get_sync_table!(123)
      %SyncTable{}

      iex> get_sync_table!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sync_table!(id), do: Repo.get!(SyncTable, id)

  @doc """
  Creates a sync_table.

  ## Examples

      iex> create_sync_table(%{field: value})
      {:ok, %SyncTable{}}

      iex> create_sync_table(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sync_table(attrs \\ %{}) do
    %SyncTable{}
    |> SyncTable.changeset(attrs)
    |> Repo.insert()
  end

  def upsert_sync_tables(attrs \\ [[]]) do
    data = transform_data(attrs)

    Repo.insert_all(SyncTable, data,
      on_conflict: {:replace, [:last_synced_datetime]},
      conflict_target: :table_name
    )
  end

  defp transform_data(data) do
    Enum.map(data, fn k ->
      Map.put(k, "last_synced_datetime", NaiveDateTime.from_iso8601!(k["last_synced_datetime"]))
    end)
    |> Enum.map(fn x -> Map.to_list(x) end)
    |> Enum.map(fn y ->
      Enum.map(y, fn {key, val} -> {String.to_atom(key), val} end)
    end)
  end

  @doc """
  Updates a sync_table.

  ## Examples

      iex> update_sync_table(sync_table, %{field: new_value})
      {:ok, %SyncTable{}}

      iex> update_sync_table(sync_table, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sync_table(%SyncTable{} = sync_table, attrs) do
    sync_table
    |> SyncTable.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a sync_table.

  ## Examples

      iex> delete_sync_table(sync_table)
      {:ok, %SyncTable{}}

      iex> delete_sync_table(sync_table)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sync_table(%SyncTable{} = sync_table) do
    Repo.delete(sync_table)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sync_table changes.

  ## Examples

      iex> change_sync_table(sync_table)
      %Ecto.Changeset{data: %SyncTable{}}

  """
  def change_sync_table(%SyncTable{} = sync_table, attrs \\ %{}) do
    SyncTable.changeset(sync_table, attrs)
  end
end
