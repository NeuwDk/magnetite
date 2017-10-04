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
          @root = NewNode.new(val)
        else
          # check if need to update existing node or create new
          node = find_node(val)
          id = val.first.hash

          if node && node.id === id
            node.add(val)
          elsif node
            # insert node at correct place
            new_node = NewNode.new(val)

            if node.id > id
              node.left = new_node
            else
              node.right = new_node
            end
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

    end

  end
end
