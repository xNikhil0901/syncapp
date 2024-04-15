defmodule Syncapp.EmployeesTest do
  use Syncapp.DataCase

  alias Syncapp.Employees

  describe "employees" do
    alias Syncapp.Employees.Employee

    import Syncapp.EmployeesFixtures

    @invalid_attrs %{name: nil, salary: nil, occupation: nil}

    test "list_employees/0 returns all employees" do
      employee = employee_fixture()
      assert Employees.list_employees() == [employee]
    end

    test "get_employee!/1 returns the employee with given id" do
      employee = employee_fixture()
      assert Employees.get_employee!(employee.id) == employee
    end

    test "create_employee/1 with valid data creates a employee" do
      valid_attrs = %{name: "some name", salary: 42, occupation: "some occupation"}

      assert {:ok, %Employee{} = employee} = Employees.create_employee(valid_attrs)
      assert employee.name == "some name"
      assert employee.salary == 42
      assert employee.occupation == "some occupation"
    end

    test "create_employee/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Employees.create_employee(@invalid_attrs)
    end

    test "update_employee/2 with valid data updates the employee" do
      employee = employee_fixture()
      update_attrs = %{name: "some updated name", salary: 43, occupation: "some updated occupation"}

      assert {:ok, %Employee{} = employee} = Employees.update_employee(employee, update_attrs)
      assert employee.name == "some updated name"
      assert employee.salary == 43
      assert employee.occupation == "some updated occupation"
    end

    test "update_employee/2 with invalid data returns error changeset" do
      employee = employee_fixture()
      assert {:error, %Ecto.Changeset{}} = Employees.update_employee(employee, @invalid_attrs)
      assert employee == Employees.get_employee!(employee.id)
    end

    test "delete_employee/1 deletes the employee" do
      employee = employee_fixture()
      assert {:ok, %Employee{}} = Employees.delete_employee(employee)
      assert_raise Ecto.NoResultsError, fn -> Employees.get_employee!(employee.id) end
    end

    test "change_employee/1 returns a employee changeset" do
      employee = employee_fixture()
      assert %Ecto.Changeset{} = Employees.change_employee(employee)
    end
  end
end
