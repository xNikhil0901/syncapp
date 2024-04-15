defmodule Syncapp.Employees do
  @moduledoc """
  The Employees context.
  """

  import Ecto.Query, warn: false
  alias Syncapp.Repo

  alias Syncapp.Employees.Employee

  @doc """
  Returns the list of employees.

  ## Examples

      iex> list_employees()
      [%Employee{}, ...]

  """
  def list_employees do
    Employee
    |> select_fields()
    |> Repo.all()
  end

  def get_unsynced_employees do
    last_synced_datetime = Syncapp.SyncedTables.get_last_synced_by_table("employees")

    Employee
    |> where([e], e.sync == false or e.sync_datetime > ^last_synced_datetime)
    |> select_fields()
    |> Repo.all()
  end

  def get_unsynced_employees_for_update do
    last_synced_datetime = Syncapp.SyncedTables.get_last_synced_by_table("employees")

    Employee
    |> where([e], e.sync == false or e.sync_datetime > ^last_synced_datetime)
  end

  defp select_fields(query) do
    select(query, [e], %{
      name: e.name,
      salary: e.salary,
      occupation: e.occupation,
      sync: e.sync,
      sync_datetime: e.sync_datetime
    })
  end

  @doc """
  Gets a single employee.

  Raises `Ecto.NoResultsError` if the Employee does not exist.

  ## Examples

      iex> get_employee!(123)
      %Employee{}

      iex> get_employee!(456)
      ** (Ecto.NoResultsError)

  """
  def get_employee!(id), do: Repo.get!(Employee, id)

  @doc """
  Creates a employee.

  ## Examples

      iex> create_employee(%{field: value})
      {:ok, %Employee{}}

      iex> create_employee(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_employee(attrs \\ %{}) do
    %Employee{}
    |> Employee.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a employee.

  ## Examples

      iex> update_employee(employee, %{field: new_value})
      {:ok, %Employee{}}

      iex> update_employee(employee, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_employee(%Employee{} = employee, attrs) do
    employee
    |> Employee.changeset(attrs)
    |> Repo.update()
  end

  def update_employees_sync_status() do
    get_unsynced_employees_for_update()
    |> Repo.update_all(set: [sync: true, sync_datetime: NaiveDateTime.local_now()])
  end

  @doc """
  Deletes a employee.

  ## Examples

      iex> delete_employee(employee)
      {:ok, %Employee{}}

      iex> delete_employee(employee)
      {:error, %Ecto.Changeset{}}

  """
  def delete_employee(%Employee{} = employee) do
    Repo.delete(employee)
  end
end
