defmodule HandyApi.TcpServer do
  require Logger
  alias HandyApi.Logging.Entry

  #{"source_id":"5ae9f1133e21ab00016dd9f4","level":"info","tag":"abc","content":"bad thing happened","timestamp_occurred":"today"}
  #


  def accept(port) do
    # The options below mean:
    #
    # 1. `:binary` - receives data as binaries (instead of lists)
    # 2. `packet: :line` - receives data line by line
    # 3. `active: false` - blocks on `:gen_tcp.recv/2` until data is available
    # 4. `reuseaddr: true` - allows us to reuse the address if the listener crashes
    #

    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])

    Logger.info("Accepting connections on port #{port}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)

    {:ok, pid} =
      Task.Supervisor.start_child(HandyApi.SocketSupervisor, fn ->
        serve(client)
      end)

    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    gram_map =
      socket
      |> read_line()
      |> Jason.decode!()
    gram_map = for {key, val} <- gram_map, into: %{}, do: {String.to_atom(key), val}
    IO.inspect(gram_map)
    gram = struct!(Entry,gram_map)
    {:ok, resp} = Entry.insert(gram)


    resp
    |> Map.from_struct()
    |> Jason.encode!()
    |> write_line(socket)
    serve(socket)
  end
  defp read_line(socket) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, data} ->
        data

      {:error, status} ->
        IO.inspect(status)
        Process.exit(self(), status)
    end
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
