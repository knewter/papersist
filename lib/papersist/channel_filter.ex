defmodule Papersist.ChannelFilter do
  alias Experimental.GenStage
  alias Papersist.Queue
  use GenStage

  # Public API
  def start_link(channels) do
    GenStage.start_link(__MODULE__, channels, name: __MODULE__)
  end

  # Server API
  def init(channels) do
    {:producer_consumer, channels, subscribe_to: [Queue]}
  end

  def handle_events(events, _from, channels) do
    IO.puts "ChannelFilter events:"
    IO.inspect events
    events =
      events
        |> Enum.filter(fn(%{channel: channel}) -> channels |> Enum.member?(channel) end)
    {:noreply, events, channels}
  end
end
