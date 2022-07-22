if (SERVER) then
    -- This module has not been tested!
    function rkk_shttp:Delete(fUri, fHeaders, fOptions)
        local method = "DELETE"
        fOptions = fOptions or {}
        local socket = self.fnc:httpSend(method, fUri, fHeaders, nil, fOptions)
        if socket == false then return false end
        local status, code, headers = self.fnc:httpHeadRead(socket)
        return status, code, headers
    end
end