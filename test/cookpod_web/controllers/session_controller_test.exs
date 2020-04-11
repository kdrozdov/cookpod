defmodule CookpodWeb.SessionControllerTest do
  use CookpodWeb.ConnCase

  describe "new/2" do
    test "it renders new session page", %{conn: conn} do
      path = Routes.session_path(conn, :new)
      conn =
        conn
        |> with_basic_auth(@basic_auth_username, @basic_auth_password)
        |> get(path)

      assert html_response(conn, 200) =~ "Please sign in"
    end
  end


  describe "create/2" do
    test "it redirects to the root page if credentials are valid", %{conn: conn} do
      credentials = %{"user" => %{ "name" => "John", "password" => "123456" }}
      path = Routes.session_path(conn, :create)

      conn =
        conn
        |> with_basic_auth(@basic_auth_username, @basic_auth_password)
        |> post(path, credentials)

      assert get_session(conn, :current_user) == "John"
      assert redirected_to(conn, 302) == Routes.page_path(conn, :index)
    end

    test "it renders sign in page if credentials are invalid", %{conn: conn} do
      credentials = %{"user" => %{ "name" => "", "password" => "123456" }}
      path = Routes.session_path(conn, :create)

      conn =
        conn
        |> with_basic_auth(@basic_auth_username, @basic_auth_password)
        |> post(path, credentials)

      assert html_response(conn, 422) =~ "Please sign in"
    end
  end

  describe "delete/2" do
    test "it destroys session", %{conn: conn} do
      path = Routes.session_path(conn, :delete)
      conn =
        conn
        |> with_basic_auth(@basic_auth_username, @basic_auth_password)
        |> with_session()
        |> put_session(:current_user, "John")
        |> delete(path)

      assert get_session(conn, :current_user) == nil
      assert redirected_to(conn, 302) == Routes.page_path(conn, :index)
    end
  end

end

