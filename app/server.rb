require "socket"

def echo(input)
    begin
        "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: #{input.length}\r\n\r\n#{input}"
    rescue
        "Unable to parse input for echoing"
    end 
end

def get_request_headers(request_content)
    headers = {}
    request_content.each do |item|
        break if item == "\r\n"
        header_key, header_value = item.split(":", 2)
        headers[header_key.strip] = header_value.strip if header_key && header_value
    end
    return headers
end

def parse_request_line(request_line)
    method, path, http_version = request_line.split(" ")
    return { method: method, path: path, http_version: http_version }
end

def get_user_agent(request_object)
    begin
        user_agent = request_object[:request_headers]["User-Agent"]
        "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: #{user_agent.length}\r\n\r\n#{user_agent}"
    rescue
        raise "Unable to get user agent"
    end
end 


# Driver code
server = TCPServer.new("localhost", 4221)
puts "Welcome to Ruby HTTP server"

loop do
    puts "Taking requests"
    # Accept connection
    client = server.accept

    # Read stream
    request_content = []
    while (line = client.gets)
        request_content.push(line)
        break if line.strip.empty?
    end 

    # Get request string, URL path and request param by parsing the message
    puts "Request Content: #{request_content}"
    request_object = {
        request_line: parse_request_line(request_content[0]),
        request_headers: get_request_headers(request_content[1..-1]),
        request_body: request_content.last == "\r\n" ? nil : request_content.last
    }

    puts request_object

    # Route to appropriate endpoint
    path = request_object[:request_line][:path]

    if path.start_with?("/echo")
        response = echo(path.split("/")[2])
    elsif path.start_with?("/user-agent")
        response = get_user_agent(request_object)
    else
        response = "HTTP/1.1 404 Not Found\r\n"
    end

    puts "This is what we are sending #{response}"
    client.puts response

    # Close TCP connection
    client.close
end 