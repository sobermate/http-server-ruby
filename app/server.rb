require "socket"

server = TCPServer.new("localhost", 4221)
puts "Welcome to Ruby HTTP server"

loop do
    puts "Taking requests"
    client = server.accept
    request = client.gets
    request_components = request.split(" ")
    response = ""
    if request_components[1] != "/"
        response = "HTTP/1.1 404 Not Found\r\n\r\n"
    else 
        response = "HTTP/1.1 200 OK\r\n\r\n"
    end
    puts "This is what we are sending #{response}"
    client.puts response
    client.close
end 