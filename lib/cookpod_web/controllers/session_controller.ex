defmodule CookpodWeb.SessionController do
  use CookpodWeb, :controller

  alias Cookpod.Repo
  alias Cookpod.User

  def new(conn, _params) do
    render(conn, "new.html", errors: %{})
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    user = Repo.get_by(User, email: email)

    case Argon2.check_pass(user, password) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _} ->
        conn
        |> put_status(422)
        |> put_flash(:error, "Invalid email or password")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_user_id)
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
