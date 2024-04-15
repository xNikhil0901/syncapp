defmodule Syncapp.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Syncapp.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        age: 42,
        city: "some city",
        name: "some name",
        state: "some state"
      })
      |> Syncapp.Users.create_user()

    user
  end
end
