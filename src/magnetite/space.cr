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
        sleep_time = 0.008
        clock = @space.clock

        spawn do
          loop do
            if clock === @space.clock
              sleep(sleep_time)
              next
            end
            res = @space.{{ name.id }}(array)

            if res
              ch.send res
              break
            end

            clock = @space.clock
            sleep(sleep_time)
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
