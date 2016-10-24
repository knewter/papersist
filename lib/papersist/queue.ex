defmodule Papersist.Queue do
  use GenServer

  # Public API
  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def put_in(term) do
    GenServer.call(__MODULE__, {:put_in, term})
  end

  def out() do
    GenServer.call(__MODULE__, :out)
  end

  def clear() do
    GenServer.call(__MODULE__, :clear)
  end

  # Server API
  def init([]) do
    {:ok, :queue.new()}
  end

  def handle_call({:put_in, term}, _from, queue) do
    {:reply, :ok, :queue.in(term, queue)}
  end
  def handle_call(:out, _from, queue) do
    case :queue.out(queue) do
      {:empty, ^queue} -> {:reply, :empty, queue}
      {{:value, item}, new_queue} -> {:reply, {:value, item}, new_queue}
    end
  end
  def handle_call(:clear, _from, queue) do
    {:reply, :ok, :queue.new()}
  end
end
