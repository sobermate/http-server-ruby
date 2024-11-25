require "socket"

server = TCPServer.new("localhost", 4221)
puts "Welcome to Ruby HTTP server"

loop do
    puts "Taking requests"
    client = server.accept
    message = client.gets
    request, _ = message.split("\r\n")
    method, path, version = request.split(" ")
    response = ""
    if path.start_with?("/echo/")
        begin
            _, resource, req_param = path.split("/")
            response = "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: #{req_param.length}\r\n\r\n#{req_param}"
        rescue
            response = "HTTP/1.1 500 Internal Server Error\r\n"
        end
    end
    puts "This is what we are sending #{response}"
    client.puts response
    client.close
end 