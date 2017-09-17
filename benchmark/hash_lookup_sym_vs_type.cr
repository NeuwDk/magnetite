SYM = {:nil => "n", :bool => "b", :int => "i", :float => "f", :string => "s", :array => "a", :type => "t"}

TYPE = {Nil => "n", Bool => "b", Int => "i", Float => "f", String => "s", Array => "a", :type => "t"}

BOTH = {
  :nil => "n", :bool => "b", :int => "i", :float => "f", :string => "s", :array => "a", :type => "t",
  Nil => "n", Bool => "b", Int => "i", Float => "f", String => "s", Array => "a"
}

puts "get :float from SYM: #{SYM[:float]}"
puts "get Float from TYPE: #{TYPE[Float]}"
puts "get :float from SYM compile-time: #{ {{SYM[:float]}} }"
puts "get Float from TYPE compile-time: #{ {{TYPE[Float]}} }"
puts "get :float from BOTH compile-time: #{ {{BOTH[:float]}} }"

require "benchmark"

Benchmark.ips do |x|
  x.report("get from SYM") { SYM[:string] }
  x.report("get from TYPE") { TYPE[String] }
  x.report("get sym from BOTH") { BOTH[:string] }
  x.report("get type from BOTH") { BOTH[String] }
end

Benchmark.ips do |x|
  x.report("compiletime SYM") { {{SYM[:string]}} }
  x.report("compiletime TYPE") { {{TYPE[String]}} }
  x.report("compiletime sym from BOTH") { {{BOTH[:string]}} }
end
