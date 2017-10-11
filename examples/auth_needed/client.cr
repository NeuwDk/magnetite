require "../../src/magnetite.cr"
require "./config.cr"

begin
  client = Magnetite::Client.new(HOST, PORT)

  puts client.read_all

  client.write ["secret", "I'm a hobbyist"]
rescue
  puts "server dead or not authenticated"
  exit
end
