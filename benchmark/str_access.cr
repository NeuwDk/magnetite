require "benchmark"

CONST = {:t => "t"}

Benchmark.ips do |x|
  x.report("lookup") { CONST[:t] }
  x.report("string literal") { {{CONST[:t]}} }
end

#         lookup 318.15M (  3.14ns) (±11.56%)  1.50× slower
# string literal 476.72M (   2.1ns) (±10.99%)       fastest
