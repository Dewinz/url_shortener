import Config

port = System.get_env("PORT") || 5000

config :url_shortener, :port, port
