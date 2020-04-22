# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :cookpod,
  ecto_repos: [Cookpod.Repo]

# Configures the endpoint
config :cookpod, CookpodWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4MdgbwNdUz9KtTKcNn5A3xRRMAPKJFDrrO9PH6uBuuLas/va/dTiEPYzkobGf8d/",
  render_errors: [view: CookpodWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Cookpod.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "ZQIFgaHu"]

config :cookpod, :email_validator, Cookpod.Validators.EmailValidator

config :phoenix_swagger, json_library: Jason
config :cookpod, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: CookpodWeb.Router,     # phoenix routes will be converted to swagger paths
      endpoint: CookpodWeb.Endpoint  # (optional) endpoint config used to set host, port and https schemes.
    ]
  }

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :cookpod, CookpodWeb.Gettext, default_locale: "en"

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine,
  # If you want to use LiveView
  slimleex: PhoenixSlime.LiveViewEngine

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
