if not game:IsLoaded() then
    game.Loaded:Wait()
end

local repo = 'https://raw.githubusercontent.com/KINGHUB01/Gui/main/'

local library = loadstring(game:HttpGet(repo .. 'Gui%20Lib%20%5BLibrary%5D'))()
local theme_manager = loadstring(game:HttpGet(repo .. 'Gui%20Lib%20%5BThemeManager%5D'))()
local save_manager = loadstring(game:HttpGet(repo .. 'Gui%20Lib%20%5BSaveManager%5D'))()

local window = library:CreateWindow({
    Title = "This Mango Gui Boii",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.35
})

local tabs = {
    main = window:AddTab("Main"),
    ["ui settings"] = window:AddTab("UI Settings")
}

local combat_group = tabs.main:AddLeftGroupbox("Combat Settings")
local game_group = tabs.main:AddRightGroupbox("Game Settings")
local player_group = tabs.main:AddRightGroupbox("Player Settings")
local menu_group = tabs["ui settings"]:AddLeftGroupbox("Menu Settings")

local marketplace_service = game:GetService("MarketplaceService")
local replicated_storage = game:GetService("ReplicatedStorage")
local run_service = game:GetService("RunService")
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local stats = game:GetService("Stats")

local info = marketplace_service:GetProductInfo(game.PlaceId)
local local_player = players.LocalPlayer

local enemies = workspace:FindFirstChild("Enemies")

if not enemies then
    local_player:Kick("Enemies not found!")
end

local fighter_names = replicated_storage:FindFirstChild("Fighters")

if not fighter_names then
    local_player:Kick("Fighters not found!")
end

local power_ups = replicated_storage:FindFirstChild("PlrMan"):FindFirstChild("Items")

if not power_ups then
    local_player:Kick("Power ups not found!")
end

local kill_aura = false

local selected_powerup = ""
local selected_figher = ""

local powerup_give_amount = 1
local kill_aura_distance = 100

local powerups = {}
local fighters = {}

for _, v in next, fighter_names:GetChildren() do
    table.insert(fighters, v.Name)
end

for _, v in next, power_ups:GetChildren() do
    if v:IsA("Part") then
        table.insert(powerups, v.Name)
    end
end

combat_group:AddDivider()

combat_group:AddToggle('kill_aura', {
    Text = 'Kill Aura',
    Default = kill_aura,
    Tooltip = 'Kills nearby enemies',

    Callback = function(Value)
        kill_aura = Value
        if Value then
            repeat
                if #enemies:GetChildren() > 0 then
                    for _, v in next, enemies:GetChildren() do
                        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and (v:GetPivot().Position - local_player.Character:GetPivot().Position).magnitude < kill_aura_distance then
                            replicated_storage:WaitForChild("HurtEnemy"):FireServer(v, v.Humanoid.Health)
                        end
                    end
                end
                task.wait()
            until not kill_aura
        end
    end
})

combat_group:AddSlider('kill_aura_distance', {
    Text = 'Kill Aura Max Distance:',
    Default = kill_aura_distance,
    Min = 5,
    Max = 1000,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        kill_aura_distance = Value
    end
})

combat_group:AddDivider()

combat_group:AddButton({
    Text = 'Give Everyone Windforce',
    Func = function()
        for _, v in next, players:GetPlayers() do
            if local_player.Character and v.Character then
                replicated_storage:WaitForChild("PlrMan"):WaitForChild("SkillUtil"):WaitForChild("ReplicatePlrBullet"):FireServer(v.Character:GetPivot().Position, vector.create(-0, -0, -1), "Windforce", v.Character)
            end
        end
    end,
    DoubleClick = false,
    Tooltip = 'Gives everyone windforce'
})

game_group:AddDivider()

game_group:AddDropdown('powerups', {
    Values = powerups,
    Default = selected_powerup,
    Multi = false,

    Text = 'Select Power Up To Give:',
    Tooltip = 'Gives selected power up',

    Callback = function(Value)
        selected_powerup = Value
    end
})

game_group:AddSlider('powerup_give_amount', {
    Text = 'Amount Of Power Ups To Give:',
    Default = powerup_give_amount,
    Min = 1,
    Max = 1000,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        powerup_give_amount = Value
    end
})

game_group:AddButton({
    Text = 'Give Power Ups',
    Func = function()
        if selected_powerup ~= "" then
            for i = 1, powerup_give_amount do
                replicated_storage:WaitForChild("PlrMan"):WaitForChild("Items"):WaitForChild("PickupItem"):FireServer(tostring(selected_powerup))
            end
        else
            library:Notify("No Power Up Selected")
        end
    end,
    DoubleClick = false,
    Tooltip = 'Gives selected power up'
})

player_group:AddDivider()

player_group:AddDropdown('fighter_names', {
    Values = fighters,
    Default = selected_figher,
    Multi = false,

    Text = 'Select Fighter To Equip:',
    Tooltip = 'Equips selected fighter',

    Callback = function(Value)
        selected_figher = Value
    end
})

player_group:AddButton({
    Text = 'Equip Fighter',
    Func = function()
        if selected_figher ~= "" then
            local_player:WaitForChild("PlayerGui"):WaitForChild("ScreenUI"):WaitForChild("SetActiveFighter"):FireServer(tostring(selected_figher))
            local_player:WaitForChild("PlayerGui"):WaitForChild("ScreenUI"):WaitForChild("StartGame"):FireServer()
            library:Notify("Equipped "..selected_figher)
        else
            library:Notify("No fighter selected")
        end
    end,
    DoubleClick = false,
    Tooltip = 'Equips selected fighter'
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

    library:SetWatermark(('Astolfo Ware | %s fps | %s ms | game: '..info.Name..''):format(
        math.floor(fps),
        math.floor(stats.Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);

menu_group:AddButton('Unload', function()
    kill_aura = false
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
save_manager:SetFolder('Astolfo Ware/Noobs Must Die')
save_manager:BuildConfigSection(tabs['ui settings'])
theme_manager:ApplyToTab(tabs['ui settings'])
save_manager:LoadAutoloadConfig()
