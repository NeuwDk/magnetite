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
      str = encode "[nil : Nil]"

      parse(str).should eq([nil])
    end

    it "parses booleans correctly" do
      str = encode "[true : Bool, false : Bool]"

      parse(str).should eq([true, false])
    end

    it "parses an integer correctly" do
      str = Magnetite::Protocol.encode "[55 : Int]"

      Magnetite::Protocol.parse(str).should eq([55_i64])
    end

    it "parses a float number correctly" do
      str = encode "[14.55 : Float]"

      parse(str).should eq([14.55_f64])
    end

    it "parses a string correctly" do
      to_encode = "Hej fister medister : Takker og bukker"
      encoded_str = Magnetite::Protocol.encode(to_encode)
      str = Magnetite::Protocol.encode "[\"#{encoded_str}\" : String]"

      Magnetite::Protocol.parse(str).should eq([to_encode])
    end

    it "parses an array correctly" do
      ary = encode "[1 : Int,2 : Int,3 : Int]"
      str = encode "[#{ary} : Array]"

      parse(str).should eq([[1,2,3]])
    end

  end

  describe ".stringify" do
    it "takes an array of two strings and stringifies them" do
      stringify(["hej", "du"]).should eq("[\"hej\":String, \"du\":String]")
    end

  end

  describe ".encode" do
    it "encodes ',' to &0;" do
      Magnetite::Protocol.encode(",").should eq("&0;")
    end

    it "encodes '[' to &1;" do
      Magnetite::Protocol.encode("[").should eq("&1;")
    end

    it "encodes ']' to &2;" do
      Magnetite::Protocol.encode("]").should eq("&2;")
    end

    it "encodes '&' to &3;" do
      Magnetite::Protocol.encode("&").should eq("&3;")
    end

    it "encodes ';' to &4;" do
      Magnetite::Protocol.encode(";").should eq("&4;")
    end

    it "encodes '\\n' to &5;" do
      Magnetite::Protocol.encode("\n").should eq("&5;")
    end

    it "encodes ':' to &6;" do
      Magnetite::Protocol.encode(":").should eq("&6;")
    end
  end

  describe ".decode" do
    it "decodes &0; to ','" do
      Magnetite::Protocol.decode("&0;").should eq(",")
    end

    it "decodes &1; to '['" do
      Magnetite::Protocol.decode("&1;").should eq("[")
    end

    it "decodes &2; to ']'" do
      Magnetite::Protocol.decode("&2;").should eq("]")
    end

    it "decodes &3; to '&'" do
      Magnetite::Protocol.decode("&3;").should eq("&")
    end

    it "decodes &4; to ';'" do
      Magnetite::Protocol.decode("&4;").should eq(";")
    end

    it "decodes &5; to '\\n'" do
      Magnetite::Protocol.decode("&5;").should eq("\n")
    end

    it "decodes &6; to ':'" do
      Magnetite::Protocol.decode("&6;").should eq(":")
    end

  end

  describe "integration between .encode and .decode" do
    it "should return the original string when gone through both" do
      str = "[35 : Int8, \"Hej: &\" : String];"

      encoded = Magnetite::Protocol.encode(str)

      Magnetite::Protocol.decode(encoded).should eq(str)
    end
  end

end
