# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :cook,
  ecto_repos: [Cook.Repo]

# Configures the endpoint
config :cook, CookWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wgMkWkCD7ZCXQylFv+CW+sMt8UX8sPgkFXc7nX0ejmQwhAryGbYzR8ua6/KyA5j8",
  render_errors: [view: CookWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Cook.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
