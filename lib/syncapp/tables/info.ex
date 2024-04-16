defmodule Syncapp.Tables.Info do
  import Ecto.Query
  alias Syncapp.Repo

  @doc """
  Returns a list of columns / fields of a db table.

  postgresql raw query: "select column_name from information_schema.columns where table_schema = 'public' and table_name= 'users';"
  """
  def get_columns(table) do
    query =
      from t in "columns",
        prefix: "information_schema",
        where: t.table_schema == ^"public" and t.table_name == ^table,
        select: t.column_name

    Repo.all(query)
  end
end
