if (SERVER) then
    function shttp:Head(fUri, fHeaders, fOptions)
        local method = "HEAD"
        fOptions = fOptions or {}
        fOptions["redirect"] = fOptions["redirect"] or 6
        local socket = self.fnc:httpSend(method, fUri, fHeaders, nil, fOptions)
        if socket == false then return false end
        local status, code, headers, body = self.fnc:httpHeadRead(socket)
        local rdrcode = self.fnc:redirectCheck(code)
        if (rdrcode != 0 and fOptions["redirect"] != 0) then
            return self:Redirecter(method, rdrcode, nil, fHeaders, headers, fOptions)
        else
            return status, code, headers
        end
    end
end