defmodule CookpodWeb.TestAuthHelpers do
  @moduledoc false

  @basic_auth_username Application.get_env(:cookpod, :basic_auth)[:username]
  @basic_auth_password Application.get_env(:cookpod, :basic_auth)[:password]

  import Plug.Conn, only: [put_session: 3, put_req_header: 3]

  def basic_auth_username(), do: @basic_auth_username
  def basic_auth_password(), do: @basic_auth_password

  def basic_auth(conn, username, password) do
    header_content = "Basic " <> Base.encode64("#{username}:#{password}")
    conn |> put_req_header("authorization", header_content)
  end

  def basic_auth(conn) do
    basic_auth(conn, basic_auth_username(), basic_auth_password())
  end

  def init_session(conn) do
    Plug.Test.init_test_session(conn, %{})
  end

  def authenticate_user(conn, user) do
    conn
    |> init_session()
    |> put_session(:current_user_id, user.id)
  end
end
