module Magnetite
  class Space

    class Node
      property left : Node?, right : Node?, children : Tree?
      getter key : Int32, value : Type, depth : Int32, type : Symbol

      def initialize(array : Array(Type))
        val = array.shift

        @key = val.hash
        @value = val
        @depth = array.size
        @instances = 1

        if array.size > 0
          children = Tree.new
          children.insert << array
        end

        type = val.class

        case type
        when Nil
          @type = :nil
        when Bool
          @type = :bool
        when Int
          @type = :int
        when Float
          @type = :float
        when String
          @type = :string
        when Array
          @type = :array
        else
          raise "Type not supported"
        end
      end

      def another_instance
        @instances = @instances + 1
      end

    end

  end
end
