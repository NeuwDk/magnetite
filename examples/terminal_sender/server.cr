require "../../src/magnetite.cr"

server = Magnetite::Server.new("localhost", 12345)
client = Magnetite::Client.new("localhost", 12345)

loop do
  msg = gets
  client.write ["msg", msg] of Magnetite::Type
end
