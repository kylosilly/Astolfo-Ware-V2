local setting = getfenv().settings

if not game:IsLoaded() then
    print("Waiting for game to load...")
    game.Loaded:Wait()
    print("Loaded Game")
end

local http_request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local replicated_storage = cloneref(game:GetService("ReplicatedStorage"))
local teleport_service = cloneref(game:GetService("TeleportService"))
local local_player = cloneref(game:GetService("Players")).LocalPlayer
local http_service = cloneref(game:GetService("HttpService"))

local shop = local_player.PlayerGui.Seed_Shop.Frame.ScrollingFrame

local egg_models = replicated_storage:WaitForChild("Assets"):WaitForChild("Models"):WaitForChild("EggModels")
local seed_models = replicated_storage:WaitForChild("Seed_Models")

local place_id = game.PlaceId
local job_id = game.JobId

if not http_request then
    local_player:Kick("Executor Not Supported")
end

-- Credits To Inf Yield For This
function server_hop()
    local servers = {}
    local request = httprequest({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", place_id)})
    local body = http_service:JSONDecode(request.Body)

    if body and body.data then
        for _, v in next, body.data do
            if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= job_id then
                table.insert(servers, v.id)
            end
        end
    end

    if #servers > 0 then
        teleport_service:TeleportToPlaceInstance(place_id, servers[math.random(1, #servers)])
    else
        print("No Server Found!")
    end
end

function get_seeds()
    if #setting.seeds < 1 then
        print("No Seeds To Buy")
        return
    else
        for _,v in next, shop:GetChildren() do
            if table.find(setting.seeds, v.Name) and v:FindFirstChild("Main_Frame") and v.Main_Frame:FindFirstChild("Cost_Text") and v.Main_Frame.Cost_Text.Text ~= "NO STOCK" then
                local stock = tonumber(v.Main_Frame.Stock_Text.Text:match("%d+"))
                for i = 1, stock do
                    replicated_storage:WaitForChild("GameEvents"):WaitForChild("BuySeedStock"):FireServer(v.Name)
                    task.wait(.1)
                end

                if setting.webhook and setting.webhook ~= "" then
                    local data = {
                        ["username"] = "Notifier Made By @kylosilly",
                        ["embeds"] = {
                            {
                                ["title"] = "Found Seed!",
                                ["description"] = "Found: "..v.Name.." Stock: "..stock,
                                ["color"] = 16777215,
                                ["footer"] = {
                                    ["text"] = "Server JobId: "..job_id
                                }
                            }
                        }
                    }

                    if setting.ping_role and setting.ping_role ~= "" then
                        data["content"] = settings.ping_role
                    elseif setting.ping_role == "" then
                        data["content"] = "@everyone"
                    end

                    http_request({
                        Url = setting.webhook,
                        Method = "POST",
                        Headers = {
                            ["Content-Type"] = "application/json"
                        },
                        Body = game:GetService("HttpService"):JSONEncode(data)
                    })
                end
            end
        end

        task.wait(setting.server_hop_delay)
        server_hop()
    end
end

function get_eggs()
    if #setting.eggs < 1 then
        print("No Eggs To Buy")
        return
    else
        for i,v in next, workspace.NPCS["Pet Stand"].EggLocations:GetChildren() do
            if table.find(setting.eggs, v.Name) then
                replicated_storage:WaitForChild("GameEvents"):WaitForChild("BuyPetEgg"):FireServer(i - 3)
                task.wait(.1)

                if setting.webhook and setting.webhook ~= "" then
                    local data = {
                        ["username"] = "Notifier Made By @kylosilly",
                        ["embeds"] = {
                            {
                                ["title"] = "Found Egg!",
                                ["description"] = "Found: "..v.Name,
                                ["color"] = 16777215,
                                ["footer"] = {
                                    ["text"] = "Server JobId: "..job_id
                                }
                            }
                        }
                    }

                    if setting.ping_role and setting.ping_role ~= "" then
                        data["content"] = settings.ping_role
                    elseif setting.ping_role == "" then
                        data["content"] = "@everyone"
                    end

                    http_request({
                        Url = setting.webhook,
                        Method = "POST",
                        Headers = {
                            ["Content-Type"] = "application/json"
                        },
                        Body = game:GetService("HttpService"):JSONEncode(data)
                    })
                end
            end
        end

        task.wait(setting.server_hop_delay)
        server_hop()
    end
end

if setting.method == "Seed" then
    get_seeds()
elseif setting.method == "Egg" then
    get_eggs()
elseif setting.method == "Both" then
    get_seeds()
    get_eggs()
end
