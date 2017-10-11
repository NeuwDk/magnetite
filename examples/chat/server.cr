require "../../src/magnetite.cr"

server = Magnetite::Server.new("localhost", 12345)
client = server.space

client.write ["latest", 0] of Magnetite::Type

def delete_msg(client, id : Int)
  spawn do
    sleep 5
    client.take ["msg", id, String]
  end
end

spawn do
  latest = 0
  loop do
    _, _, msg = client.read ["msg", latest, String]
    puts "(#{latest}) #{msg}"

    delete_msg(client, latest)

    latest = latest + 1
  end
end

sleep
