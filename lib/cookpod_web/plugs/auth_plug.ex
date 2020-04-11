defmodule CookpodWeb.AuthPlug do

  import Plug.Conn, only: [get_session: 2, halt: 1]
  import Phoenix.Controller, only: [redirect: 2]
  alias CookpodWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :current_user) do
      nil ->
        conn
        |> redirect(to: Routes.session_path(conn, :new))
        |> halt()
      _ ->
        conn
    end
  end
end

