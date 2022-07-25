if (SERVER) then
    require( "bromsock" )

    shttp = {}
    
    local maindir = "rokki_sync_http"
    RkkSvLoad(maindir .. "/functions.lua")
    RkkSvDirLoad(maindir .. "/methods")
end