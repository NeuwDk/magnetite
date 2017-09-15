require "../../src/magnetite.cr"
require "spec"

describe Magnetite::Space do
  space = Magnetite::Space.new
  empty = [] of Magnetite::Type

  describe "#write" do
    it "writes an array to the space" do
      space.write(1,2,3)

      space.read_all.should eq([[1,2,3]])

      #cleanup
      space.take(1,2,3)
      space.read_all.should eq(empty)
    end

  end

  describe "#take" do
    it "removes an array from the space" do
      space.read_all.should eq(empty)

      #setup
      space.write(1,2,3)
      space.read_all.should eq([[1,2,3]])

      space.take(1,2,3)
      space.read_all.should eq(empty)
    end

    it "can get an array using nil as a wildcard" do
      space.read_all.should eq(empty)

      space.write(1,2,3)
      space.take(1,nil,3).should eq([1,2,3])
    end

    it "can get an array using a type as a selector" do
      space.read_all.should eq(empty)

      space.write(1,2,3)
      space.write(1,"2",3)

      space.take(1,String,3).should eq([1,"2",3])
      space.take(1,Int,3).should eq([1,2,3])
    end

  end

  describe "#read" do
  end

  describe "#read_all" do
  end

end
