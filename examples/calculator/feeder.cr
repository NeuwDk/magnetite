require "../../src/magnetite.cr"

client = Magnetite::Client.new("localhost", 12345)
id = 0
operations = ["+", "-", "*", "/"]

loop do
  operation = operations.sample
  a = Random.rand(500)
  b = Random.rand(500)

  client.write([operation, id, a, b])
  resp = client.take([id, Int])
  res = resp[1] if resp

  puts "#{id} : #{a} #{operation} #{b} = #{res}"
  id = id + 1
  sleep 0.5
end
