defmodule CookpodWeb.PageControllerTest do
  use CookpodWeb.ConnCase

  @moduletag basic_auth: true

  describe "index/2" do
    test "it renders root page", %{conn: conn} do
      path = Routes.page_path(conn, :index)
      conn = get(conn, path)

      assert html_response(conn, 200) =~ "Cookpod"
    end
  end
end
