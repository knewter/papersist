defmodule Papersist.LinkFilter do
  alias Experimental.GenStage
  alias Papersist.ChannelFilter
  use GenStage
  @url_regex ~r(https?://[^ $\n]*)

  # Public API
  def start_link() do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # Server API
  def init(:ok) do
    {:producer_consumer, :ok, subscribe_to: [ChannelFilter]}
  end

  def handle_events(events, _from, :ok) do
    IO.puts "LinkFilter events:"
    IO.inspect events
    events =
      events
        |> Enum.map(&get_links/1)
        |> List.flatten
    {:noreply, events, :ok}
  end

  defp get_links(%{message: msg, sender: nick, channel: channel}) do
    Regex.scan(@url_regex, msg)
      |> Enum.map(fn(urls) ->
        Enum.map(urls, fn(url) ->
          %{message: msg, sender: nick, url: url, channel: channel}
        end)
      end)
  end
end
