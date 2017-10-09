require "../../src/magnetite.cr"

server = Magnetite::Server.new("localhost", 12345)
client = server.space

loop do
  msg = gets
  client.write ["msg", msg] of Magnetite::Type
end
