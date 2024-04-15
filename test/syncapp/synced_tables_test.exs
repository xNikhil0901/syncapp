defmodule Syncapp.SyncedTablesTest do
  use Syncapp.DataCase

  alias Syncapp.SyncedTables

  describe "synced_tables" do
    alias Syncapp.SyncedTables.SyncTable

    import Syncapp.SyncedTablesFixtures

    @invalid_attrs %{table_name: nil, last_synced_datetime: nil}

    test "list_synced_tables/0 returns all synced_tables" do
      sync_table = sync_table_fixture()
      assert SyncedTables.list_synced_tables() == [sync_table]
    end

    test "get_sync_table!/1 returns the sync_table with given id" do
      sync_table = sync_table_fixture()
      assert SyncedTables.get_sync_table!(sync_table.id) == sync_table
    end

    test "create_sync_table/1 with valid data creates a sync_table" do
      valid_attrs = %{table_name: "some table_name", last_synced_datetime: ~N[2024-04-11 08:30:00]}

      assert {:ok, %SyncTable{} = sync_table} = SyncedTables.create_sync_table(valid_attrs)
      assert sync_table.table_name == "some table_name"
      assert sync_table.last_synced_datetime == ~N[2024-04-11 08:30:00]
    end

    test "create_sync_table/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SyncedTables.create_sync_table(@invalid_attrs)
    end

    test "update_sync_table/2 with valid data updates the sync_table" do
      sync_table = sync_table_fixture()
      update_attrs = %{table_name: "some updated table_name", last_synced_datetime: ~N[2024-04-12 08:30:00]}

      assert {:ok, %SyncTable{} = sync_table} = SyncedTables.update_sync_table(sync_table, update_attrs)
      assert sync_table.table_name == "some updated table_name"
      assert sync_table.last_synced_datetime == ~N[2024-04-12 08:30:00]
    end

    test "update_sync_table/2 with invalid data returns error changeset" do
      sync_table = sync_table_fixture()
      assert {:error, %Ecto.Changeset{}} = SyncedTables.update_sync_table(sync_table, @invalid_attrs)
      assert sync_table == SyncedTables.get_sync_table!(sync_table.id)
    end

    test "delete_sync_table/1 deletes the sync_table" do
      sync_table = sync_table_fixture()
      assert {:ok, %SyncTable{}} = SyncedTables.delete_sync_table(sync_table)
      assert_raise Ecto.NoResultsError, fn -> SyncedTables.get_sync_table!(sync_table.id) end
    end

    test "change_sync_table/1 returns a sync_table changeset" do
      sync_table = sync_table_fixture()
      assert %Ecto.Changeset{} = SyncedTables.change_sync_table(sync_table)
    end
  end
end
