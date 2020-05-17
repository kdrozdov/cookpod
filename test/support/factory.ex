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

  def recipe_with_ingredients(recipe) do
    insert(:ingredient, recipe: recipe)
    insert(:ingredient, recipe: recipe)
    recipe |> Cookpod.Repo.preload(ingredients: [:product])
  end

  def ingredient_factory do
    %Cookpod.Recipes.Ingredient{
      recipe: build(:recipe),
      product: build(:product),
      amount: 200
    }
  end

  def product_factory do
    %Cookpod.Recipes.Product{
      name: sequence(:name, &"product #{&1}"),
      carbs: 10,
      fats: 50,
      proteins: 100
    }
  end
end
