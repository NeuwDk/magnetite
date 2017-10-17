# Magnetite

A tuplespace like software for distributed/interprocess crystal programming

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  magnetite:
    github: neuwdk/magnetite
```

## Usage

### Important methods

#### write
This method is used to write to the "space".
It takes an array of values and saves them on the server.

#### read
This method is used to read from the "space".
It takes an array of values and wildcards and finds a match on the server.
It doesn't return before a match is found.

#### take
This method is the same a read, except that it removes the matching array from the server.

#### read\_all
This method reads all the arrays on the server. It responds immediately, even if the space is empty.


### The server process
```crystal
require "magnetite"

server = Magnetite::Server.new("localhost", 12345)
space = server.space

sleep
```

With the space variable you get the same access as with the client.
This is nice if you need to setup some initial values, like a latest action identifier.
If you don't sleep as the last thing, the process will just close and the server will therefor also close.

### The client process
```crystal
require "magnetite"

begin
  client = Magnetite::Client.new("localhost", 12345)

  # do what needs doing here
rescue
  # no server or server down
end
```

In `examples` folder there are a few examples that show how to use this library in a few scenarios

#### Note
The first value in the array is the identifier. You can therefor not use wildcards to find those.
They have to be the exact value that you're searching for.

## Development

TODO: Write development instructions here

### To-dos
* Optional SSL on the socket communications
* Optional persistence to a file

## Contributing

1. Fork it ( https://github.com/neuwdk/magnetite/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [neuwdk](https://github.com/neuwdk) Daniel Neumann - creator, maintainer
