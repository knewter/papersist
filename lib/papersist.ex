defmodule Papersist do
  use Application
  import Supervisor.Spec, warn: false

  def start(_type, _args) do
    opts = [strategy: :rest_for_one, name: Papersist.Supervisor]
    Supervisor.start_link(children(Mix.env), opts)
  end

  def children(:test) do
    children(:dev)
      |> List.delete(bot_worker())
      |> List.delete(poster_worker())
  end
  def children(_) do
    [
      queue_worker(),
      bot_worker(),
      poster_worker()
    ]
  end

  defp bot_worker, do: worker(Papersist.Bot, [])
  defp poster_worker, do: worker(Papersist.Poster, [])
  defp queue_worker, do: worker(Papersist.Queue, [])
end
