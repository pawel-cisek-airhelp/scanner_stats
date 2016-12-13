# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :scanner_stats,
  ecto_repos: [ScannerStats.Repo]

# Configures the endpoint
config :scanner_stats, ScannerStats.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kYDYzkDcqm7Rx+w9nAY806VqbIYnmcaiB/gyGefxFP8l+3jvkVtdZ/NqqQqGKgye",
  render_errors: [view: ScannerStats.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ScannerStats.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
