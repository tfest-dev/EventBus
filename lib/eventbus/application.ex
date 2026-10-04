defmodule Eventbus.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Eventbus.Router, []}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Eventbus.Supervisor)
  end
end
