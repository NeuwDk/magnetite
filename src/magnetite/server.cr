module Magnetite

  # A Tuple Space server
  #
  #
  class Server
    getter host : String, port : UInt64

    def initialize(@host : String, port : Int)
      @port = port.to_u64
      @tcp = TCPServer.new(@host, @port)

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

      loop do
        msg = socket.gets

        if msg
          #puts "handler: #{msg}"

          case msg
          when Protocol::ACTIONS[:take]
            take(socket)
          when Protocol::ACTIONS[:write]
            write(socket)
          when  Protocol::ACTIONS[:read]
            # do something
          when Protocol::ACTIONS[:read_all]
            # do something
          when "ping"
            socket.puts "pong"
          end
        else
          # socket dead
          break
        end
      end
    end

    private def ok(socket : TCPSocket)
      socket.puts Protocol::ACTIONS[:accept]
    end

    def take(socket : TCPSocket)
      loop do
        msg = socket.gets

        #puts "take: #{msg}"
        if msg
          array = Protocol.parse(msg)
          socket.puts(msg)
          break
        end
      end
    end

    def write(socket : TCPSocket)
      msg = socket.gets

      if msg
        #ok(socket)
      end
    end

  end

end
