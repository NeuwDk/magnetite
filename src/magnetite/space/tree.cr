module Magnetite
  class Space

    class Tree
      getter size : Int32 = 0, root : Node? = nil

      def insert(x : Array(Type))
        if @root.nil?
          @root = Node.new(x)
        else
          inserted = false
          key = x.shift.hash
          p = @root # p for parent (to insert under)

          until inserted
            if key == p.key
              p.another_instance
              if key = x.shift
                key = key.hash
                if p.children.nil?
                  p.children = Tree.new
                end
                p = p.children
              else
                inserted = true
                break
              end
            elsif key > p.key
              if p.right === nil
                p.right = Node.new(x)
                inserted = true
              else
                p = p.right
                next
              end
            else
              if p.left === nil
                p.left = Node.new(x)
                inserted = true
              else
                p = p.left
              end
            end
          end

        end
      end

      def <<(x)
        insert(x)
      end

    end

  end
end
