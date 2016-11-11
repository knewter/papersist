defmodule Papersist.Bot do
  use GenServer
  require Logger
  @url_regex ~r(https?://[^ $\n]*)
  @channel "#cool-papers"
  alias Papersist.Queue

  defmodule State do
    defstruct server:  "elmlang.irc.slack.com",
              port:    6667,
              pass:    nil,
              nick:    "jadams",
              user:    "jadams",
              name:    "Josh Adams",
              channel: @channel,
              client:  nil,
              handlers: []
  end

  alias ExIrc.{Client, SenderInfo}

  def start_link() do
    password = Application.get_env(:papersist, :elm_slack_irc_password)
    state = %State{pass: password}
    GenServer.start_link(__MODULE__, [state], name: String.to_atom(state.nick))
  end

  def init([state]) do
    # Start the client and handler processes, the ExIrc supervisor is automatically started when your app runs
    {:ok, client}  = ExIrc.start_client!()
    Process.link(client)

    # Register the event handler with ExIrc
    Client.add_handler client, self()

    # Connect and logon to a server, join a channel and send a simple message
    Logger.debug "Connecting to #{state.server}:#{state.port}"
    Client.connect! client, state.server, state.port

    {:ok, %State{state | :client => client}}
  end

  def handle_info({:connected, server, port}, state) do
    Logger.debug "Connected to #{server}:#{port}"
    Logger.debug "Logging to #{server}:#{port} as #{state.nick}.."
    Client.logon state.client, state.pass, state.nick, state.user, state.name
    {:noreply, state}
  end
  def handle_info(:logged_in, state) do
    Logger.debug "Logged in to #{state.server}:#{state.port}"
    Logger.debug "Joining #{state.channel}.."
    Client.join state.client, state.channel
    {:noreply, state}
  end
  def handle_info(:disconnected, state) do
    Logger.debug "Disconnected from #{state.server}:#{state.port}"
    {:stop, :normal, state}
  end
  def handle_info({:joined, channel}, state) do
    Logger.debug "Joined #{channel}"
    {:noreply, state}
  end
  def handle_info({:names_list, channel, names_list}, state) do
    names = String.split(names_list, " ", trim: true)
            |> Enum.map(fn name -> " #{name}\n" end)
    Logger.info "Users logged in to #{channel}:\n#{names}"
    {:noreply, state}
  end
  def handle_info({:received, msg, %SenderInfo{:nick => nick}, channel}, state) do
    Logger.info "#{nick} from #{channel}: #{msg}"
    :ok = handle_message(msg, nick, channel)
    {:noreply, state}
  end
  def handle_info({:mentioned, msg, %SenderInfo{:nick => nick}, channel}, state) do
    Logger.warn "#{nick} mentioned you in #{channel}"
    {:noreply, state}
  end
  def handle_info({:received, msg, %SenderInfo{:nick => nick}}, state) do
    Logger.warn "#{nick}: #{msg}"
    {:noreply, state}
  end
  # Catch-all for messages you don't care about
  def handle_info(_msg, state) do
    {:noreply, state}
  end

  def terminate(_, state) do
    # Quit the channel and close the underlying client connection when the process is terminating
    Client.quit state.client, "Goodbye, cruel world."
    Client.stop! state.client
    :ok
  end

  def handle_message(msg, nick, channel) do
    Queue.put_in(%{message: msg, sender: nick, channel: channel})
    :ok
    # Regex.scan(@url_regex, msg)
    #   |> Enum.map(fn(urls) ->
    #     Enum.map(urls, fn(url) ->
    #       Queue.put_in(%{message: msg, sender: nick, url: url})
    #     end)
    #   end)
  end
end
