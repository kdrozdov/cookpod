defmodule Cookpod.AccountsTest do
  use Cookpod.DataCase

  alias Cookpod.Accounts

  describe "users" do
    alias Cookpod.Accounts.User

    @valid_attrs %{
      email: "1@gmail.com",
      password: "123456",
      password_confirmation: "123456"
    }
    @invalid_attrs %{
      email: "1@gmail.com",
      password: "123456",
      password_confirmation: "123455"
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      result_user = Accounts.get_user!(user.id)
      assert result_user.id  == user.id
    end

    test "get_user_by/1 returns the user with given attrs" do
      user = user_fixture()
      result_user = Accounts.get_user_by(email: user.email)
      assert result_user.id == user.id
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
