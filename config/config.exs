import Config

config :eventbus, Eventbus.HTTP,
  enabled: true,
  ip: {127, 0, 0, 1},
  port: 4040

config :eventbus, :file_logger,
  enabled: false,
  path: "eventbus_events.jsonl",
  patterns: ["*"]

config :eventbus, :desktop_notify,
  enabled: false,
  command: "notify-send",
  patterns: [
    "repo.tests.failed",
    "codex.run.finished",
    "website.deploy.finished"
  ]

env_config = "#{config_env()}.exs"

if File.exists?(Path.join(__DIR__, env_config)) do
  import_config env_config
end
