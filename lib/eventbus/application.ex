defmodule Eventbus.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        {Eventbus.Router, []}
      ] ++ file_logger_children() ++ http_children()

    Supervisor.start_link(children, strategy: :one_for_one, name: Eventbus.Supervisor)
  end

  defp http_children do
    config = Application.get_env(:eventbus, Eventbus.HTTP, [])

    if Keyword.get(config, :enabled, true) do
      [
        {Plug.Cowboy,
         scheme: :http,
         plug: Eventbus.HTTP.Router,
         options: [
           ip: Keyword.get(config, :ip, {127, 0, 0, 1}),
           port: Keyword.get(config, :port, 4040)
         ]}
      ]
    else
      []
    end
  end

  defp file_logger_children do
    config = Application.get_env(:eventbus, :file_logger, [])

    if Keyword.get(config, :enabled, false) do
      [
        {Eventbus.Subscribers.FileLogger,
         path: Keyword.get(config, :path, "eventbus_events.jsonl"),
         patters: Keyword.get(config, :patterns, ["*"])}
      ]
    else
      []
    end
  end
end
