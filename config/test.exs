use Mix.Config

# Configure your database
config :cookpod, Cookpod.Repo,
  username: "postgres",
  password: "password",
  database: "cookpod_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Configure the database for GitHub Actions
if System.get_env("GITHUB_ACTIONS") do
  config :cookpod, Cookpod.Repo,
    username: "postgres",
    password: "postgres",
    database: "cookpod_test",
    hostname: "localhost"
end

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :cookpod, CookpodWeb.Endpoint,
  http: [port: 4002],
  server: false

config :cookpod, :basic_auth,
  username: "test",
  password: "secret"

# Print only warnings and errors during test
config :logger, level: :warn
