defmodule CookpodWeb.Router do
  use CookpodWeb, :router
  use Plug.ErrorHandler

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug BasicAuth, use_config: {:cookpod, :basic_auth}
    plug CookpodWeb.CurrentUserPlug
    plug NavigationHistory.Tracker, history_size: 2
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

    get "/recipes/drafts", RecipeController, :drafts

    resources "/recipes", RecipeController do
      put "/publish", RecipeController, :publish, as: :publish
      put "/unpublish", RecipeController, :unpublish, as: :unpublish
    end
  end

  scope "/", CookpodWeb do
    pipe_through [:browser, :protected]

    scope "/accounts" do
      get "/me", AccountController, :me, as: :account_me
    end
  end

  scope "/api/v1", CookpodWeb.Api, as: :api do
    pipe_through :api

    resources "/recipes", RecipeController, only: [:index, :show]
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :cookpod, swagger_file: "swagger.json"
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

  def swagger_info do
    %{
      basePath: "/api/v1",
      info: %{
        version: "0.0.1",
        title: "Cookpod"
      }
    }
  end
end
