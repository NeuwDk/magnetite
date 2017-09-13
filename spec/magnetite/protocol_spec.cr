describe Magnetite::Protocol do

  describe ".parse" do
    it "parses a string correctly" do
      encoded_str = Magnetite::Protocol.encode("Hej fister medister : Takker og bukker")
      str = Magnetite::Protocol.encode "[\"#{encoded_str}\" : String]"

      Magnetite::Protocol.parse(str).should eq([encoded_str])
    end

  end

  describe ".stringify" do
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
