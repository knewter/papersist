defmodule Papersist.QueueTest do
  use ExUnit.Case
  alias Papersist.Queue

  setup do
    Queue.clear()
  end

  test "getting something out of the queue when empty" do
    assert :empty == Queue.out()
  end

  test "putting something into the queue" do
    :ok = Queue.put_in(:thing)
  end

  test "putting something into the queue and getting it back out" do
    :ok = Queue.put_in(:thing)
    assert {:value, :thing} = Queue.out()
  end
end
