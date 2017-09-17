require "socket"
require "./magnetite/*"

module Magnetite

  private alias Ints = Int8 | Int16 | Int32 | Int64 | UInt8 | UInt16 | UInt32 | UInt64
  # Symbols represent types for when looking for a value of certain type
  private alias Types = Nil.class | Bool.class | Int.class | Float.class | String.class | Array.class
  alias Type = Nil | Bool | Ints | Float64 | String | Array(Type) | Symbol | Types

end
