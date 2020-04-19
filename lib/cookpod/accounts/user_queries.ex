defmodule Cookpod.Accounts.UserQueries do
  @moduledoc false

  alias Cookpod.Repo
  alias Cookpod.Accounts.User

  def get!(id), do: User |> Repo.get!(id)
  def get_by(attrs), do: User |> Repo.get_by(attrs)

  def create(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def change(%User{} = user) do
    User.changeset(user, %{})
  end
end
