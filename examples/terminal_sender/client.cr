require "../../src/magnetite.cr"

client = Magnetite::Client.new("localhost", 12345)

loop do
  resp = client.take ["msg", String] of Magnetite::Type
  if resp
    _, msg = resp
    puts msg
  end
end
