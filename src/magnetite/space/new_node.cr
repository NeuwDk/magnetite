module Magnetite
  class Space

    RED = true
    BLACK = false

    class NewNode
      getter children : Array(Array(Type)), id : Int64
      property right : NewNode?, left : NewNode?, parent : NewNode?, colour = RED

      def initialize(val : Array(Type))
        @children = [val]
        @id = val.first.hash.to_i64
      end

      def add(val : Array(Type))
        @children << val
      end

      def delete_at(i : Int)
        @children.delete_at(i)
      end

      def to_a
        out = [] of Type

        r = right
        l = left

        out.concat(l.to_a) if l
        out.concat(children)
        out.concat(r.to_a) if r

        out
      end

    end

  end
end
