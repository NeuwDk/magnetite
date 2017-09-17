require "../../src/magnetite.cr"
require "spec"

describe Magnetite::Space do
  space = Magnetite::Space.new
  empty = [] of Magnetite::Type
  tmp = [1,2,3] of Magnetite::Type

  describe "#write" do
    it "writes an array to the space" do
      space.write(tmp)

      space.read_all.should eq([tmp])

      #cleanup
      space.take(tmp)
      space.read_all.should eq(empty)
    end

  end

  describe "#take" do
    it "removes an array from the space" do
      space.read_all.should eq(empty)

      #setup
      space.write(tmp)
      space.read_all.should eq([tmp])

      space.take(tmp)
      space.read_all.should eq(empty)
    end

    it "can get an array using nil as a wildcard" do
      space.read_all.should eq(empty)

      space.write(tmp)
      space.take([1,:nil,3] of Magnetite::Type).should eq(tmp)
    end

    it "can get an array using a type as a selector" do
      space.read_all.should eq(empty)

      space.write(tmp)
      space.write([1,"2",3] of Magnetite::Type)

      space.take([1,:string,3]).should eq([1,"2",3])
      space.take([1,:int,3]).should eq([1,2,3])
    end

    it "works with all supported types" do
      space.write([false] of Magnetite::Type)
      space.take([:bool]).should eq([false])

      space.write([13] of Magnetite::Type)
      space.take([:int]).should eq([13])

      space.write([3.14] of Magnetite::Type)
      space.take([:float]).should eq([3.14])

      space.write(["s"] of Magnetite::Type)
      space.take([:string]).should eq(["s"])

      space.write([[1] of Magnetite::Type] of Magnetite::Type)
      space.take([:array]).should eq([[1]])
    end

    it "works with nested wildcards in arrays" do
      space.write([1,["s", 3.14] of Magnetite::Type] of Magnetite::Type)
      space.take([:int, [:string, :float]]).should eq([1, ["s", 3.14]])
    end

  end

  describe "#read" do
    # since the same search alg is used in read and take, I won't repeat tests

    it "gets an array without removing it from the space" do
      space.read_all.should eq(empty)

      space.write(tmp)
      space.read(tmp).should eq(tmp)

      space.read_all.should eq([tmp])

      #cleanup
      space.take(tmp)
    end

  end

  describe "#read_all" do
    it "reads everything in the space" do
      array = [] of Magnetite::Type

      space.read_all.should eq(empty)

      10.times do
        space.write tmp
        array << tmp
      end

      space.read_all.should eq(array)

      #cleanup omitted as it's last test
    end

  end

end
