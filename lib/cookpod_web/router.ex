defmodule CookpodWeb.Router do
  use CookpodWeb, :router
  import Plug.BasicAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :basic_auth, Application.compile_env(:cookpod, :basic_auth)
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
  end

  scope "/", CookpodWeb do
    pipe_through [:browser, :protected]

    scope "/profiles" do
      get "/me", ProfileController, :me, as: :profile
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", CookpodWeb do
  #   pipe_through :api
  # end
end
