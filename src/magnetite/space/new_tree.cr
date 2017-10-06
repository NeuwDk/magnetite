module Magnetite
  class Space

    class NewTree
      getter clock = 0_u64
      @root : NewNode?

      def insert(val : Array(Type))
        return if val.empty?

        @clock = @clock + 1

        if @root.nil?
          # create new node and set it as root
          new_node = NewNode.new(val)
          insert_repair(new_node)
          @root = new_node
        else
          # check if need to update existing node or create new
          node = find_node(val)
          id = val.first.hash

          if node && node.id === id
            node.add(val)
          elsif node
            # insert node at correct place
            new_node = NewNode.new(val)
            new_node.parent = node

            if node.id > id
              node.left = new_node
            else
              node.right = new_node
            end

            insert_repair(new_node)

            # find new root node
            root = new_node
            while r = parent(root)
              root = r
            end
            @root = root
          end
        end
      end
      def <<(val : Array(Type))
        insert(val)
      end

      # finds node, or the node that comes closest
      #
      # this is so that when inserting I don't loop over twice
      # so it requires a check if the id matches
      # `val.first.hash === find_node(val).id`
      private def find_node(val : Array(Type))
        node = @root
        if node
          id = val.first.hash

          loop do
            if node.nil?
              break
            else
              if node.id === id
                return node
              elsif node.id > id && node.left
                node = node.left
              elsif node.id < id && node.right
                node = node.right
              else
                break
              end
            end
          end

          node
        end
      end

      private def find(val : Array(Type))
        node = find_node(val)
        id = val.first.hash
        #puts "searching for #{val}, hash: #{id}"

        if node && node.id === id
          children = node.children
          out = nil
          size = val.size

          children.each_with_index do |v,index|
            next unless size === v.size

            if find_match(size, val, v)
              out = {index, node}
              break
            end
          end

          out
        end
      end

      private def find_match(size, val : Array(Type), v : Array(Type))
        match = true

        size.times do |i|
          #puts "val[#{i}] = #{val[i]} : #{val[i].class},\t\t v[#{i}] = #{v[i]} : #{v[i].class}"

          case val[i]
          when v[i]
            next
          when Symbol
            if val[i] === :nil
              next
            elsif val[i] === :bool && v[i].is_a? Bool
              next
            elsif val[i] === :int && v[i].is_a? Int
              next
            elsif val[i] === :float && v[i].is_a? Float
              next
            elsif val[i] === :string && v[i].is_a? String
              next
            elsif val[i] === :array && v[i].is_a? Array
              next
            else
              match = false
              break
            end
          when Array(Type)
            nested_val = val[i]
            nested_v = v[i]

            if nested_val.is_a? Array(Type) && nested_v.is_a? Array(Type) && nested_val.size === nested_v.size
              nested_size = nested_val.size
              nested_match = find_match(nested_size, nested_val, nested_v)
            else
              nested_match = false
            end

            if nested_match
              next
            else
              match = false
              break
            end
          else
            match = false
            break
          end
        end

        match
      end

      def read(val : Array(Type))
        out = find(val)

        if out
          out[1].children[(out[0])]
        end
      end

      def take(val : Array(Type))
        out = find(val)

        if out
          @clock = @clock + 1

          out[1].delete_at((out[0]))
        end
      end

      def to_a
        r = @root

        r.to_a if r
      end

      # self-balancing Red-black tree functionality
      private def parent(node : NewNode)
        node.parent
      end
      private def grandparent(node : NewNode)
        p = node.parent
        p.parent if p
      end
      private def sibling(node : NewNode)
        p = node.parent

        if p
          if node === p.left
            p.right
          else
            p.left
          end
        end
      end
      private def uncle(node : NewNode)
        p = parent(node)
        g = grandparent(node)

        if g && p
          sibling(p)
        end
      end
      private def rotate_left(node : NewNode)
        new_node = node.right
        if new_node
          node.right = new_node.left
          new_node.left = node
          new_node.parent = node.parent
          node.parent = new_node
          p = new_node.parent
          if p
            if p.right === node
              p.right = new_node
            else
              p.left = new_node
            end
          end
        end
      end
      private def rotate_right(node : NewNode)
        new_node = node.left
        if new_node
          node.left = new_node.right
          new_node.right = node
          new_node.parent = node.parent
          node.parent = new_node
          p = new_node.parent
          if p
            if p.right === node
              p.right = new_node
            else
              p.left = new_node
            end
          end
        end
      end
      private def insert_repair(node : NewNode)
        p = parent(node)
        u = uncle(node)
        g = grandparent(node)
        if p.nil?
          node.colour = BLACK
        elsif p.colour === BLACK
          # do nothing, all is in order
        elsif u && u.colour === RED
          p.colour = BLACK
          u.colour = BLACK
          if g
            g.colour = RED
            insert_repair(g)
          end
        else
          if g
            gl = g.left
            gr = g.right
            target = nil
            if gl && node === gl.right
              rotate_left(p)
              target = node.left
            elsif gr && node === gr.left
              rotate_right(p)
              target = node.right
            end

            if target
              tp = parent(target)
              tg = grandparent(target)
              if tp && target === tp.left
                rotate_right(tg) if tg
              else
                rotate_left(tg) if tg
              end
              tp.colour = BLACK if tp
              tg.colour = RED if tg
            end
          end
        end
      end

    end

  end
end
