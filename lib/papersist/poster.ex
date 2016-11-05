defmodule Papersist.Poster do
  alias Experimental.GenStage
  alias Papersist.LinkFilter
  use GenStage

  def start_link() do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:consumer, :ok, subscribe_to: [LinkFilter]}
  end

  def handle_events(events, _from, state) do
    IO.puts "Poster events:"
    IO.inspect events
    events |> Enum.map(&post_message/1)
    {:noreply, [], state}
  end

  def post_message(%{message: message, sender: nick, url: url}) do
    body = """
    url: #{url}
    nick: #{nick}
    message: #{message}
    """
    Wordpress.create_post("#{nick}: #{url}", body)
  end
end
