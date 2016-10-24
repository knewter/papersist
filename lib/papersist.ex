defmodule Papersist do
  use Application
  import Supervisor.Spec, warn: false

  def start(_type, _args) do
    opts = [strategy: :rest_for_one, name: Papersist.Supervisor]
    Supervisor.start_link(children(Mix.env), opts)
  end

  def children(:test) do
    children(:dev) |> List.delete(worker(Papersist.Bot, []))
  end
  def children(_) do
    [
      worker(Papersist.Queue, []),
      worker(Papersist.Bot, [])
    ]
  end
end
