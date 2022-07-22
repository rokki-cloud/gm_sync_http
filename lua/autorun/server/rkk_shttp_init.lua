if (SERVER) then
    function RkkSvLoad(path)
		include(path)
	end
	function RkkSvDirLoad(path)
		local files, dirs = file.Find( path .. "/*", "LUA" )
		for _, fname in ipairs(files) do
			RkkSvLoad(path .."/".. fname)
		end
		for _, dir in ipairs(dirs) do
			RkkSvDirLoad(path .. "/" .. dir)
		end
	end
    
    RkkSvLoad("rokki_sync_http/base.lua")
end