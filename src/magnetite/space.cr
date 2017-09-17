module Magnetite

  # Space where everything is saved.
  #
  # Still needs to be able to use nil as a wildcard to get anything
  # and types to get a value of that type
  class Space

    def initialize
      @space = [] of Array(Type)
    end

    def write(array : Array(Type))
      @space << array
    end

    def take(array : Array(Type))
      @space.shift?

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
