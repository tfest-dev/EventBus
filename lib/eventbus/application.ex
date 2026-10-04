defmodule Eventbus.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        {Eventbus.Router, []}
      ] ++ http_children()

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
end
