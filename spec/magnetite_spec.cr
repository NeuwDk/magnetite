require "./spec_helper"

describe Magnetite do

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
        client << "ping\n"
        client.gets.should eq("pong")
        client.close
      end

    end

    describe "#start" do
      it "returns false as it sohuld already be started" do
        server.start.should eq(false)
      end
    end

  end

  describe Magnetite::Client do
  end

end
