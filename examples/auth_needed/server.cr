require "../../src/magnetite.cr"
require "./config.cr"

server = Magnetite::Server.new(HOST, PORT)
client = server.space

puts "ready"

loop do
  _, secret = client.take ["secret", String]
  puts "Someone spilled their secret; it is #{secret}"
end
