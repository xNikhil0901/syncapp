defmodule Syncapp.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Syncapp.Repo

  alias Syncapp.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    User
    |> select_fields()
    |> Repo.all()
  end

  def get_unsynced_users do
    last_synced_datetime = Syncapp.SyncedTables.get_last_synced_by_table("users")

    User
    |> where([u], u.sync == false or u.sync_datetime > ^last_synced_datetime)
    |> select_fields()
    |> Repo.all()
  end

  def get_unsynced_users_for_update do
    last_synced_datetime = Syncapp.SyncedTables.get_last_synced_by_table("users")

    User
    |> where([u], u.sync == false or u.sync_datetime > ^last_synced_datetime)
  end

  defp select_fields(query) do
    select(query, [u], %{
      name: u.name,
      age: u.age,
      state: u.state,
      city: u.city,
      sync: u.sync,
      sync_datetime: u.sync_datetime
    })
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def update_users_sync_status() do
    get_unsynced_users_for_update()
    |> Repo.update_all(set: [sync: true, sync_datetime: NaiveDateTime.local_now()])
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end
end
