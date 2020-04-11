defmodule CookpodWeb.ProfileController do
  use CookpodWeb, :controller

  def me(conn, _params) do
    render(conn, "me.html")
  end
end
