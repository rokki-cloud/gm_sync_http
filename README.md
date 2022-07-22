# Rokki Lua Sync HTTP lib
Server side Library for creating synchronous HTTP requests for Garry's Mod

# Installation


# Lua Functions
```lua
status, code, headers, body = rkk_shttp:Post(url, data, headers, options) -- Sends a POST request to the server

status, code, headers, body = rkk_shttp:GET(url, headers, options) -- Sends a GET request to the server

status, code, headers = rkk_shttp:HEAD(url, headers, options) -- Sends a HEAD request to the server

status, code, headers = rkk_shttp:PUT(url, data, headers, options) -- Sends a PUT request to the server

status, code, headers = rkk_shttp:DELETE(url, headers, options) -- Sends a DELETE request to the server

-- Example of the received data:
-- (string) status = HTTP/1.1 200 OK
-- (number) code = 200
-- (table) headers = {Connection = "Close", Content-Length = 22}
-- (string) body = "<h1>This is Body!</h1>"
```

# Examples
