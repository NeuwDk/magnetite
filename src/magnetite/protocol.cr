module Magnetite

  # Protocol that does the work between the sockets
  #
  # it really is what makes it possible to send objects from one place to the other
  #
  # might need some optimizations in term of the type definition on the strings sent
  # over the wire. Instead of ":Array" ":a" might be sufficient. But for now it's
  # not to be used in prod and therefor readability was a priority
  module Protocol
    extend self

    SPECIAL_SIGNS = [':', ',', '&'] # [',', '[', ']', '&', ';', '\n', ':']
    ACTIONS = {:take => "t", :write => "w", :read => "r", :read_all => "ra", :accept => "a"}
    TYPES = {:nil => "n", :bool => "b", :int => "i", :float => "f", :string => "s", :array => "a"}

    # parses a String and turns it into an array
    def parse(msg : String)
      tuple = [] of Type

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
            tuple << parse(decode(value))
          end
        end
      end

      tuple
    end

    # turns your array into a string to be sent over the socket
    #
    #
    def stringify(array : Array(Type))
      String.build do |str|
        str << "["

        array.each_with_index do |obj, i|
          if i > 0
            str << ','
          end

          case obj
          when Nil
            str << "nil:Nil"
          when Bool
            str << "true" if obj
            str << "false" unless obj
            str << ":Bool"
          when Int
            obj.to_s(str)
            str << ":Int"
          when Float
            obj.to_s(str)
            str << ":Float"
          when String
            str << "\""
            str << encode(obj)
            str << "\":String"
          when Array
            str << encode(stringify(obj))
            str << ":Array"
          end
        end

        str << ']'
      end
    end

    # encodes a string to send over the socket
    def encode(obj : String)
      String.build do |str|
        obj.each_char do |c|
          new_c = c
          {% for char,index in SPECIAL_SIGNS %}
            if c == {{char}}
              new_c = "&{{index}};"
            end
          {% end %}
          str << new_c
        end
      end
    end

    # decodes a string received from socket
    def decode(obj : String)
      size = obj.size
      skip_next = 0

      String.build do |str|
        obj.each_char_with_index do |c, i|
          if skip_next > 0
            skip_next = skip_next -1
            next
          end
          if size >= i+3 && c == '&' && obj[i+2] == ';'
            {% for char,index in SPECIAL_SIGNS %}
              if obj[i+1] == '{{index}}'
                str << {{char}}
                skip_next = 2
                next
              end
            {% end %}
          end
          str << c
        end
      end
    end

  end

end
