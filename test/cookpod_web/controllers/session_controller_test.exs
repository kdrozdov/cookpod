defmodule CookpodWeb.SessionControllerTest do
  use CookpodWeb.ConnCase

  @moduletag basic_auth: true

  describe "new/2" do
    test "it renders new session page", %{conn: conn} do
      path = Routes.session_path(conn, :new)
      conn = get(conn, path)

      assert html_response(conn, 200) =~ "Please sign in"
    end
  end

  describe "create/2" do
    test "it redirects to the root page if credentials are valid", %{conn: conn} do
      user = insert(:user_with_encrypted_password)
      credentials = %{"email" => user.email, "password" => "123456"}
      path = Routes.session_path(conn, :create)

      conn =
        conn
        |> init_session()
        |> post(path, %{"user" => credentials})

      assert get_session(conn, :current_user_id) == user.id
      assert redirected_to(conn, 302) == Routes.page_path(conn, :index)
    end

    test "it renders sign in page if credentials are invalid", %{conn: conn} do
      user = insert(:user_with_encrypted_password)
      credentials = %{"email" => user.email, "password" => "1234567"}
      path = Routes.session_path(conn, :create)

      conn =
        conn
        |> init_session()
        |> post(path, %{"user" => credentials})

      assert html_response(conn, 422) =~ "Please sign in"
    end
  end

  describe "delete/2" do
    test "it destroys session", %{conn: conn} do
      path = Routes.session_path(conn, :delete)

      conn =
        conn
        |> init_session()
        |> put_session(:current_user_id, 1)
        |> delete(path)

      assert get_session(conn, :current_user_id) == nil
      assert redirected_to(conn, 302) == Routes.page_path(conn, :index)
    end
  end
end
