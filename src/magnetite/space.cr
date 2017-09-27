require "./space/*"

module Magnetite

  # Space where everything is saved.
  #
  # Still needs to be able to use nil as a wildcard to get anything
  # and types to get a value of that type
  class Space

    def initialize
      @space = Tree.new
    end

    def write(array : Array(Type))
      @space << array.dup
    end

    def take(array : Array(Type))
      #@space.shift?

      @space.take(array) || [] of Type
    end

    def read(array : Array(Type))
      @space.find(array) || [] of Type
    end

    def read_all
      @space.to_a
    end

  end

end
