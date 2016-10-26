defmodule Papersist.Poster do
  use GenServer
  alias Papersist.Queue

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def init([]) do
    send(self, :post_from_queue)
    {:ok, :no_state}
  end

  def handle_info(:post_from_queue, state) do
    case Queue.out do
      :empty -> :ok
      {:value, message} -> post_message(message)
    end
    Process.send_after(self, :post_from_queue, 1_000)
    {:noreply, state}
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
