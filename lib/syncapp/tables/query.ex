defmodule Syncapp.Tables.Query do
  import Ecto.Query
  alias Syncapp.Repo

  @doc """
  Returns a list of unsynced records for a provided table that exists in the database.
  """
  def get_unsynced_data(table) when is_bitstring(table) do
    synced_table_info = get_synced_tables_info(table)

    query =
      from t in table,
        select: ^eval_expr(synced_table_info.table_fields),
        where: t.sync == false or t.sync_datetime > ^synced_table_info.last_synced_datetime

    Repo.all(query)
  end

  @doc """
  Returns sync information of a table.
  """
  def get_synced_tables_info(table) do
    query =
      from t in "synced_tables",
        where: t.table_name == ^table,
        select: [:last_synced_datetime, :table_fields]

    Repo.one!(query)
  end

  defp eval_expr(expr) do
    {result, []} = Code.eval_string(expr)

    result
  end
end
