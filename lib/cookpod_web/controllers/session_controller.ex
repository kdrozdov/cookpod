defmodule CookpodWeb.SessionController do
  use CookpodWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html", errors: %{})
  end

  def create(conn, %{"user" => user}) do
    case validate_user(user) do
      errors when map_size(errors) == 0 ->
        conn
        |> put_session(:current_user, user["name"])
        |> redirect(to: Routes.page_path(conn, :index))
      errors ->
        conn
        |> put_status(422)
        |> render("new.html", errors: errors)
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_user)
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp validate_user(user) do
    Enum.reduce(user, %{}, fn {name, value}, acc ->
      if String.length(value) == 0, do: Map.put(acc, name, "#{name} cannot be blank"), else: acc
    end)
  end
end


