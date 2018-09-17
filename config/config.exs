# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :has_my_gsuite_been_pwned,
  ecto_repos: [HasMyGsuiteBeenPwned.Repo]

# Configures the endpoint
config :has_my_gsuite_been_pwned, HasMyGsuiteBeenPwnedWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "t+ONqsOENL2730Bo4kyvdcFr9MxVMBg7WN2bm1hWBmjaLbThui6CjB+ekTmP385K",
  render_errors: [view: HasMyGsuiteBeenPwnedWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: HasMyGsuiteBeenPwned.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
