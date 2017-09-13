SPECIAL_SIGNS = [',', '[', ']', '&', ';', '\n', ':']

def new_encode(obj : String)
  String.build do |str|
    obj.each_char do |c|
      new_c = c
      {% for char,index in SPECIAL_SIGNS %}
        if c == {{char}}
          new_c = "&{{index}};"
        end
      {% end %}
      str << new_c
    end
  end
end

def old_encode(obj : String)
  out = obj.clone
  SPECIAL_SIGNS.each_with_index do |v,i|
    # replace v with "\*\#{i} " to not replace & and ; over and over
    out = out.gsub(v, "\\*\\#{i} ")
  end

  out.gsub(/\\\*\\(?<n>[0-9]) /, "&\\k<n>;")
end

def new_decode(obj : String)
  size = obj.size
  skip_next = 0

  String.build do |str|
    obj.each_char_with_index do |c, i|
      new_c = c
      if skip_next > 0
        skip_next = skip_next -1
        next
      end
      if size >= i+3
        {% for char,index in SPECIAL_SIGNS %}
          if c == '&' && obj[i+1] == '{{index}}' && obj[i+2] == ';'
            new_c = {{char}}
            skip_next = 2
          end
        {% end %}
      end
      str << new_c
    end
  end
end

def old_decode(obj : String)
  out = obj.clone
  SPECIAL_SIGNS.each_with_index do |v,i|
    # replace &#{i}; with #{v}
    out = out.gsub("&#{i};", v)
  end

  out
end

str = "[[1,2,3,4] : Array]"
encoded_str = new_encode str

require "benchmark"

puts "encode:"
Benchmark.ips do |x|
  x.report("old encode") { old_encode str }
  x.report("new encode") { new_encode str }
end

puts "\ndecode:"
Benchmark.ips do |x|
  x.report("old decode") { old_decode encoded_str }
  x.report("new decode") { new_decode encoded_str }
end
