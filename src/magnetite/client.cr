module Magnetite

  # Client for the tuple space
  class Client
    @port : UInt64

    # host and port of server
    def initialize(@host : String, port : Int)
      @port = port.to_u64

      @server = TCPSocket.new(@host, @port)
    end

    # write to tuple space
    def write(array : Array(Type))
      @server.puts Protocol::ACTIONS[:write]
      @server.puts Protocol.stringify(array)

      @server.gets === Protocol::ACTIONS[:accept]
    end

    # take a tuple and if there isn't one block until there is
    def take(array : Array(Type))
      @server.puts Protocol::ACTIONS[:take]
      @server.puts Protocol.stringify(array)

      msg = @server.gets

      if msg.is_a? String
        obj = Protocol.parse(msg)
      end
    end

    # read a tuple and if there isn't one block until there is
    def read(array : Array(Type))
      @server.puts Protocol::ACTIONS[:read]
      @server.puts Protocol.stringify(array)

      msg = @server.gets

      if msg.is_a? String
        obj = Protocol.parse(msg)
      end
    end

    # read all tuples that matches and don't block
    def read_all
      @server.puts Protocol::ACTIONS[:read_all]

      msg = @server.gets

      if msg.is_a? String
        obj = Protocol.parse(msg)
      end
    end
  end

end
