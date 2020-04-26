defmodule Cookpod.AccountsTest do
  use Cookpod.DataCase

  alias Cookpod.Accounts

  describe "users" do
    alias Cookpod.Accounts.User

    test "get_user!/1 returns the user with given id" do
      user = insert(:user)
      result_user = Accounts.get_user!(user.id)
      assert result_user.id == user.id
    end

    test "get_user_by/1 returns the user with given attrs" do
      user = insert(:user)
      result_user = Accounts.get_user_by(email: user.email)
      assert result_user.id == user.id
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = params_for(:user)
      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
    end

    test "create_user/1 with invalid data returns error changeset" do
      invalid_attrs = params_for(:user, %{password_confirmation: "test"})
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(invalid_attrs)
    end

    test "change_user/1 returns a user changeset" do
      user = insert(:user)
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
