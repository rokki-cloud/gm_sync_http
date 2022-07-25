if (SERVER) then
    -- form urlencoded
    local postdata = {key = "value", ping = "pong"}
    local status, code, headers, body = shttp:Post("http://localhost:8080/handler.php", postdata)
    print(status, code) -- HTTP/1.1 200 OK

    local postdata = "key=value&ping=pong"
    local status, code, headers, body = shttp:Post("http://localhost:8080/handler.php", postdata)
    print(status, code) -- HTTP/1.1 200 OK

    -- json
    local postdata = util.TableToJSON({key = "value", ping = "pong"})
    local headers = {}
    headers["Content-Type"] = "application/json"
    local status, code, headers, body = shttp:Post("http://localhost:8080/handler.php", postdata)
    print(status, code) -- HTTP/1.1 200 OK
end