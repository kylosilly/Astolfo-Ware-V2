if not game:IsLoaded() then
    game.Loaded:Wait()
end

local repo = 'https://raw.githubusercontent.com/KINGHUB01/Gui/main/'

local library = loadstring(game:HttpGet(repo .. 'Gui%20Lib%20%5BLibrary%5D'))()
local theme_manager = loadstring(game:HttpGet(repo .. 'Gui%20Lib%20%5BThemeManager%5D'))()
local save_manager = loadstring(game:HttpGet(repo .. 'Gui%20Lib%20%5BSaveManager%5D'))()

local window = library:CreateWindow({
    Title = "Astolfo Ware | Made By @kylosilly | discord.gg/SUTpER4dNc",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.35
})

local tabs = {
    main = window:AddTab("Main"),
    ["ui settings"] = window:AddTab("UI Settings")
}

local collect_group = tabs.main:AddLeftGroupbox("Collect Settings")
local game_group = tabs.main:AddRightGroupbox("Game Settings")
local player_group = tabs.main:AddRightGroupbox("Player Settings")
local menu_group = tabs["ui settings"]:AddLeftGroupbox("Menu Settings")

local replicated_storage = game:GetService("ReplicatedStorage")
local user_input_service = game:GetService("UserInputService")
local market = game:GetService("MarketplaceService")
local run_service = game:GetService("RunService")
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local stats = game:GetService("Stats")

local info = market:GetProductInfo(game.PlaceId)
local get_gc = getconnections or get_signal_cons
local local_player = players.LocalPlayer

local collectables = workspace:WaitForChild("Collectables")

if not collectables then
    local_player:Kick("Collectables folder not found!")
end

local block_data = replicated_storage:WaitForChild("Data"):WaitForChild("Blocks")

if not block_data then
    local_player:Kick("Block data folder not found!")
end

local auto_collect = false
local auto_pickup = false
local inf_jump = false

local selected_pickup_method = "Remote"

--// Theres better ways to do it but i just did it like that
function rarest_block()
    local block = nil
    local rarity = 0

    for _, v in next, replicated_storage.Remotes.Client.Blocks.GetCurrentBlocks:InvokeServer() do
        if require(block_data:FindFirstChild(v.Id)).Weight > rarity then
            block = v.UUID
            rarity = require(block_data:FindFirstChild(v.Id)).Weight
        end
    end

    return block
end

user_input_service.JumpRequest:Connect(function()
    if inf_jump and not jumped then
        jumped = true
        local_player.Character.Humanoid:ChangeState("Jumping")
        wait()
        jumped = false
    end
end)

collect_group:AddDivider()

collect_group:AddToggle('auto_collect', {
    Text = 'Auto Collect Blocks',
    Default = auto_collect,
    Tooltip = 'Automatically picks up rarest blocks',

    Callback = function(Value)
        auto_collect = Value
        if Value then
            repeat
                local block = rarest_block()
                if block then
                    replicated_storage.Remotes.Client.Blocks.PickupBlock:FireServer(block, CFrame.new(local_player.Character:GetPivot().Position))
                    task.wait()
                end
                task.wait()
            until not auto_collect
        end
    end
})

collect_group:AddToggle('auto_pickup', {
    Text = 'Collect Collectables',
    Default = auto_pickup,
    Tooltip = 'Collect collectables with selected method',

    Callback = function(Value)
        auto_pickup = Value
        if Value then
            repeat
                for _, v in next, collectables:GetChildren() do
                    if v:GetAttribute("CanCollect") and v:GetAttribute("UUID") then
                        if selected_pickup_method == "Remote" then
                            replicated_storage:WaitForChild("Remotes"):WaitForChild("Client"):WaitForChild("Collectable"):WaitForChild("PickupCollectable"):FireServer(v:GetAttribute("UUID"))
                            v:Destroy()
                            task.wait()
                        elseif selected_pickup_method == "Tp" then
                            v.Position = local_player.Character:GetPivot().Position
                            task.wait()
                        end
                    end
                end
                task.wait()
            until not auto_pickup
        end
    end
})

collect_group:AddDivider()

collect_group:AddDropdown('collect_method', {
    Values = {'Remote', 'Tp'},
    Default = selected_pickup_method,
    Multi = false,

    Text = 'Auto Collect Method:',
    Tooltip = 'Select which method to use to auto collect',

    Callback = function(Value)
        selected_pickup_method = Value
    end
})

game_group:AddDivider()

game_group:AddButton({
    Text = 'Break Server',
    Func = function()
        if not local_player.PlayerGui:WaitForChild("GUI"):WaitForChild("MapVoting").Visible then
            library:Notify("Run this when voting map!")
            return
        end

        replicated_storage:WaitForChild("Remotes"):WaitForChild("Client"):WaitForChild("Worlds"):WaitForChild("SendVote"):FireServer("nigga")
        library:Notify("Server Broken!")
    end,
    DoubleClick = false,
    Tooltip = 'Will be stuck at 0 and new map wont load'
})

player_group:AddDivider()

player_group:AddToggle('inf_jump', {
    Text = 'Inf Jump',
    Default = inf_jump,
    Tooltip = 'Lets you jump forever',

    Callback = function(Value)
        inf_jump = Value
    end
})

player_group:AddButton({
    Text = 'Anti Afk',
    Func = function()
        for _, v in next, get_gc(local_player.Idled) do
            if v["Disable"] then
                v["Disable"](v)
            elseif v["Disconnect"] then
                v["Disconnect"](v)
            end
        end
        library:Notify("Anti Afk Enabled!")
    end,
    DoubleClick = false,
    Tooltip = 'Wont disconnect you after 20 minutes',
})

local frame_timer = tick()
local frame_counter = 0;
local fps = 60;

local watermark_connection = run_service.RenderStepped:Connect(function()
    frame_counter += 1;

    if (tick() - frame_timer) >= 1 then
        fps = frame_counter;
        frame_timer = tick();
        frame_counter = 0;
    end;

    library:SetWatermark(('Astolfo Ware | %s fps | %s ms | game: ' .. info.Name .. ''):format(
        math.floor(fps),
        math.floor(stats.Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);

menu_group:AddButton('Unload', function()
    auto_collect = false
    auto_pickup = false
    inf_jump = false
    watermark_connection:Disconnect()
    library:Unload()
end)

menu_group:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
library.ToggleKeybind = Options.MenuKeybind
theme_manager:SetLibrary(library)
save_manager:SetLibrary(library)
save_manager:IgnoreThemeSettings()
save_manager:SetIgnoreIndexes({ 'MenuKeybind' })
theme_manager:SetFolder('Astolfo Ware')
save_manager:SetFolder('Astolfo Ware/Block Mayhem X')
save_manager:BuildConfigSection(tabs['ui settings'])
theme_manager:ApplyToTab(tabs['ui settings'])
save_manager:LoadAutoloadConfig()
