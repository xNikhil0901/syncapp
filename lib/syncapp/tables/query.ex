defmodule Syncapp.Tables.Query do
  import Ecto.Query
  alias Syncapp.Repo

  @doc """
  Returns a list of unsynced records for a provided table that exists in the database.
  """
  def get_unsynced_data(table, user_id) when is_bitstring(table) do
    synced_table_info = get_synced_tables_info(table, user_id)

    case synced_table_info do
      nil ->
        :error

      _ ->
        query =
          from t in table,
            select: ^eval_expr(synced_table_info.table_fields),
            where: t.updated_at > ^last_sync_datetime(synced_table_info)

        Repo.all(query)
    end
  end

  defp last_sync_datetime(synced_table_info) do
    if is_nil(synced_table_info.last_synced_datetime) do
      Application.fetch_env!(:syncapp, :startup_time)
    else
      synced_table_info.last_synced_datetime
    end
  end

  @doc """
  Returns list of all records from the table.

  NOTE: This function is to be used just for testing chunk data response.
  """
  def get_test_all_data(table, user_id \\ 1) do
    synced_table_info = get_synced_tables_info(table, user_id)

    query =
      from t in table,
        select: ^eval_expr(synced_table_info.table_fields)

    Repo.all(query)
  end

  @doc """
  Returns sync information of a user for a specific table.
  """
  def get_synced_tables_info(table, user_id) do
    query =
      from t in "synced_tables",
        join: us in "users_sync_table",
        on: t.sync_table_id == us.sync_table_id,
        where: t.table_name == ^table and us.user_id == ^user_id,
        select: %{last_synced_datetime: us.last_synced_datetime, table_fields: t.table_fields}

    Repo.one(query)
  end

  defp eval_expr(expr) do
    {result, []} = Code.eval_string(expr)

    result
  end
end
