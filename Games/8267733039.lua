local repo = 'https://raw.githubusercontent.com/KINGHUB01/Gui/main/'

local library = loadstring(game:HttpGet(repo .. 'Gui%20Lib%20%5BLibrary%5D'))()
local theme_manager = loadstring(game:HttpGet(repo .. 'Gui%20Lib%20%5BThemeManager%5D'))()
local save_manager = loadstring(game:HttpGet(repo .. 'Gui%20Lib%20%5BSaveManager%5D'))()

if not game:IsLoaded() then
    library:Notify("Waiting for game to load...")
    game.Loaded:Wait()
    library:Notify("Loaded Game")
end

local window = library:CreateWindow({
    Title = 'Astolfo Ware | https://discord.gg/SUTpER4dNc',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.125
})

local tabs = {
    main = window:AddTab('Main'),
    info = window:AddTab('Info'),
    ['ui settings'] = window:AddTab('UI Settings')
}

local lobby_group = tabs.main:AddLeftGroupbox('Lobby Settings')
local host_group = tabs.main:AddRightGroupbox('Host Settings')
local tp_group = tabs.main:AddLeftGroupbox('Teleport Stuff')
local player_group = tabs.info:AddLeftGroupbox('Player Settings')
local player_info_group = tabs.info:AddRightGroupbox('Player Info')
local menu_group = tabs['ui settings']:AddLeftGroupbox('Menu')
local credits_group = tabs['ui settings']:AddRightGroupbox('Credits')

local marketplace_service = game:GetService("MarketplaceService")
local replicated_storage = game:GetService("ReplicatedStorage")
local info = marketplace_service:GetProductInfo(game.PlaceId)
local teleport_service = game:GetService("TeleportService")
local run_service = game:GetService("RunService")
local players = game:GetService("Players")
local local_player = players.LocalPlayer
local stats = game:GetService("Stats")

local crates = replicated_storage.Shared.Cases

local lobby_name = local_player.Name .. "'s Lobby"
local selected_difficulty = "Insanity"
local lobby_type = "Private"
local max_players_lobby = 1
local selected_map = "Cargo"
local selected_player = ""
local selected_crate = ""

local blacklisted_crates = {
    "Daily",
    "Case1",
    "Case2",
    "Halloween",
    "Halloween2024Collection",
    "Holiday2024Collection",
    "HolidayCollection",
    "Lunar2024Collection",
    "Summer2024Collection",
    "Lunar2025Collection",
    "GoldNature"  -- I blacklisted these because they cost ~ 999k cash shown in the module (You can always remove it from the blacklist)
}

local maps = {
    "Selecting",
    "Asylum",
    "Arcade",
    "Bunker 04",
    "Clinic",
    "Cozy Home",
    "Family Home",
    "Hideout",
    "Lodge",
    "Luxury Home",
    "Rural Home",
    "Safehouse",
    "Cargo",
    "Tridents HQ",
    "Village",
    "Haunted Mansion",
    "Classic Chalet",
    "Art Gallery",
    "Alleyway",
    "Chalet",
    "Classic Clinic",
    "Factory",
    "Private Home",
    "Town"
}

local difficulties = {
    "Normal",
    "Hard",
    "Insanity"
}

local avaible_difficulties = {}
local people_in_lobby = {}
local avaible_crates = {}
local avaible_maps = {}

for _, crate in pairs(crates:GetChildren()) do
    if not table.find(blacklisted_crates, crate.Name) then
        table.insert(avaible_crates, crate.Name)
    end
end

for _, map in pairs(maps) do
    table.insert(avaible_maps, map)
end

for _, difficulty in pairs(difficulties) do
    table.insert(avaible_difficulties, difficulty)
end

for _, player in pairs(players:GetPlayers()) do
    table.insert(people_in_lobby, player.Name)
end

players.PlayerAdded:Connect(function(player)
    table.insert(people_in_lobby, player.Name)
end)

players.PlayerRemoving:Connect(function(player)
    for _, name in ipairs(people_in_lobby) do
        if name == player.Name then
            table.remove(people_in_lobby, _)
            break
        end
    end
end)

lobby_group:AddButton({
    Text = 'Spin Daily Wheel',
    Func = function()
        local spin_remote = replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("WheelService"):WaitForChild("RF"):WaitForChild("Spin")
        local spin = spin_remote:InvokeServer()

        if spin then
            library:Notify("Spun Daily Wheel")
        else
            library:Notify("Already Claimed Daily Wheel")
        end
    end,
    DoubleClick = false,
    Tooltip = 'Spin Daily Wheel'
})

