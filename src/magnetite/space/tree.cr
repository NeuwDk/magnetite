module Magnetite
  class Space

    class Tree
      getter size : Int32 = 0, root : Node? = nil

      def insert(x : Array(Type))
        puts "#"*90
        puts x

        if @root.nil?
          puts "root nil"
          @root = Node.new(x)
        else
          key = x.shift.hash
          p = @root # p for parent (to insert under)

          loop do
            puts "key: #{key}, p: #{p.inspect}"
            if p.nil?
              break
            elsif key == p.key
              puts "straight on"
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
                puts "here?? #{caller}"
                break
              end
            elsif key > p.key
              puts "right"
              if p.right.nil?
                p.right = Node.new(x)
                break
              else
                p = p.right
                next
              end
            else
              puts "left"
              if p.left.nil?
                p.left = Node.new(x)
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
        out = [] of Array(Type)

        out
      end

    end

  end
end
