module Magnetite

  class Space

    def initialize
      @space = [] of Type
      @mutex = Mutex.new
    end

    def write(array : Array(Type))
      @mutex.synchronize do
        @space << array
      end
    end

    def take(array : Array(Type))
      # use mutex when deleting from @space
      array
    end

    def read(array : Array(Type))
      array
    end

    def read_all
      @space
    end

  end

end
