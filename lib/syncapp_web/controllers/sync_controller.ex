defmodule SyncappWeb.SyncController do
  use SyncappWeb, :controller

  action_fallback SyncappWeb.FallbackController
  @allowed_content_length 1000
  @size 100

  def get_unsynced_data(conn, params) do
    result =
      Syncapp.Tables.Query.get_unsynced_data(
        params["table_name"],
        String.to_integer(params["user_id"])
      )

    Syncapp.UsersSyncTable.update_user_sync_table(params["table_name"], params["user_id"])

    if length(result) > @allowed_content_length do
      send_data_in_chunk(conn, result)
    else
      json(conn, %{status: "success", data: result})
    end
  end

  defp send_data_in_chunk(conn, result) do
    conn = conn |> put_resp_content_type("application/json") |> send_chunked(200)

    Enum.reduce_while(Enum.chunk_every(result, @size), conn, fn chunk, conn ->
      case chunk(conn, Jason.encode!(chunk)) do
        {:ok, conn} ->
          {:cont, conn}

        {:error, :closed} ->
          {:halt, conn}
      end
    end)
  end

  @spec sync_server(Plug.Conn.t(), nil | maybe_improper_list() | map()) :: Plug.Conn.t()
  def sync_server(conn, params) do
    Syncapp.SyncedTables.upsert_sync_tables(params["update_synced_tables"])

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{status: "success", message: "Sync successfull."}))
  end

  def parse_changeset_errors(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {msg, _opts} ->
      msg
    end)
    |> Enum.filter(fn x -> x != %{} end)
    |> Enum.reduce(%{}, fn {key, [h | _t]}, acc -> Map.put(acc, key, h) end)
  end
end
