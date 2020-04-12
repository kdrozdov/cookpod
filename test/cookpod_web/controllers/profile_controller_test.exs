defmodule CookpodWeb.ProfileControllerTest do
  use CookpodWeb.ConnCase

  alias Cookpod.Repo
  alias Cookpod.User

  describe "me/2" do
    test "it renders profile page if user authenticated", %{conn: conn} do
      user = create_user("1@1.com", "123456")
      path = Routes.profile_me_path(conn, :me)

      conn =
        conn
        |> with_basic_auth(@basic_auth_username, @basic_auth_password)
        |> with_session()
        |> put_session(:current_user_id, user.id)
        |> get(path)

      assert html_response(conn, 200) =~ "Profile"
    end

    test "it redirects to login page unless user authenticated", %{conn: conn} do
      path = Routes.profile_me_path(conn, :me)

      conn =
        conn
        |> with_basic_auth(@basic_auth_username, @basic_auth_password)
        |> get(path)

      assert redirected_to(conn, 302) == Routes.session_path(conn, :new)
    end

    defp create_user(email, password) do
      params = %{
        "email" => email,
        "password" => password,
        "password_confirmation" => password
      }

      changeset = User.changeset(%User{}, params)
      {:ok, user} = changeset |> Repo.insert()

      user
    end
  end

  describe "new/2" do
    test "it renders new profile page", %{conn: conn} do
      path = Routes.profile_path(conn, :new)

      conn =
        conn
        |> with_basic_auth(@basic_auth_username, @basic_auth_password)
        |> get(path)

      assert html_response(conn, 200) =~ "Please sign up"
    end
  end

  describe "create/2" do
    test "it creates user if params are valid", %{conn: conn} do
      path = Routes.profile_path(conn, :create)

      valid_params = %{
        "email" => "1@1.com",
        "password" => "test123",
        "password_confirmation" => "test123"
      }

      conn =
        conn
        |> with_basic_auth(@basic_auth_username, @basic_auth_password)
        |> with_session()
        |> post(path, %{"user" => valid_params})

      user = Repo.get_by(User, email: "1@1.com")

      assert redirected_to(conn, 302) == Routes.page_path(conn, :index)
      assert get_session(conn, :current_user_id) == user.id
    end

    test "it does not create user if params are invalid", %{conn: conn} do
      path = Routes.profile_path(conn, :create)

      invalid_params = %{
        "email" => "1@1.com",
        "password" => "test123",
        "password_confirmation" => "test"
      }

      conn =
        conn
        |> with_basic_auth(@basic_auth_username, @basic_auth_password)
        |> with_session()
        |> post(path, %{"user" => invalid_params})

      user = Repo.get_by(User, email: "1@1.com")

      assert user == nil
      assert html_response(conn, 422) =~ "Please sign up"
    end
  end
end
