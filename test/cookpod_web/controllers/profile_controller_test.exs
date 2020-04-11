defmodule CookpodWeb.ProfileControllerTest do
  use CookpodWeb.ConnCase

  describe "me/2" do
    test "it renders profile page if user authenticated", %{conn: conn} do
      path = Routes.profile_path(conn, :me)
      conn =
        conn
        |> with_basic_auth(@basic_auth_username, @basic_auth_password)
        |> with_session()
        |> put_session(:current_user, "John")
        |> get(path)

      assert html_response(conn, 200) =~ "Profile"
    end

    test "it redirects to login page unless user authenticated", %{conn: conn} do
      path = Routes.profile_path(conn, :me)
      conn =
        conn
        |> with_basic_auth(@basic_auth_username, @basic_auth_password)
        |> get(path)

      assert redirected_to(conn, 302) =~ Routes.session_path(conn, :new)
    end
  end
end

