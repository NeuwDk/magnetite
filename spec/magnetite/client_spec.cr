describe Magnetite::Client do
  Magnetite::CONFIG[:auth] = true
  server = Magnetite::Server.new("localhost", 12347)
  client = Magnetite::Client.new("localhost", 12347)
  empty = [] of Magnetite::Type

  describe "#initialize" do
    it "establishes a connection with the correct pass" do
      #Magnetite::CONFIG[:auth] = true
      #client1 = Magnetite::Client.new("localhost", 12347)
      #Magnetite::CONFIG[:auth] = false

      # nothing to test, really. Setting up the client variable is sufficient
    end

    it "is rejected and raises with incorrect pass" do
      expect_raises do
        Magnetite::Client.new("localhost", 12347, "abc")
      end
    end
  end

  describe "#write" do
    it "returns true when server succesfully wrote" do
      client.write([1,2,3]).should be_true

      #cleanup
      client.take([1,2,3])
    end

  end

  describe "#take" do
    it "takes a values from the space" do
      client.read_all.should eq(empty)

      client.write [1,2,3]
      client.read_all.should eq([[1,2,3]])

      client.take [1,2,3]
      client.read_all.should eq(empty)
    end

  end

  describe "#read" do
    it "read a value from the space and doesn't remove it" do
      client.read_all.should eq(empty)

      client.write [1,2,3]
      client.read_all.should eq([[1,2,3]])

      client.read [1,2,3]
      client.read_all.should eq([[1,2,3]])

      #cleanup
      client.take [1,2,3]
    end

  end

  describe "#read_all" do
    it "reads everything it space" do
      client.read_all.should eq(empty)

      arr = [] of Array(Int32)
      10.times do |i|
        client.write [i]
        arr << [i]
      end

      client.read_all.should eq(arr)
    end

  end

end

