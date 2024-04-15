defmodule SyncappWeb.SyncController do
  use SyncappWeb, :controller

  alias Syncapp.Employees.Employee
  alias Syncapp.Employees
  alias Syncapp.Users
  alias Syncapp.Users.User

  action_fallback SyncappWeb.FallbackController

  def get_all_data(conn, _params) do
    users = Users.get_unsynced_users()
    employees = Employees.get_unsynced_employees()

    data = %{
      "users" => users,
      "employees" => employees
    }

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{status: "success", data: data}))
  end

  @doc """
  request_body_model = %{
    "tables_to_sync" => ["users", "employers"],
    "patch_synced_tables" => [
      %{"table_name" => "users", "last_synced_datetime" => "2024-04-15 10:00:00"},
      %{"table_name" => "employers", "last_synced_datetime" => "2024-04-15 10:00:00"}
    ]
  }
  """
  def sync_server(conn, params) do
    Users.update_users_sync_status()
    Employees.update_employees_sync_status()

    Syncapp.SyncedTables.upsert_sync_tables(params["update_synced_tables"])

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{status: "success", message: "Sync successfull."}))
  end

  def create_user(conn, params) do
    with {:ok, %User{} = _user} <- Users.create_user(params) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{status: "success", data: "User created successfully."}))
    else
      {:error, changeset} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
          200,
          Jason.encode!(%{status: "fail", errors: parse_changeset_errors(changeset)})
        )
    end
  end

  def create_employee(conn, params) do
    with {:ok, %Employee{} = _employee} <- Employees.create_employee(params) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(
        200,
        Jason.encode!(%{status: "success", data: "Employee created successfully."})
      )
    else
      {:error, changeset} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
          200,
          Jason.encode!(%{status: "fail", errors: parse_changeset_errors(changeset)})
        )
    end
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
