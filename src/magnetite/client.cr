module Magnetite

  # Client for the tuple space
  class Client

    # host and port of server
    def initialize(@host : String, port : Int)
      @port = port.to_u64

      @server = TCPSocket.new(@host, @port)
    end

    # write to tuple space
    def write(tuple)
    end

    # take a tuple and if there isn't one block until there is
    def take(tuple)
    end

    # read a tuple and if there isn't one block until there is
    def read(tuple)
    end

    # read all tuples that matches and don't block
    def read_all(tuple)
    end
  end

end
