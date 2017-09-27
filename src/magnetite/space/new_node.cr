module Magnetite
  class Space

    class NewNode
      getter children : Array(Array(Type)), right : NewNode?, left : NewNode?, id : Int64

      def initialize(val : Array(Type))
        @children = [val]
        @id = val.first.hash
      end

    end

  end
end
