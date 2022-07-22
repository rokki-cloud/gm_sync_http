if (SERVER) then
    require( "bromsock" )

    rkk_shttp = {}
    
    local maindir = "rokki_sync_http"
    RkkSvLoad(maindir .. "/functions.lua")
    RkkSvDirLoad(maindir .. "/methods")
end