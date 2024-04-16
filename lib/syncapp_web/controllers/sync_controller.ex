defmodule SyncappWeb.SyncController do
  use SyncappWeb, :controller

  action_fallback SyncappWeb.FallbackController

  def get_unsynced_data(conn, params) do
    result = Syncapp.Tables.Query.get_unsynced_data(params["table_name"])

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{status: "success", data: result}))
  end

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
