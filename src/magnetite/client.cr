module Magnetite

  # Client for the tuple space
  class Client

    class IncorrectPass < Exception
      def initialize(msg = "Incorrect passphrase for server")
        super(msg)
      end
    end


    @port : UInt64

    # host and port of server
    def initialize(@host : String, port : Int, pass : String = CONFIG[:auth_pass])
      @port = port.to_u64

      @server = TCPSocket.new(@host, @port)

      # autentication could go here
      if CONFIG[:auth] === true
        if @server.gets === Protocol::ACTIONS[:passphrase]
          @server.puts pass

          if @server.gets === Protocol::ACTIONS[:reject]
            raise IncorrectPass.new
          end
        end
      end
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
      else
        [] of Type
      end
    end

    # read a tuple and if there isn't one block until there is
    def read(array : Array(Type))
      @server.puts Protocol::ACTIONS[:read]
      @server.puts Protocol.stringify(array)

      msg = @server.gets

      if msg.is_a? String
        obj = Protocol.parse(msg)
      else
        [] of Type
      end
    end

    # read all tuples that matches and don't block
    # (in the sense, that the server will reply immediately)
    def read_all
      @server.puts Protocol::ACTIONS[:read_all]

      msg = @server.gets

      if msg.is_a? String
        obj = Protocol.parse(msg)
      end
    end
  end

end
