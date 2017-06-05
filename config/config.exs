# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :music_vote_api,
  api_key: {:system, "API_KEY", "test"},
  ecto_repos: [MusicVoteApi.Repo]

# Configures the endpoint
config :music_vote_api, MusicVoteApi.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "92ZS5gSnrMxTguwlnnD3/4sgZ0Dw9nttMmANpYNJ5oQSria67L8BFvPfvw5b6sgX",
  render_errors: [view: MusicVoteApi.ErrorView, accepts: ~w(json)],
  pubsub: [name: MusicVoteApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
