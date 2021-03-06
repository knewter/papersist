defmodule Papersist do
  use Application
  import Supervisor.Spec, warn: false
  @channels ["#cool-papers"]

  def start(_type, _args) do
    opts = [strategy: :rest_for_one, name: Papersist.Supervisor]

    Application.get_env(:papersist, :environment)
      |> children
      |> Supervisor.start_link(opts)
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
      channel_filter_worker(),
      link_filter_worker(),
      poster_worker()
    ]
  end

  defp bot_worker, do: worker(Papersist.Bot, [])
  defp poster_worker, do: worker(Papersist.Poster, [])
  defp channel_filter_worker, do: worker(Papersist.ChannelFilter, [@channels])
  defp link_filter_worker, do: worker(Papersist.LinkFilter, [])
  defp queue_worker, do: worker(Papersist.Queue, [])
end
