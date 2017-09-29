require "../../src/magnetite.cr"

begin
  client = Magnetite::Client.new("localhost", 12345)

  loop do
    resp = client.take ["msg", String] of Magnetite::Type
    if resp
      _, msg = resp
      puts msg
      sleep 1
    end
  end
rescue
  puts "server dead"
end
