module Magnetite
  class Space

    class Node
      property left : Node?, right : Node?, children : Tree?
      getter key : UInt64, value : Type, depth : Array(Int32), type : Symbol

      def initialize(array : Array(Type))
        array = array.dup
        val = array.shift

        @key = val.hash.to_u64
        @value = val
        @depth = [array.size]

        if array.size > 0
          child = Tree.new
          child.insert(array)
          @children = child
        end

        case val
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
        when Symbol
          @type = :type
        else
          @type = :unknown
        end
      end

      def another_instance(size)
        @depth << size
      end

    end

  end
end
