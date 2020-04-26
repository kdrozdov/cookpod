defmodule CookpodWeb.AccountControllerTest do
  use CookpodWeb.ConnCase

  alias Cookpod.Accounts

  @moduletag basic_auth: true

  describe "me/2" do
    @tag authenticated_user: true
    test "it renders profile page if user authenticated", %{conn: conn, current_user: user} do
      path = Routes.account_me_path(conn, :me)
      conn = get(conn, path)

      assert html_response(conn, 200) =~ user.email
    end

    test "it redirects to login page unless user authenticated", %{conn: conn} do
      path = Routes.account_me_path(conn, :me)
      conn = get(conn, path)

      assert redirected_to(conn, 302) == Routes.session_path(conn, :new)
    end
  end

  describe "new/2" do
    test "it renders new profile page", %{conn: conn} do
      path = Routes.account_path(conn, :new)
      conn = get(conn, path)

      assert html_response(conn, 200) =~ "Please sign up"
    end
  end

  describe "create/2" do
    test "it creates user if params are valid", %{conn: conn} do
      path = Routes.account_path(conn, :create)
      valid_params = string_params_for(:user, %{email: "1@1.com"})

      conn = post(conn, path, %{"user" => valid_params})

      user = Accounts.get_user_by(email: "1@1.com")
      assert redirected_to(conn, 302) == Routes.page_path(conn, :index)
      assert get_session(conn, :current_user_id) == user.id
    end

    test "it does not create user if params are invalid", %{conn: conn} do
      path = Routes.account_path(conn, :create)
      invalid_params = string_params_for(:user, %{password_confirmation: "test"})

      conn = post(conn, path, %{"user" => invalid_params})

      user = Accounts.get_user_by(email: "1@1.com")

      assert user == nil
      assert html_response(conn, 422) =~ "Please sign up"
    end
  end
end
