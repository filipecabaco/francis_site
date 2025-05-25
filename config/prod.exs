import Config

config :francis, watcher: false, bandit_opts: [port: 4000, ip: {0, 0, 0, 0}]
config :logger, level: :info
