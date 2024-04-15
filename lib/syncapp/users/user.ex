defmodule Syncapp.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "users" do
    field :name, :string, primary_key: true
    field :state, :string
    field :age, :integer
    field :city, :string
    field :sync, :boolean
    field :sync_datetime, :naive_datetime
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :age, :city, :state, :sync, :sync_datetime])
    |> validate_required([:name, :age, :city, :state])
    |> unique_constraint(:name, name: "users_pkey")
  end
end
