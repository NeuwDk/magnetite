require "../../src/magnetite.cr"

{% for operation in ["+", "-", "*", "/"] %}
  spawn do
    client = Magnetite::Client.new("localhost", 12345)

    loop do
      resp = client.take([{{operation}}, Int, Int, Int])
      _, id, a, b = resp if resp
      {% if operation == "/" %}
        if b == 0
          client.write([id, -1])
          next
        end
      {% end %}
      result = a {{ operation.id }} b if a.is_a? Int && b.is_a? Int
      puts "#{id} : #{a} {{operation.id}} #{b} = #{result}"
      client.write([id, result])
    end
  end
{% end %}

sleep
