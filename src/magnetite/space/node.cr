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
          out.concat(nodel.to_a)
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
          out.concat(noder.to_a)
        end

        out
      end

      def find(val : Type, size : Int32)
        search_for = @value
        if val.is_a? Symbol
          search_for = @type
          if val === :nil
            search_for = :nil
          end
        end

        if search_for == val && depth.find {|i| i === size}
          path = [] of Bool
          return {path, self} # false = left, true = right
        end

        nodel = left
        noder = right
        if nodel
          if ret = nodel.find(val, size) # ret : return value
            return {ret[0].push(false), ret[1]}
          end
        end
        if noder
          if ret = noder.find(val, size)
            return {ret[0].push(true), ret[1]}
          end
        end
      end

      def kill_me
        puts "Killing: #{self.inspect}"
      end

    end

  end
end
