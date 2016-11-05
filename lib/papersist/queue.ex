defmodule Papersist.Queue do
  alias Experimental.GenStage
  use GenStage

  # Public API
  def start_link() do
    GenStage.start_link(__MODULE__, [], name: __MODULE__)
  end

  def put_in(term, timeout \\ 5_000) do
    GenStage.call(__MODULE__, {:put_in, term}, timeout)
  end

  def clear(timeout \\ 5_000) do
    GenStage.call(__MODULE__, :clear, timeout)
  end

  # Server API
  def init([]) do
    #{:ok, :queue.new()}
    {:producer, {:queue.new(), 0}, dispatcher: GenStage.BroadcastDispatcher}
  end

  def handle_call({:put_in, term}, from, {queue, demand}) do
    dispatch_events(:queue.in({from, term}, queue), demand, [])
  end
  def handle_call(:clear, _from, {_queue, demand}) do
    {:reply, :ok, {:queue.new(), demand}}
  end

  def handle_demand(incoming_demand, {queue, demand}) do
    dispatch_events(queue, incoming_demand + demand, [])
  end

  defp dispatch_events(queue, demand, events) do
    with d when d > 0 <- demand,
                {item, queue} = :queue.out(queue),
                {:value, {from, event}} <- item do
                  GenStage.reply(from, :ok)
                  dispatch_events(queue, demand - 1, [event | events])
    else
      _ -> {:noreply, Enum.reverse(events), {queue, demand}}
    end
  end
end
