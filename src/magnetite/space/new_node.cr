module Magnetite
  class Space

    class NewNode
      getter children : Array(Array(Type)), id : Int64
      property right : NewNode?, left : NewNode?

      def initialize(val : Array(Type))
        @children = [val]
        @id = val.first.hash.to_i64
      end

      def add(val : Array(Type))
        @children << val
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
