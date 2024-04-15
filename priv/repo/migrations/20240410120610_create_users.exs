defmodule Syncapp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
    create table(:users, primary_key: false) do
      add :name, :string, primary_key: true
      add :age, :integer
      add :city, :string
      add :state, :string
      add :sync, :boolean, default: false
      add :sync_datetime, :naive_datetime, default: nil
    end
  end

  def down do
    drop table(:users)
  end
end
