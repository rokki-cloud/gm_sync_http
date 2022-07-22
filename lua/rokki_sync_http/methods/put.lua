if (SERVER) then
    -- This module has not been tested!
    function rkk_shttp:Put(fUri, fData, fHeaders, fOptions)
        local method = "PUT"
        fOptions = fOptions or {}
        local socket = self.fnc:httpSend(method, fUri, fHeaders, fData, fOptions)
        if socket == false then return false end
        local status, code, headers = self.fnc:httpHeadRead(socket)
        return status, code, headers
    end
end