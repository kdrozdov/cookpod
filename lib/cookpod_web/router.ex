defmodule CookpodWeb.Router do
  use CookpodWeb, :router
  use Plug.ErrorHandler
  import Plug.BasicAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :basic_auth, Application.compile_env(:cookpod, :basic_auth)
    plug CookpodWeb.CurrentUserPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug CookpodWeb.AuthPlug
  end

  scope "/", CookpodWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/terms", PageController, :terms, as: :terms

    resources "/sessions", SessionController,
      only: [:new, :create, :delete],
      singleton: true

    resources "/accounts", AccountController,
      only: [:new, :create],
      singleton: true
  end

  scope "/", CookpodWeb do
    pipe_through [:browser, :protected]

    scope "/accounts" do
      get "/me", AccountController, :me, as: :account_me
    end
  end

  def handle_errors(conn, %{kind: :error, reason: %Phoenix.Router.NoRouteError{}}) do
    conn
    |> fetch_session()
    |> fetch_flash()
    |> put_layout({CookpodWeb.LayoutView, :app})
    |> put_view(CookpodWeb.ErrorView)
    |> render("404.html")
  end

  def handle_errors(conn, %{kind: :error, reason: %Phoenix.ActionClauseError{}}) do
    conn
    |> fetch_session()
    |> fetch_flash()
    |> put_layout({CookpodWeb.LayoutView, :app})
    |> put_view(CookpodWeb.ErrorView)
    |> render("422.html")
  end

  def handle_errors(conn, _) do
    conn
  end
end
