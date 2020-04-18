defmodule CookpodWeb.CurrentUserPlug do
  @moduledoc """
  This plug checks current_user in session and redirects to
  new session path unless current_user is set
  """

  import Plug.Conn, only: [assign: 3, get_session: 2]
  alias Cookpod.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :current_user_id) do
      nil ->
        conn

      _ ->
        id = get_session(conn, :current_user_id)
        current_user = Accounts.get_user_by(id: id)
        assign(conn, :current_user, current_user)
    end
  end
end
