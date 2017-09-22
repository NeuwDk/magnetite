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

      def to_a : Array(Array(Type))
        out = [] of Array(Type)
        nodel = left # node left
        noder = right # node right

        if nodel
          nodel.to_a.each do |v|
            out << v
          end
        end

        child = @children
        if child
          parr = child.to_a.each do |arr|
            out << arr.insert(0, @value)
          end
        else
          out << [@value] of Type
        end

        if noder
          noder.to_a.each do |v|
            out << v
          end
        end

        out
      end

      def find(type : Array(type))
        if x[0].is_a? Symbol
          # find by type
        else
          # find by value
        end
      end

    end

  end
end