lobby_group:AddButton({
    Text = 'Buy Daily Shop',
    Func = function()
        local daily_shop = local_player.PlayerGui.DailyShop.Frame.Content.Products

        if daily_shop then
            for _, skin in next, daily_shop:GetChildren() do
                if not (skin.Name == "Exotic" or skin.Name == "Special" or skin.Name:find("ShopLandscape")) and not skin:FindFirstChild("Owned").Visible then
                    replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("CharacterService"):WaitForChild("RF"):WaitForChild("PurchaseCharacter"):InvokeServer(skin.Title.Text, skin.Skin.Text)
                    library:Notify("Bought Skin For: " .. skin.Title.Text .. " Skin: " .. skin.Skin.Text)
                    task.wait(0.2)
                end
            end
        end
    end,
    DoubleClick = false,
    Tooltip = 'Buy Daily Shop Skins You Dont Own'
})

--[[
lobby_group:AddButton({
    Text = 'Buy All Avaible Skins',
    Func = function()
        for _, skins in ipairs(replicated_storage:GetDescendants()) do
            if skins:IsA("HumanoidDescription") and skins:GetAttribute("Cost") then
                local cash = local_player.PlayerGui.DailyShop.Frame.Header.Cash
                local cash_value = tonumber(cash.Text:match("[%d%.]+"))

                if cash.Text:find("K") then
                    cash_value = cash_value * 1000
                elseif cash.Text:find("M") then
                    cash_value = cash_value * 1000000
                end

                if cash_value > 7500 then
                    replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("CharacterService"):WaitForChild("RF"):WaitForChild("PurchaseCharacter"):InvokeServer(skins.Parent.Name, skins.Name)
                    library:Notify("Bought " .. skins.Name)
                elseif cash_value < 7500 then
                    library:Notify("Not Enough Cash To Buy Every Cost Skins")
                end
            end
        end
    end,
    DoubleClick = false,
    Tooltip = 'Buy all avaible skins that can be bought with cash'
})
]]

lobby_group:AddDivider()

lobby_group:AddLabel('Select a crate before you try to open it 🙏', true)

lobby_group:AddDropdown('crate_selector', {
    Values = avaible_crates,
    Default = "",
    Multi = false,

    Text = 'Select Crate',
    Tooltip = 'Select which crate you wanna open',

    Callback = function(Value)
        selected_crate = Value
    end
})

lobby_group:AddButton({
    Text = 'Open Crate',
    Func = function()
        if selected_crate then
            replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("CaseService"):WaitForChild("RF"):WaitForChild("PurchaseCase"):InvokeServer(selected_crate)
        else
            library:Notify('Select a crate to open...')
        end
    end,

    DoubleClick = false,
    Tooltip = 'Open selected crate from dropdown'
})

host_group:AddInput('lobby_name', {
    Default = local_player.Name..'s Lobby',
    Numeric = false,
    Finished = false,

    Text = 'Write anything here to put as lobby name',
    Tooltip = 'Changes to whatever you wrote inside the text box',

    Placeholder = local_player.Name..'s Lobby',

    Callback = function(Value)
        lobby_name = Value
    end
})

host_group:AddDropdown('lobby_choose', {
    Values = {"Public", "Private", "Friends"},
    Default = "Private",
    Multi = false,

    Text = 'Select Lobby Type',
    Tooltip = 'Select which type of lobby you want to make',

    Callback = function(Value)
        lobby_type = Value
    end
})

host_group:AddSlider('max_players', {
    Text = 'Max Players',
    Default = 1,
    Min = 1,
    Max = 4,
    Rounding = 0,1,
    Compact = false,

    Callback = function(Value)
        max_players_lobby = Value
    end
})

host_group:AddDropdown('lobby_map', {
    Values = avaible_maps,
    Default = "Cargo",
    Multi = false,

    Text = 'Select Map',
    Tooltip = 'Select which map you wanna do',

    Callback = function(Value)
        selected_map = Value
    end
})

host_group:AddDropdown('lobby_difficulty', {
    Values = avaible_difficulties,
    Default = "Insanity",
    Multi = false,

    Text = 'Select Difficulty',
    Tooltip = 'Select which difficulty you wanna do',

    Callback = function(Value)
        selected_difficulty = Value
    end
})

host_group:AddButton({
    Text = 'Create Lobby',
    Func = function()
        if selected_map and selected_difficulty and max_players_lobby and lobby_name and lobby_type then
            replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("CreateLobby"):InvokeServer(lobby_name, max_players_lobby, 0, lobby_type)
            library:Notify('Lobby Created: ' .. lobby_name .. ' Map: ' .. selected_map .. ' Difficulty: ' .. selected_difficulty)
            task.wait(0.1)
            replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Map", selected_map)
            task.wait(0.1)
            replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("ChangeValue"):InvokeServer("Difficulty", selected_difficulty)
        else
            library:Notify('Finish all settings to create a lobby stupid retard')
        end
    end,
    DoubleClick = false,
    Tooltip = 'Creates a lobby'
})

host_group:AddButton({
    Text = 'Start Game',
    Func = function()
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("AttemptStart"):InvokeServer()
    end,
    DoubleClick = false,
    Tooltip = 'Starts the game'
})

