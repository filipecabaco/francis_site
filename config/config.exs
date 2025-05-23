import Config

config :francis, watcher: true
config :logger, level: :debug
import_config "#{config_env()}.exs"
