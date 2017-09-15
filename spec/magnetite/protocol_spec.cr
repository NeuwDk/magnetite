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

TYPES = Magnetite::Protocol::TYPES

describe Magnetite::Protocol do

  describe ".parse" do
    it "parses nil correctly" do
      str = "[nil : #{TYPES[:nil]}]"

      parse(str).should eq([nil])
    end

    it "parses booleans correctly" do
      str = "[true : #{TYPES[:bool]}, false : #{TYPES[:bool]}]"

      parse(str).should eq([true, false])
    end

    it "parses an integer correctly" do
      str = "[55 : #{TYPES[:int]}]"

      Magnetite::Protocol.parse(str).should eq([55_i64])
    end

    it "parses a float number correctly" do
      str = "[14.55 : #{TYPES[:float]}]"

      parse(str).should eq([14.55_f64])
    end

    it "parses a string correctly" do
      to_encode = "Hej fister medister : Takker og bukker"
      encoded_str = Magnetite::Protocol.encode(to_encode)
      str = "[\"#{encoded_str}\" : #{TYPES[:string]}]"

      Magnetite::Protocol.parse(str).should eq([to_encode])
    end

    it "parses an array correctly" do
      ary = encode "[1 : #{TYPES[:int]},2 : #{TYPES[:int]},3 : #{TYPES[:int]},\"wubba lubba dup dup\":#{TYPES[:string]}]"
      str = "[#{ary}:#{TYPES[:array]}]"

      parse(str).should eq([[1,2,3,"wubba lubba dup dup"]])
    end

    it "parses types correctly" do
      str = "[#{TYPES[:nil]}:#{TYPES[:type]}]"
      parse(str).should eq([:nil])

      str = "[#{TYPES[:bool]}:#{TYPES[:type]}]"
      parse(str).should eq([:bool])

      str = "[#{TYPES[:int]}:#{TYPES[:type]}]"
      parse(str).should eq([:int])

      str = "[#{TYPES[:float]}:#{TYPES[:type]}]"
      parse(str).should eq([:float])

      str = "[#{TYPES[:string]}:#{TYPES[:type]}]"
      parse(str).should eq([:string])

      str = "[#{TYPES[:array]}:#{TYPES[:type]}]"
      parse(str).should eq([:array])
    end

  end

  describe ".stringify" do
    it "stringifies Nil correctly" do
      stringify([nil]).should eq("[:#{TYPES[:nil]}]")
    end

    it "stringifies Bools correctly" do
      stringify([true, false]).should eq("[true:#{TYPES[:bool]},false:#{TYPES[:bool]}]")
    end

    it "stringifies Ints correctly" do
      stringify([1, 2_u8, 55_i64]).should eq("[1:#{TYPES[:int]},2:#{TYPES[:int]},55:#{TYPES[:int]}]")
    end

    it "stringifies Floats correctly" do
      stringify([1.55, 2.478, 3.14_f64]).should eq("[1.55:#{TYPES[:float]},2.478:#{TYPES[:float]},3.14:#{TYPES[:float]}]")
    end

    it "takes an array of two strings and stringifies them" do
      stringify(["hej", "du"]).should eq("[\"hej\":#{TYPES[:string]},\"du\":#{TYPES[:string]}]")
    end

    it "stringifies Arrays correctly" do
      stringify([[1,2,3]]).should eq("[#{encode("[1:#{TYPES[:int]},2:#{TYPES[:int]},3:#{TYPES[:int]}]")}:#{TYPES[:array]}]")
    end

    it "works with different and mixed values" do
      stringified = "[1:#{TYPES[:int]},#{encode("[\"lorteparforhold\":#{TYPES[:string]},\"#{encode(" med på kanotur : ")}\":#{TYPES[:string]}]")}:#{TYPES[:array]},:#{TYPES[:nil]},false:#{TYPES[:bool]}]"
      stringify([1,["lorteparforhold"," med på kanotur : "], nil, false]).should eq(stringified)
    end

    it "stringifies types correctly" do
      str = "[#{TYPES[:nil]}:#{TYPES[:type]}]"
      stringify([:nil]).should eq(str)

      str = "[#{TYPES[:bool]}:#{TYPES[:type]}]"
      stringify([:bool]).should eq(str)

      str = "[#{TYPES[:int]}:#{TYPES[:type]}]"
      stringify([:int]).should eq(str)

      str = "[#{TYPES[:float]}:#{TYPES[:type]}]"
      stringify([:float]).should eq(str)

      str = "[#{TYPES[:string]}:#{TYPES[:type]}]"
      stringify([:string]).should eq(str)

      str = "[#{TYPES[:array]}:#{TYPES[:type]}]"
      stringify([:array]).should eq(str)
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
