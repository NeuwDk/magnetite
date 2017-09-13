module Magnetite

  module Protocol
    extend self

    SPECIAL_SIGNS = [',', '[', ']', '&', ';', '\n', ':']

    def parse(msg : String)
      tuple = [] of Int8

      puts "#" * 90
      puts msg

      msg = decode(msg)

      puts "Decode:"
      puts msg
      puts "msg[0]: '#{msg[0]}', msg[-1]: '#{msg[-1]}'"

      if msg[0] == '[' && msg[-1] == ']'
        msg[1, (msg.size-2)].split(",").each do |str|
          #do something with str
          value, type = str.split(" : ")
          puts "value: #{value}"
          puts "type:  #{type}"
        end
      end

      puts "#" * 90
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
          skip_next = skip_next -1
          next
        end
        if size >= i+3
          tmp = c + obj[i+1, 2]
          #puts "TMP in decode: #{tmp}"
          {% for char,index in SPECIAL_SIGNS %}
            if tmp == "&{{index}};"
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
