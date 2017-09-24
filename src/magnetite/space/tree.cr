module Magnetite
  class Space

    class Tree
      getter size : Int32 = 0, root : Node? = nil

      def insert(x : Array(Type))
        #puts "#"*90
        #puts x

        if @root.nil?
          #puts "root nil"
          @root = Node.new(x)
        else
          val = x.shift
          key = val.hash
          p = @root # p for parent (to insert under)

          loop do
            #puts "key: #{key}, p: #{p.inspect}"
            if p.nil?
              break
            elsif key == p.key
              #puts "straight on"
              p.another_instance(x.size)
              if k = x.shift?
                key = k.hash
                pc = p.children
                if pc.nil?
                  child = Tree.new
                  child.insert(x.insert(0,k))
                  p.children = child
                  break
                else
                  p = pc.root
                  next
                end
              else
                #puts "here?? #{caller}"
                break
              end
            elsif key > p.key
              #puts "right"
              if p.right.nil?
                p.right = Node.new(x.insert(0,val))
                break
              else
                p = p.right
                next
              end
            else
              #puts "left"
              if p.left.nil?
                p.left = Node.new(x.insert(0,val))
                break
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

      def to_a
        node = @root
        if node
          node.to_a
        else
          [] of Array(Type)
        end
      end

      def find(x : Array(Type))
        node = @root
        out = [] of Type
        size = x.size - 1

        x.each do |val|
          node = node.find(val,size) if node
          if node
            out << node.value
            size = size - 1
          end
        end

        out
      end

    end

  end
end
