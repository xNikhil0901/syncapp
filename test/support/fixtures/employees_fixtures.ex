defmodule Syncapp.EmployeesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Syncapp.Employees` context.
  """

  @doc """
  Generate a employee.
  """
  def employee_fixture(attrs \\ %{}) do
    {:ok, employee} =
      attrs
      |> Enum.into(%{
        name: "some name",
        occupation: "some occupation",
        salary: 42
      })
      |> Syncapp.Employees.create_employee()

    employee
  end
end
