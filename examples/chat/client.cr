require "../../src/magnetite.cr"

puts "Username:"
username = gets

spawn do
  begin
    client = Magnetite::Client.new("localhost", 12345)
    # receive messages
    _, latest = client.read ["latest", Int]

    puts ""
    puts "Welcome #{username}"
    puts ""

    loop do
      _, _, msg = client.read ["msg", latest, String]
      puts msg
      latest = latest + 1 if latest.is_a? Int
    end

  rescue
    puts "server dead"
    exit
  end
end

spawn do
  begin
    client = Magnetite::Client.new("localhost", 12345)
    # send messages
    loop do
      msg = gets

      _, latest = client.take ["latest", Int]
      client.write ["msg", latest, "#{username}: #{msg}"]

      latest = latest + 1 if latest.is_a? Int
      client.write ["latest", latest]
    end

  rescue
    puts "server dead"
    exit
  end
end

sleep
