# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :poolEngine,
  ecto_repos: [PoolEngine.Repo]

# Configures the endpoint
config :poolEngine, PoolEngineWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2ncdQj4FgzqankAzzAZTsdssrkk3hgIifgpKtjal5oTXuFmrBkFxEPC/3jEvrx07",
  render_errors: [view: PoolEngineWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: PoolEngine.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix and Ecto
config :phoenix, :json_library, Jason

# Use Guardain as Authentication Token Strategy
config :guardian, PoolEngine.Guardian,
  allowed_algos: ["HS512"],
  issuer: "PoolEngine",
  verify_module: Guardian.JWT,
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true,
  serializer: PoolEngine.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
