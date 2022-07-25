if (SERVER) then
    -- You can change any HTTP header except User-Agent
    local headers = {}
    headers["Accept"] = "text/plain"
    headers["Accept-Language"] = "ru"
    headers["Authorization"] = "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ=="
    headers["Referer"] = "http://www.example.com/"
    local status, code, headers, body = shttp:Get("http://example.com/", headers)
    print(status, code) -- HTTP/1.1 200 OK  200
end