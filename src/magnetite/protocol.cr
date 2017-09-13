module Magnetite

  module Protocol
    extend self

    SPECIAL_SIGNS = [',', '[', ']', '&', ';', '\n']

    def parse(msg : String)
    end

    def stringify(obj)
    end

    # encodes a string to send over the socket
    #
    # __DON'T write "\*\n " in your string__
    # it will fuck everything up!
    def encode(obj : String)
      out = obj.clone
      SPECIAL_SIGNS.each_with_index do |v,i|
        # replace v with "\*\#{i} " to not replace & and ; over and over
        out = out.gsub(v, "\\*\\#{i} ")
      end

      # replace "\*\n " with "&n;"
      out.gsub(/\\\*\\(?<n>[0-9]) /, "&\\k<n>;")
    end

    # decodes a string received from socket
    def decode(obj : String)
      out = obj.clone
      SPECIAL_SIGNS.each_with_index do |v,i|
        # replace &#{i}; with #{v}
        out = out.gsub("&#{i};", v)
      end

      out
    end

  end

end
