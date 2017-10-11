require "../../src/magnetite.cr"
require "spec"

def empty
  [] of Magnetite::Type
end
def tmp
  [1,2,3] of Magnetite::Type
end
def tmp2
  [2,1,3] of Magnetite::Type
end

describe Magnetite::Space do
  space = Magnetite::Space.new

  describe "#write" do
    it "writes an array to the space" do
      space.write(tmp)
      space.write(tmp2)

      space.read_all.should eq([tmp, tmp2])

      #cleanup
      space.take(tmp)
      space.take(tmp2)
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

      space.write(tmp)
      space.take([1,Nil,3] of Magnetite::Type).should eq(tmp)
    end

    it "can get an array using a type as a selector" do
      space.read_all.should eq(empty)

      space.write(tmp)
      space.write([1,"2",3] of Magnetite::Type)

      space.take([1,:string,3]).should eq([1,"2",3])
      space.take([1,:int,3]).should eq([1,2,3])

      space.write(tmp)
      space.write([1,"2",3] of Magnetite::Type)

      space.take([1,String,3]).should eq([1,"2",3])
      space.take([1,Int,3]).should eq(tmp)
    end

    it "works with all supported types" do
      space.write([1, false] of Magnetite::Type)
      space.take([1, :bool]).should eq([1, false])

      space.write([1, 13] of Magnetite::Type)
      space.take([1, :int]).should eq([1, 13])

      space.write([1, 3.14] of Magnetite::Type)
      space.take([1, :float]).should eq([1, 3.14])

      space.write([1, "s"] of Magnetite::Type)
      space.take([1, :string]).should eq([1, "s"])

      space.write([1, [1] of Magnetite::Type] of Magnetite::Type)
      space.take([1, :array]).should eq([1, [1]])
    end

    it "works with nested wildcards in arrays" do
      space.write([1,["s", 3.14] of Magnetite::Type] of Magnetite::Type)
      space.take([1, [:string, :float] of Magnetite::Type] of Magnetite::Type).should eq([1, ["s", 3.14]])
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

    it "reads the entire depth of the array" do
      tt = [1,2,4] of Magnetite::Type

      space.write(tmp)
      space.read(tmp).should eq(tmp)

      space.write(tt)
      space.read(tt).should eq(tt)

      #cleanup
      space.take(tmp)
      space.take(tt)
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
