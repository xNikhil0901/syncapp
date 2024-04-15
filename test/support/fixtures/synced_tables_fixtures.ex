defmodule Syncapp.SyncedTablesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Syncapp.SyncedTables` context.
  """

  @doc """
  Generate a sync_table.
  """
  def sync_table_fixture(attrs \\ %{}) do
    {:ok, sync_table} =
      attrs
      |> Enum.into(%{
        last_synced_datetime: ~N[2024-04-11 08:30:00],
        table_name: "some table_name"
      })
      |> Syncapp.SyncedTables.create_sync_table()

    sync_table
  end
end
