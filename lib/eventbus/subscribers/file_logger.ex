defmodule Eventbus.Subscribers.FileLogger do
  @moduledoc """
  Subscriber process that appends Eventbus events to a JSON Lines file.
  """

  use GenServer

  require Logger

  def start_link(opts) do
    path = Keyword.fetch!(opts, :path)
    patterns = Keyword.get(opts, :patterns, ["*"])
    router = Keyword.get(opts, :router, Eventbus.Router)

    GenServer.start_link(__MODULE__, {path, patterns, router}, opts[:gen_server_opts] || [])
  end

  @impl true
  def init({path, patterns, router}) do
    Enum.each(patterns, fn pattern ->
      :ok = Eventbus.Router.subscribe(pattern, self(), router)
    end)

    {:ok, %{path: path, patterns: patterns}}
  end

  @impl true
  def handle_info({:eventbus_event, event}, state) do
    line = Jason.encode!(event_to_map(event)) <> "\n"

    case File.write(state.path, line, [:append]) do
      :ok ->
        :ok

      {:error, reason} ->
        Logger.error("[eventbus] failed to write event log #{state.path}: #{inspect(reason)}")
    end

    {:noreply, state}
  end

  def handle_info(_message, state), do: {:noreply, state}

  defp event_to_map(event) do
    %{
      id: event.id,
      topic: event.topic,
      source: event.source,
      ts: event.ts,
      payload: event.payload
    }
  end
end
