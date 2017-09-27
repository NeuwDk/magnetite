module Magnetite
  class Space

    class NewTree
      @root : NewNode?

      def insert(val : Array(Type))
        return if val.empty?

        if @root.nil?
          # create new node and set it as root
          @root = NewNode.new(val)
        else
          # check if need to update existing node or create new
        end
      end

    end

  end
end
