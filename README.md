# Rokki Lua Sync HTTP lib
Server side Library for creating synchronous HTTP requests for Garry's Mod

# Installation
Go to [the Releases page](https://github.com/rokki-git/sync_http/releases) and download the latest version of the library. Then unpack the archive using the following path:
```
the_root_folder_with_the_gmod_server/garrysmod/
```

# Lua Functions
```lua
status, code, headers, body = shttp:Post(uri, data, headers, options) -- Sends a POST request to the server

status, code, headers, body = shttp:Get(uri, headers, options) -- Sends a GET request to the server

status, code, headers = shttp:Head(uri, headers, options) -- Sends a HEAD request to the server

status, code, headers = shttp:Put(uri, data, headers, options) -- Sends a PUT request to the server

status, code, headers = shttp:Delete(uri, headers, options) -- Sends a DELETE request to the server

-- Example of the received data:
-- (string) status = "HTTP/1.1 200 OK"
-- (number) code = 200
-- (table) headers = {Connection = "Close", Content-Length = 22}
-- (string) body = "<h1>This is Body!</h1>"
```

# Examples

POST REQUEST
```lua
local uri = "http://localhost:8080/some.php" -- STRING ONLY
local postdata = {key1 = "value1", key2 = "value2"} or "key1=value1&key2=value2" -- TABLE OR STRING OR NIL
local headers = {Authorization = "Bearer"} -- TABLE OR NIL
local options = {  -- TABLE OR NIL
  "timeout" = 10000 -- 10s
  "maxSize" = 1024 -- 1024 bytes or 1 KB
  "redirect" = 6 -- Maximum number of redirects. Set it to 0 if you don't want automatic redirects.
  -- All options must be numbers
}
local status, code, headers, body = shttp:Post(uri, postdata, headers, options)
```
GET REQUEST
```lua
local uri = "https://localhost/image.jpg?size=1080" -- STRING ONLY
local headers = {Authorization = "Bearer"} -- TABLE OR NIL
local options = {  -- TABLE OR NIL
  "timeout" = 60000 -- 60s
  "maxSize" =  1024 * 1024 -- 1 MB
  "redirect" = 0 --  No redirects
}
local status, code, headers, body = shttp:Get(uri, headers, options) 
```

# Third-party modules
The [gm_bromsock](https://github.com/Bromvlieg/gm_bromsock) binary module from [Bromvlieg](https://github.com/Bromvlieg) is used
