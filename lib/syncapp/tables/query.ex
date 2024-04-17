defmodule Syncapp.Tables.Query do
  import Ecto.Query
  alias Syncapp.Repo

  @doc """
  Returns a list of unsynced records for a provided table that exists in the database.
  """
  def get_unsynced_data(table, user_id) when is_bitstring(table) do
    synced_table_info = get_synced_tables_info(table, user_id)

    query =
      from t in table,
        select: ^eval_expr(synced_table_info.table_fields),
        where: t.updated_at > ^synced_table_info.last_synced_datetime

    Repo.all(query)
  end

  @doc """
  Returns sync information of a table.
  """
  def get_synced_tables_info(table, user_id) do
    query =
      from t in "synced_tables",
        where: t.table_name == ^table and t.user_id == ^user_id,
        select: [:last_synced_datetime, :table_fields]

    Repo.one!(query)
  end

  defp eval_expr(expr) do
    {result, []} = Code.eval_string(expr)

    result
  end
end
