if (SERVER) then
    function rkk_shttp:Post(fUri, fData, fHeaders, fOptions)
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

    function get_http_test()
        local status, code, headers, body = rkk_shttp:Head("https://rokki-backups.website.yandexcloud.net/rokki_cloud.zip", nil, {maxSize = 157286400})
        print(status, code)
        PrintTable(headers)
        if (body) then file.Write("response.txt", body) end
    end
end