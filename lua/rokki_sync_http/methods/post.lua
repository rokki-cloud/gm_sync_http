if (SERVER) then
    function shttp:Post(fUri, fData, fHeaders, fOptions)
        local method = "POST"
        fOptions = fOptions or {}
        fOptions["redirect"] = fOptions["redirect"] or 6
        local socket = self.fnc:httpSend(method, fUri, fHeaders, fData, fOptions)
        if socket == false then return false end
        local status, code, headers, body = self.fnc:httpRead(socket)
        local rdrcode = self.fnc:redirectCheck(code)
        if (rdrcode != 0 and fOptions["redirect"] != 0) then
            return self:Redirecter(method, rdrcode, fData, fHeaders, headers, fOptions)
        else
            return status, code, headers, body
        end
    end
end