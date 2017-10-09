require "../../src/magnetite.cr"

server = Magnetite::Server.new("localhost", 12345)
client = server.space

client.write ["latest", 0] of Magnetite::Type

spawn do
  latest = 0
  loop do
    _, _, msg = client.read ["msg", latest, :string]
    puts "(#{latest}) #{msg}"
    latest = latest + 1
  end
end

sleep
