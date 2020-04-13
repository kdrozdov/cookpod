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
alias Cookpod.User

user_params = %{
  "email" => "1@gmail.com",
  "password" => "123456",
  "password_confirmation" => "123456"
}

User.changeset(%User{}, user_params)
|> Repo.insert()
