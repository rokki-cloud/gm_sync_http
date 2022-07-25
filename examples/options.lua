if (SERVER) then
    local options = {
        maxSize = 1024 -- The maximum size in bytes that will be allocated for incoming packets.
        -- Attention! This option does not trim the received data to the set length.
        -- This option allocates the required memory sizes for incoming packets.
        -- If the size of the received data is larger, an error about exceeding the buffer size will be thrown
        redirect = 6 -- The maximum number of redirects. Set the value to 0 to disable redirects.
    }
    local status, code, headers, body = shttp:Get("https://www.google.com/", nil, options)
end