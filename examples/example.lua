if (SERVER) then
    -- GET request
    print(shttp:Get("https://www.google.com/"))
    -- HTTP/1.1 200 OK  200   table: 0x240ed6f8   <!doctype html>...

    -- POST request
    print(shttp:Post("https://www.google.com/"), {data = "somedata"})
    -- HTTP/1.1 405 Method Not Allowed  405   table: 0x240ed6f8   <!doctype html>...

    -- HEAD request
    print(shttp:Head("https://www.google.com/"))
    -- HTTP/1.1 200 OK  200   table: 0x240ed6f8

    -- PUT request
    print(shttp:Put("https://www.google.com/", "This is my data!"))
    -- HTTP/1.1 405 Method Not Allowed  405   table: 0x240ed6f8   

    -- DELETE request
    print(shttp:Delete("https://www.google.com/"))
    -- HTTP/1.1 405 Method Not Allowed  405   table: 0x240ed6f8   
end