defmodule Papersist.BotTest do
  use ExUnit.Case
  alias Papersist.{Bot, Queue}
  alias ExIrc.SenderInfo
  @state %Bot.State{}
  @nick "bobdole"
  @channel "#cool-papers"
  @sender_info %SenderInfo{nick: @nick}

  setup do
    Queue.clear()
  end

  test "receiving a message with an URL adds it to the queue" do
    url = "http://dailydrip.com"
    msg = "This paper is the best yo: #{url}"
    {:noreply, _} = Bot.handle_info({:received, msg, @sender_info, @channel}, @state)
    assert {:value, %{message: msg, sender: @nick, url: ^url}} = Queue.out()
  end

  test "receiving a message with no URL adds nothing to the queue" do
    msg = "I have a potato, who wants?"
    {:noreply, _} = Bot.handle_info({:received, msg, @sender_info, @channel}, @state)
    assert :empty = Queue.out()
  end
end
