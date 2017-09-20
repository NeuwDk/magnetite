describe Magnetite::Client do
  server = Magnetite::Server.new("localhost", 12347)
  client = Magnetite::Client.new("localhost", 12347)
  empty = [] of Magnetite::Type

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

      arr = [] of Int32
      10.times do |i|
        client.write [i]
        arr << i
      end

      client.read_all.should eq(arr)
    end

  end

end