host_group:AddButton({
    Text = 'Leave Lobby',
    Func = function()
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("LobbyService"):WaitForChild("RF"):WaitForChild("AttemptLeave"):InvokeServer()
    end,
    DoubleClick = false,
    Tooltip = 'Leaves the lobby'
})

tp_group:AddButton({
    Text = 'Tp To Test Lobby',
    Func = function()
        teleport_service:Teleport(10046715749)
    end,
    DoubleClick = false,
    Tooltip = 'Teleports you to test lobby'
})

tp_group:AddButton({
    Text = 'Tp To Test Game',
    Func = function()
        teleport_service:Teleport(10089085851)
    end,
    DoubleClick = false,
    Tooltip = 'Teleports you to test game'
})

tp_group:AddButton({
    Text = 'Tp To Test Trading Game',
    Func = function()
        teleport_service:Teleport(13988564812)
    end,
    DoubleClick = false,
    Tooltip = 'Teleports you to test trading plaza'
})

tp_group:AddDivider()

tp_group:AddButton({
    Text = 'Tp To Main Game',
    Func = function()
        teleport_service:Teleport(8417221956)
    end,
    DoubleClick = false,
    Tooltip = 'Teleports you to main game round'
})

tp_group:AddButton({
    Text = 'Tp To Trading Game',
    Func = function()
        teleport_service:Teleport(14056802186)
    end,
    DoubleClick = false,
    Tooltip = 'Teleports you to the main game trading plaza'
})

local user_label = player_info_group:AddLabel('User:')
local user_id_label = player_info_group:AddLabel('User Id:')
local vip_label = player_info_group:AddLabel('Is Vip:')
local prestige_label = player_info_group:AddLabel('Prestige:')
local level_label = player_info_group:AddLabel('Level:')
local device_label = player_info_group:AddLabel('Device:')
local join_time_label = player_info_group:AddLabel('Join Time:')


player_group:AddDropdown('player_selector', {
    Values = people_in_lobby,
    Default = "",
    Multi = false,

    Text = 'Select Player',
    Tooltip = 'Select a player to check.',

    Callback = function(Value)
        selected_player = Value
    end
})

player_group:AddButton({
    Text = 'Get Player Info',
    Func = function()
        if selected_player then
            local player = players:FindFirstChild(selected_player)
            if player then
                user_label:SetText('User: ' .. player.DisplayName)
                user_id_label:SetText('User Id: ' .. player.UserId)
                vip_label:SetText('Is Vip: ' .. tostring(player:GetAttribute("Vip")))
                prestige_label:SetText('Prestige: ' .. player:GetAttribute("Prestige"))
                level_label:SetText('Level: ' .. player:GetAttribute("Level"))
                device_label:SetText('Device: ' .. player:GetAttribute("Device"))
                join_time_label:SetText('Join Time: ' .. os.date('%Y-%m-%d %H:%M:%S', player:GetAttribute("JoinTime")))
            else
                library:Notify('Player not found')
            end
        else
            library:Notify('Select a player')
        end
    end,
    DoubleClick = false,
    Tooltip = 'Get player info'
})

local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local WatermarkConnection = run_service.RenderStepped:Connect(function()
    FrameCounter += 1;

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter;
        FrameTimer = tick();
        FrameCounter = 0;
    end;

    library:SetWatermark(('Astolfo Ware | %s fps | %s ms | game: ' .. info.Name .. ''):format(
        math.floor(FPS),
        math.floor(stats.Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);


menu_group:AddButton('Unload', function()
    WatermarkConnection:Disconnect()
    library:Unload()
end)

credits_group:AddLabel('@kylosilly: Who made the script', true)

credits_group:AddButton({
    Text = 'Join our discord!',
    Func = function()
        setclipboard('https://discord.gg/SUTpER4dNc')
    end,
    DoubleClick = false,
    Tooltip = 'Join our official discord server.'
})

credits_group:AddButton({
    Text = 'Kylosilly Scriptblox',
    Func = function()
        setclipboard('https://scriptblox.com/u/CatBoy')
    end,
    DoubleClick = false,
    Tooltip = 'My scriptblox profile'
})

credits_group:AddButton({
    Text = 'Kylosilly Github',
    Func = function()
        setclipboard('https://github.com/kylosilly')
    end,
    DoubleClick = false,
    Tooltip = 'My github profile'
})

menu_group:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
library.ToggleKeybind = Options.MenuKeybind
theme_manager:SetLibrary(library)
save_manager:SetLibrary(library)
save_manager:IgnoreThemeSettings()
save_manager:SetIgnoreIndexes({ 'MenuKeybind' })
theme_manager:SetFolder('Astolfo Ware')
save_manager:SetFolder('Astolfo Ware/Specter Lobby')
save_manager:BuildConfigSection(tabs['ui settings'])
theme_manager:ApplyToTab(tabs['ui settings'])
save_manager:LoadAutoloadConfig()
