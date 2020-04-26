defmodule Cookpod.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Cookpod.Repo

  def user_factory do
    %Cookpod.Accounts.User{
      email: sequence(:email, &"#{&1}@email.com"),
      password: "123456",
      password_confirmation: "123456"
    }
  end

  def user_with_encrypted_password_factory do
    user = user_factory()
    %{user | encrypted_password: Argon2.hash_pwd_salt(user.password)}
  end

  def recipe_factory do
    %Cookpod.Recipes.Recipe{
      name: sequence(:name, &"recipe #{&1}"),
      description: "some description",
      state: "published"
    }
  end
end
