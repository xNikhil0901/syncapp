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
    data =
      [
        %{"table_name" => "users", "last_synced_datetime" => NaiveDateTime.local_now()},
        %{"table_name" => "employers", "last_synced_datetime" => NaiveDateTime.local_now()}
      ]
      |> transform_data()

    Repo.insert_all(SyncTable, data,
      on_conflict: {:replace, [:last_synced_datetime]},
      conflict_target: :table_name
    )
  end

  defp transform_data(data) do
    Enum.map(data, fn x ->
      Enum.map(x, fn {key, val} ->
        if key == "last_synced_datetime",
          do: {String.to_atom(key), NaiveDateTime.from_iso8601!(val)},
          else: {String.to_atom(key), val}
      end)
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
end
