SYM = {:nil => "n", :bool => "b", :int => "i", :float => "f", :string => "s", :array => "a", :type => "t"}

TYPE = {Nil => "n", Bool => "b", Int => "i", Float => "f", String => "s", Array => "a", :type => "t"}

puts "get :float from SYM: #{SYM[:float]}"
puts "get Float from TYPE: #{TYPE[Float]}"
puts "get :float from SYM compile-time: #{ {{SYM[:float]}} }"
puts "get Float from TYPE compile-time: #{ {{TYPE[Float]}} }"

require "benchmark"

Benchmark.ips do |x|
  x.report("get from SYM") { SYM[:string] }
  x.report("get from TYPE") { TYPE[String] }
end

Benchmark.ips do |x|
  x.report("compiletime SYM") { {{SYM[:string]}} }
  x.report("compiletime TYPE") { {{TYPE[String]}} }
end
