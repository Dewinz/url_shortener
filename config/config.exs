import Config

config :url_shortener, data_file: ~c"data/data.dets"

import_config "#{config_env()}.exs"
