module Magnetite

  module Protocol
    extend self

    SPECIAL_SIGNS = [',', '[', ']', '&', ';', '\n', ':']

    def parse(msg : String)
      tuple = [] of Type

      msg = decode(msg)

      if msg[0] == '[' && msg[-1] == ']'
        msg[1, (msg.size-2)].split(",").each do |str|
          value, type = str.split(":")

          value = value.lstrip.rstrip
          type = type.lstrip.rstrip

          case type
          when "Nil"
            tuple << nil
          when "Bool"
            tuple << true if value === "true"
            tuple << false if value === "false"
          when "Int"
            tuple << value.to_i64
          when "Float"
            tuple << value.to_f64
          when "String"
            tuple << decode(value[1, value.size-2])
          when "Array"
            tuple << parse(value)
          end
        end
      end

      tuple
    end

    def stringify(obj)
    end

    # encodes a string to send over the socket
    def encode(obj : String)
      out = ""

      obj.each_char do |c|
        new_c = c
        {% for char,index in SPECIAL_SIGNS %}
          if c == {{char}}
            new_c = "&{{index}};"
          end
        {% end %}
        out = out + new_c
      end

      out
    end

    # decodes a string received from socket
    def decode(obj : String)
      size = obj.size
      out = ""
      skip_next = 0

      obj.each_char_with_index do |c, i|
        new_c = c
        if skip_next > 0
          skip_next = skip_next - 1
          next
        end
        if size >= i+3
          {% for char,index in SPECIAL_SIGNS %}
            if c == '&' && obj[i+1] == '{{index}}' && obj[i+2] == ';'
              new_c = {{char}}
              skip_next = 2
            end
          {% end %}
        end
        out = out + new_c
      end

      out
    end

  end

end
