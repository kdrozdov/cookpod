defmodule CookpodWeb.PageControllerTest do
  use CookpodWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/en")
    assert html_response(conn, 200) =~ "Cookpod"
  end
end
