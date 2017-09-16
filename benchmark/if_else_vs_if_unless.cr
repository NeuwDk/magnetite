require "benchmark"

def bool
  rand(1) > 0
end

def work
  "test"
end

Benchmark.ips do |x|
  x.report("if..else") do
    obj = bool
    if obj
      work
    else
      work
    end
  end

  x.report("if and unless") do
    obj = bool
    work if obj
    work unless obj
  end
end
