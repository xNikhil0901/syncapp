defmodule Syncapp.Employees.Employee do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "employees" do
    field :name, :string
    field :salary, :integer
    field :occupation, :string
    field :sync, :boolean
    field :sync_datetime, :naive_datetime
    belongs_to(:user, Syncapp.Users.User, references: :name)
  end

  @doc false
  def changeset(employee, attrs) do
    employee
    |> cast(attrs, [:name, :salary, :occupation, :sync, :sync_datetime])
    |> validate_required([:name, :salary, :occupation])
  end
end
