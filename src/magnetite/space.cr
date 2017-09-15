module Magnetite

  # Space where everything is saved.
  #
  # Still needs to be able to use nil as a wildcard to get anything
  # and types to get a value of that type
  #
  # Ideally I want to rewrite this to use a binary tree to search faster
  class Space

    def initialize
      @space = [] of Array(Type)
      @mutex = Mutex.new
    end

    def write(array : Array(Type))
      @mutex.synchronize do
        @space << array
      end
      true
    end
    def write(*tuple)
      write(tuple_to_array(tuple))
    end

    def take(array : Array(Type)) : Array(Type)
      # use mutex when deleting from @space
      id = find(array)

      @mutex.lock
      if @space[id]?
        out = @space.delete_at(id)
        @mutex.unlock
        out
      else
        @mutex.unlock
        take(array)
      end
    end
    def take(*tuple)
      take(tuple_to_array(tuple))
    end

    def read(array : Array(Type))
      id = find(array)

      out = nil
      @mutex.synchronize do
        out = @space[id]?
      end

      out || read(array)
    end
    def read(*tuple)
      read(tuple_to_array(tuple))
    end

    def read_all
      @space
    end

    private def find(array : Array(Type))
      output = Channel(Int32).new

      spawn do
        @space.each_with_index do |v,i|
          if v == array
            output.send i
            break
          end
        end
        Fiber.yield
      end

      output.receive
    end

    def tuple_to_array(tuple)
      array = [] of Type
      tuple.each { |v| array.push(v) }
    end

  end

end
