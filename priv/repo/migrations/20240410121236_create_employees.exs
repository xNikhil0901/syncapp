defmodule Syncapp.Repo.Migrations.CreateEmployees do
  use Ecto.Migration

  def up do
    create table(:employees, primary_key: false) do
      add :name, :string
      add :salary, :integer
      add :occupation, :string
      add :sync, :boolean, default: false
      add :sync_datetime, :naive_datetime, default: nil
    end

    alter table(:employees) do
      modify(:name, references(:users, name: :name, column: :name, type: :string))
    end
  end

  def down do
    drop table(:employees)
  end
end
