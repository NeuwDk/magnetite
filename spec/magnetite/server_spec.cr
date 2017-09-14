describe Magnetite::Server do
  host = "127.0.0.1"
  port = 12345
  server = Magnetite::Server.new(host, port)

  describe "#initialize" do
    it "saves assigned host and port" do
      server.host.should eq(host)
      server.port.should eq(port)
    end

    it "starts the tcp server" do
      client = TCPSocket.new(host, port)
      client.puts "ping"
      client.gets.should eq("pong")
      client.close
    end

    it "starts the server and can handle multiple connections" do
      ch = Channel(Int32).new

      10.times do |i|
        spawn do
          clientm = TCPSocket.new(host, port)

          clientm.puts "ping"
          clientm.gets.should eq("pong")

          clientm.close
          ch.send 1
        end
      end

      10.times { ch.receive }
    end

    it "can do parrallel connections" do
      client1 = TCPSocket.new(host, port)
      client2 = TCPSocket.new(host, port)
      client1.puts "ping"
      client2.puts "ping"
      client2.gets.should eq("pong")
      client1.gets.should eq("pong")
      client1.close
      client2.close
    end

  end

  describe "#start" do
    it "returns false as it sohuld already be started" do
      server.start.should eq(false)
    end
  end

  describe "#take" do
    it "receives and parses an array properly" do
      array = [1,2,3]
      stringified_a = Magnetite::Protocol.stringify(array)
      client = TCPSocket.new(host,port)

      client.puts Magnetite::Protocol::ACTIONS[:write]
      client.puts stringified_a

      client.puts Magnetite::Protocol::ACTIONS[:take]
      client.puts stringified_a

      client.gets.should eq(stringified_a)

      client.close
    end

  end

end
