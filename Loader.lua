local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()

local games = "https://raw.githubusercontent.com/kylosilly/Astolfo-Ware-V2/main/Games"

local local_player = cloneref(game:GetService("Players").LocalPlayer)
local market = cloneref(game:GetService("MarketplaceService"))
local info = market:GetProductInfo(game.PlaceId)

function check_supported()
    local success, result = pcall(function()
        return game:HttpGet(games.."/"..game.PlaceId..".lua")
    end)
    if not success or result == "404: Not Found" then
        library:Notify("Unsupported Game: "..info.Name.." If You Want It Supported Join The Discord Copied To Your Clipboard")
        setclipboard("https://discord.gg/SUTpER4dNc")
    end
end

if getthreadcontext() > 7 then
    print("Executor Supported")
else
    local_player:Kick("Unsupported Executor Use A Diffirent Executor")
end

check_supported()

loadstring(game:HttpGet(games.."/"..game.PlaceId..".lua"))()
library:Notify("Supported Game Loading: "..info.Name)
