require "./space/*"

module Magnetite

  # Space where everything is saved.
  #
  # Still needs to be able to use nil as a wildcard to get anything
  # and types to get a value of that type
  class Space

    def initialize
      @space = NewTree.new
    end

    def write(array : Array(Type))
      @space << array.dup
    end

    {% for name in ["take", "read"] %}
      def {{ name.id }}(array : Array(Type))
        ch = Channel(Array(Type)).new

        spawn do
          loop do
            res = @space.{{ name.id }}(array)

            if res
              ch.send res
              break
            end

            Fiber.yield
          end
        end

        ch.receive
      end
    {% end %}

    def read_all
      @space.to_a || [] of Type
    end

  end

end
