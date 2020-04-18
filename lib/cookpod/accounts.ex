defmodule Cookpod.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Cookpod.Repo

  alias Cookpod.Accounts.User

  def get_user!(id), do: User |> Repo.get!(id)
  def get_user_by(attrs), do: User |> Repo.get_by(attrs)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
