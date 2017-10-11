require "../../src/magnetite.cr"

Magnetite::CONFIG[:auth] = true
Magnetite::CONFIG[:auth_pass] = "Very secret secret"

HOST = "localhost"
PORT = 12345
