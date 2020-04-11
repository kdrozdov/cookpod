defmodule CookpodWeb.PageControllerTest do
  use CookpodWeb.ConnCase

  describe "index/2" do
    test "it renders root page", %{conn: conn} do
      path = Routes.page_path(conn, :index)

      conn =
        conn
        |> with_basic_auth(@basic_auth_username, @basic_auth_password)
        |> get(path)

      assert html_response(conn, 200) =~ "Cookpod"
    end
  end
end
