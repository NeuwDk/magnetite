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
    it "takes one 'tuple' from the space and removes it from the space" do
      array = [1,2,3]
      stringified_a = Magnetite::Protocol.stringify(array)
      client = TCPSocket.new(host,port)

      client.puts Magnetite::Protocol::ACTIONS[:write]
      client.puts stringified_a
      client.gets

      client.puts Magnetite::Protocol::ACTIONS[:take]
      client.puts stringified_a

      client.gets.should eq(stringified_a)

      #check that it was removed from the list
      client.puts Magnetite::Protocol::ACTIONS[:read_all]
      client.gets.should eq("[]")

      client.close
    end

  end

  describe "#write" do
    it "returns Protocol::ACTIONS[:accept] on success" do
      client = TCPSocket.new(host,port)

      client.puts Magnetite::Protocol::ACTIONS[:write]
      client.puts "[1:Int]"

      client.gets.should eq(Magnetite::Protocol::ACTIONS[:accept])

      #clean up
      client.puts Magnetite::Protocol::ACTIONS[:take]
      client.puts "[1:Int]"
      client.gets

      client.close
    end

  end

  describe "#read" do
    it "gets one 'tuple' from the space and doesn't delete it" do
      client = TCPSocket.new(host, port)
      s_a = "[1:Int]" # stringified_array
      ra_s = "[#{Magnetite::Protocol.encode(s_a)}]:Array" # read_all_string

      client.puts Magnetite::Protocol::ACTIONS[:write]
      client.puts s_a
      client.gets

      # check that read_all gives the written array
      client.puts Magnetite::Protocol::ACTIONS[:read_all]
      client.gets.should eq(ra_s)

      # gets the array from space
      client.puts Magnetite::Protocol::ACTIONS[:read]
      client.puts s_a
      client.gets.should eq(s_a)

      # still in space?
      client.puts Magnetite::Protocol::ACTIONS[:read_all]
      client.gets.should eq(ra_s)

      #clean up
      client.puts Magnetite::Protocol::ACTIONS[:take]
      client.puts s_a
      client.gets

      client.close
    end

  end

  describe "#read_all" do
    it "returns '[]' when the 'space' is empty" do
      client = TCPSocket.new(host, port)

      client.puts Magnetite::Protocol::ACTIONS[:read_all]

      client.gets.should eq("[]")

      client.close
    end

    it "returns correct value when holding multiple values" do
      client = TCPSocket.new(host, port)

      #check that space is empty
      client.puts Magnetite::Protocol::ACTIONS[:read_all]
      client.gets.should eq("[]")

      ten_ones = [] of Magnetite::Type
      10.times do
        client.puts Magnetite::Protocol::ACTIONS[:write]
        client.puts "[1:Int]"
        ten_ones << [1] of Magnetite::Type
        client.gets
      end
      client.puts Magnetite::Protocol::ACTIONS[:read_all]

      client.gets.should eq(Magnetite::Protocol.stringify(ten_ones))

      # last test = no cleanup? 😂
      client.close
    end

  end

end
