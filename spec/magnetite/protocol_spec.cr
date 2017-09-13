require "../../src/magnetite/protocol.cr"

def encode(str : String)
  Magnetite::Protocol.encode(str)
end
def decode(str : String)
  Magnetite::Protocol.decode(str)
end
def parse(str : String)
  Magnetite::Protocol.parse(str)
end
def stringify(obj : Array(Magnetite::Type))
  Magnetite::Protocol.stringify(obj)
end


describe Magnetite::Protocol do

  describe ".parse" do
    it "parses nil correctly" do
      str = "[nil : Nil]"

      parse(str).should eq([nil])
    end

    it "parses booleans correctly" do
      str = "[true : Bool, false : Bool]"

      parse(str).should eq([true, false])
    end

    it "parses an integer correctly" do
      str = "[55 : Int]"

      Magnetite::Protocol.parse(str).should eq([55_i64])
    end

    it "parses a float number correctly" do
      str = "[14.55 : Float]"

      parse(str).should eq([14.55_f64])
    end

    it "parses a string correctly" do
      to_encode = "Hej fister medister : Takker og bukker"
      encoded_str = Magnetite::Protocol.encode(to_encode)
      str = "[\"#{encoded_str}\" : String]"

      Magnetite::Protocol.parse(str).should eq([to_encode])
    end

    it "parses an array correctly" do
      ary = encode "[1 : Int,2 : Int,3 : Int,\"wubba lubba dup dup\":String]"
      str = "[#{ary}:Array]"

      parse(str).should eq([[1,2,3,"wubba lubba dup dup"]])
    end

  end

  describe ".stringify" do
    it "stringifies Nil correctly" do
      stringify([nil]).should eq("[nil:Nil]")
    end

    it "stringifies Bools correctly" do
      stringify([true, false]).should eq("[true:Bool,false:Bool]")
    end

    it "stringifies Ints correctly" do
      stringify([1, 2_u8, 55_i64]).should eq("[1:Int,2:Int,55:Int]")
    end

    it "stringifies Floats correctly" do
      stringify([1.55, 2.478, 3.14_f64]).should eq("[1.55:Float,2.478:Float,3.14:Float]")
    end

    it "takes an array of two strings and stringifies them" do
      stringify(["hej", "du"]).should eq("[\"hej\":String,\"du\":String]")
    end

    it "stringifies Arrays correctly" do
      stringify([[1,2,3]]).should eq("[#{encode("[1:Int,2:Int,3:Int]")}:Array]")
    end

    it "works with different and mixed values" do
      stringified = "[1:Int,#{encode("[\"lorteparforhold\":String,\"#{encode(" med på kanotur : ")}\":String]")}:Array,nil:Nil,false:Bool]"
      stringify([1,["lorteparforhold"," med på kanotur : "], nil, false]).should eq(stringified)
    end

  end

  describe "integration between .stringify and .parse" do
    it "should return the original array after the roundtrip" do
      ary = [1,2,3.14, "hej", ["musse stille"], false, nil]

      stringified = stringify(ary)

      parse(stringified).should eq(ary)
    end

  end

  describe ".encode" do
    {% for char,index in Magnetite::Protocol::SPECIAL_SIGNS %}
      it "encodes {{char}} to &{{index}};" do
        encode("{{char.id}}").should eq("&{{index}};")
      end
    {% end %}
  end

  describe ".decode" do
    {% for char,index in Magnetite::Protocol::SPECIAL_SIGNS %}
      it "decodes &{{index}}; to {{char}}" do
        decode("&{{index}};").should eq("{{char.id}}")
      end
    {% end %}
  end

  describe "integration between .encode and .decode" do
    it "should return the original string when gone through both" do
      str = "[35 : Int8, \"Hej: &\" : String];"

      encoded = Magnetite::Protocol.encode(str)

      Magnetite::Protocol.decode(encoded).should eq(str)
    end
  end

end
