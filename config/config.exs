# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :gsgms,
  namespace: GSGMS,
  ecto_repos: [GSGMS.Repo],
  generators: [binary_id: true]

config :gsgms, GSGMS.Repo, migration_timestamps: [type: :utc_datetime_usec]

# Configures the endpoint
config :gsgms, GSGMSWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kfA+RAun/oT1NqLciAERUa2nxu2qdLMX5r70j1DWm5LthuKOJhlV8H1UEY9RFKNm",
  render_errors: [view: GSGMSWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: GSGMS.PubSub,
  live_view: [signing_salt: "yyX8bC3q"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
