if (SERVER) then
    rkk_shttp.fnc = {}

    function rkk_shttp.fnc:IndexOf(fNeed, fStr)
        for i = 1, #fStr do
            if (fStr[i] == fNeed) then
                return i
            end
        end
        
        return -1
    end

    function rkk_shttp.fnc:uriDisassembly(fUri)
        local host, path, port, ssl = "", "", 80, false

        if (string.StartWith(fUri, "http://")) then
            fUri = string.Right(fUri, #fUri - 7)
        elseif (string.StartWith(fUri, "https://")) then
            fUri = string.Right(fUri, #fUri - 8)
            port = 443
            ssl = true
        end

        local pathindex = self:IndexOf("/", fUri)
        if (pathindex > -1) then
            host = string.sub(fUri, 1, pathindex - 1)
            path = string.sub(fUri, pathindex)
        else
            host = fUri
        end
        if (#path == 0) then path = "/" end

        -- Custom port checker
        local portindex = self:IndexOf(":", host)
        if (portindex > -1) then
            port = tonumber(string.sub(host, portindex + 1)) or port
            host = string.sub(host, 1, portindex - 1)
        end

        return host, path, port, ssl
    end

    function rkk_shttp.fnc:postDataConstructor(fData)
        local postdata = ""
        if istable(fData) then
            for k, v in pairs(fData) do
                postdata = postdata .. k .. "=" .. v .. "&"
            end
            
            if (#postdata > 0) then
                postdata = string.Left(postdata, #postdata - 1)
            end

            return postdata
        elseif (fData and #fData > 0) then
            return fData
        end
        return ""
    end

    function rkk_shttp.fnc:headersConstructor(fHeaders, fPostLength)
        local headers = ""
        fHeaders = fHeaders or {}
        if (fPostLength) then
            fHeaders["Content-Type"] = fHeaders["Content-Type"] or "application/x-www-form-urlencoded"
            fHeaders["Content-Length"] = fHeaders["Content-Length"] or fPostLength
        end
        fHeaders["User-Agent"] = "Rokki.in Sync HTTP/1.1 LUA lib (" .. jit.os .. " " .. jit.arch .. ")"
        fHeaders["Accept-Encoding"] = fHeaders["Accept-Encoding"] or "identity"
        fHeaders["Accept"] = fHeaders["Accept"] or "*/*"
        for k, v in pairs(fHeaders) do
            headers = headers .. k .. ": " .. v .. "\r\n"
        end
        return headers
    end

    function rkk_shttp.fnc:headersDisassembly(fHeaders)
        local headers, temp = {}, {}
        fHeaders = string.Split(fHeaders, "\r\n")
        for _, v in pairs(fHeaders) do
            if v != "" then
                temp = string.Split(v, ":")
                headers[temp[1]] = string.Trim(table.concat(temp, ":", 2))
            end
        end

        return headers
    end

    function rkk_shttp.fnc:statusDisassembly(fStatus)
        return tonumber(string.sub(string.Right(fStatus, #fStatus - 9), 1, 3)) or 0
    end

    function rkk_shttp.fnc:contentRead(socket, fHeaders)
        local bodypack
        local body = ""
        if (fHeaders["Content-Length"]) then
			bodypack = socket:Receive(tonumber(fHeaders["Content-Length"]))
			body = bodypack:ReadStringAll()
		elseif (fHeaders["Transfer-Encoding"] and fHeaders["Transfer-Encoding"] == "chunked") then
			local receivebyter = 0
			local tmp
			while true do
				receivebyter = tonumber(socket:ReceiveUntil("\r\n"):ReadStringAll(), 16)
				if (receivebyter == nil) then 
					break
				end
				tmp = socket:Receive(receivebyter)
				if (tmp == false) then return false end
				body = body .. tmp:ReadStringAll()
			end
		else
			return ""
		end
        return body
    end

    function rkk_shttp.fnc:headersRead(socket)
        local headers = socket:ReceiveUntil("\r\n\r\n")
        if headers == false then return false end
        headers = headers:ReadStringAll()
        return headers
    end

    function rkk_shttp.fnc:httpRead(socket)
        local status, code, headers, headerspack, body = "", 0, {}, {}, ""
        status = socket:ReceiveUntil("\r\n")
        if status == false then return false end
        status = string.sub(status:ReadStringAll(), 1, -3)
        code = self:statusDisassembly(status)
        headerspack = self:headersRead(socket)
        if headerspack == false then return false end
        headers = self:headersDisassembly(headerspack)
        body = self:contentRead(socket, headers)

        socket:Close()
        socket = nil

        return status, code, headers, body
    end

    function rkk_shttp.fnc:httpHeadRead(socket)
        local status, code, headers, headerspack = "", 0, {}, {}
        status = socket:ReceiveUntil("\r\n")
        if status == false then return false end
        status = string.sub(status:ReadStringAll(), 1, -3)
        code = self:statusDisassembly(status)
        headerspack = self:headersRead(socket)
        if headerspack == false then return false end
        headers = self:headersDisassembly(headerspack)

        socket:Close()
        socket = nil

        return status, code, headers
    end

    function rkk_shttp.fnc:httpSend(method, fUri, fHeaders, fBody, fOptions)
        local host, path, port, ssl = self:uriDisassembly(fUri)
        local socket = BromSock()
        socket:Connect(host, port)
        if socket == false then return false end
        if (ssl == true) then
            socket:StartSSLClient()
        end
        fHeaders = fHeaders or {}
        fHeaders["Host"] = host
        self:optionsSet(socket, fOptions)
        local statusLine = string.upper(method) .. " " .. path .. " HTTP/1.1"
        local postData = self:postDataConstructor(fBody)
        local headers = self:headersConstructor(fHeaders, #postData)

        local packet = BromPacket()
        packet:WriteLine(statusLine)
        packet:WriteLine(headers)
        if postData != "" then packet:WriteLine(postData) end

        socket:Send(packet, true)

        packet = nil

        return socket
    end

    function rkk_shttp.fnc:optionsSet(socket, fOptions)
        fOptions = fOptions or {}
        socket:SetTimeout(fOptions["timeout"] or 60000)
        socket:SetMaxReceiveSize(fOptions["maxSize"] or 52428800)
    end


    function rkk_shttp.fnc:redirectCheck(code)
        if (code == 301 or code == 302 or code == 307 or code == 308) then
            return 2 -- same METHOD rdr
        elseif (code == 303 and fOptions["redirect"] < 1) then
            return 1 -- GET rdr
        else 
            return 0 -- NO rdr
        end
    end

    function rkk_shttp:Redirecter(method, rdrcode, fData, fHeaders, headers, fOptions)
        fOptions = fOptions or {}
        fOptions["redirect"] = (tonumber(fOptions["redirect"]) - 1) or 0
        if (rdrcode == 1) then
            return self:Get(headers["Location"], fHeaders, fOptions)
        else
            method = string.upper(method)
            if (method == "POST") then
                return self:Post(headers["Location"], fData, fHeaders, fOptions)
            elseif (method == "GET") then
                return self:Get(headers["Location"], fHeaders, fOptions)
            elseif (method == "HEAD") then
                return self:Head(headers["Location"], fHeaders, fOptions)
            end
        end
    end
end