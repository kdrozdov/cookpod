defmodule Cookpod.Accounts do
  @moduledoc """
  The Accounts context.
  """
  alias Cookpod.Accounts.UserQueries

  def get_user!(id), do: UserQueries.get!(id)
  def get_user_by(attrs), do: UserQueries.get_by(attrs)

  def create_user(attrs \\ %{}) do
    UserQueries.create(attrs)
  end

  def change_user(user) do
    UserQueries.change(user)
  end
end
