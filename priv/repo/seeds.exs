# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Cookpod.Repo.insert!(%Cookpod.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Cookpod.Repo
alias Cookpod.Accounts.User
alias Cookpod.Recipes.Product

user_params = %{
  "email" => "1@gmail.com",
  "password" => "123456",
  "password_confirmation" => "123456"
}

user = Repo.insert!(%User{user_params})

leek     = Repo.insert!(%Product{name: "leek", carbs: 14, fats: 0, proteins: 2})
garlic   = Repo.insert!(%Product{name: "garlic", carbs: 30, fats: 0, proteins: 6})

