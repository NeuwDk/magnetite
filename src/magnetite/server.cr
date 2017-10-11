module Magnetite

  # A Tuple Space server
  #
  #
  class Server
    getter host : String, port : UInt64, space : Space

    def initialize(@host : String, port : Int)
      @port = port.to_u64
      @tcp = TCPServer.new(@host, @port)
      @space = Space.new

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
      # autentication could go here
      if CONFIG[:auth] === true
        socket.puts Protocol::ACTIONS[:passphrase]

        if socket.gets === CONFIG[:auth_pass]
          socket.puts Protocol::ACTIONS[:accept]
        else
          socket.puts Protocol::ACTIONS[:reject]
          socket.close
          return
        end
      end

      loop do
        msg = socket.gets

        case msg
        when Nil
          # socket dead
          break
        when Protocol::ACTIONS[:take]
          take(socket)
        when Protocol::ACTIONS[:write]
          write(socket)
        when  Protocol::ACTIONS[:read]
          read(socket)
        when Protocol::ACTIONS[:read_all]
          read_all(socket)
        when "ping"
          socket.puts "pong"
        end
      end
    end

    private def ok(socket : TCPSocket)
      socket.puts Protocol::ACTIONS[:accept]
    end

    def take(socket : TCPSocket)
      msg = socket.gets

      if msg
        array = @space.take(Protocol.parse(msg))

        socket.puts(Protocol.stringify(array))
      end
    end

    def write(socket : TCPSocket)
      msg = socket.gets

      if msg
        array = Protocol.parse(msg)

        if @space.write(array)
          ok(socket)
        end
      end
    end

    def read(socket : TCPSocket)
      if msg = socket.gets
        array = @space.read Protocol.parse(msg)
        socket.puts(Protocol.stringify(array))
      end
    end

    def read_all(socket : TCPSocket)
      socket.puts Protocol.stringify(@space.read_all)
    end

  end

end
