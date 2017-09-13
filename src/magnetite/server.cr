module Magnetite

  # A Tuple Space server
  #
  #
  class Server
    getter host : String, port : UInt64

    def initialize(@host : String, port : Int)
      @port = port.to_u64
      @tcp = TCPServer.new(@host, @port)
      @sockets = [] of TCPSocket

      start
    end

    def start
      return false if @spawned
      @spawned = true

      spawn do
        loop do

          if socket = @tcp.accept?
            spawn handler(socket)
          else
            # server is closed
            break
          end

        end
      end
    end

    private def handler(socket : TCPSocket)
      @sockets << socket

      # autentication could go here

      loop do
        msg = socket.gets
        socket << "pong\n" if msg == "ping" # for testing
      end
    end

  end

end
