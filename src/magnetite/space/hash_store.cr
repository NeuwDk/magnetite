module Magnetite
  class Space

    class HSpace
      getter clock = 0_u64
      @store : Hash(Type, Array(Array(Type)))

      def initialize
        @store = {} of Type => Array(Array(Type))
      end

      def insert(val : Array(Type))
        return if val.empty?

        @clock = @clock + 1

        if @store.has_key? val.first
          @store[(val.first)] << val
        else
          @store[(val.first)] = [val] of Array(Type)
        end
      end
      def <<(val : Array(Type))
        insert(val)
      end

      private def find(val : Array(Type))
        if @store.has_key? val.first
          pool = @store[(val.first)]
          out = nil
          size = val.size

          pool.each_with_index do |v,index|
            next unless size === v.size

            if find_match(size, val, v)
              out = {index, pool}
              break
            end
          end

          out
        end
      end

      private def find_match(size : Int, val : Array(Type), v : Array(Type))
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
        result = find(val)

        if result
          result[1][(result[0])]
        end
      end

      def take(val : Array(Type))
        result = find(val)

        if result
          @clock = @clock + 1

          out = result[1].delete_at(result[0])

          if result[1].empty?
            @store.delete(val.first)
          end

          out
        end
      end

      def to_a
        out = [] of Array(Type)

        @store.each do |k,v|
          out.concat v
        end

        out
      end

    end

  end
end
