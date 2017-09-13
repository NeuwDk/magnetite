require "socket"
require "./magnetite/*"

module Magnetite

  alias Ints = Int8 | Int16 | Int32 | Int64 | UInt8 | UInt16 | UInt32 | UInt64
  alias Type = Nil | Bool | Ints | Float64 | String | Array(Type)

end
