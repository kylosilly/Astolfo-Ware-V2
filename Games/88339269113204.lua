if not game:IsLoaded() then
    print("Waiting for game to load...")
    game.Loaded:Wait()
    print("Loaded Game")
end

local repo = 'https://raw.githubusercontent.com/KINGHUB01/Gui/main/'

local library = loadstring(game:HttpGet(repo .. 'Gui%20Lib%20%5BLibrary%5D'))()
local theme_manager = loadstring(game:HttpGet(repo .. 'Gui%20Lib%20%5BThemeManager%5D'))()
local save_manager = loadstring(game:HttpGet(repo .. 'Gui%20Lib%20%5BSaveManager%5D'))()

local window = library:CreateWindow({
    Title = 'Astolfo Ware | Made By @kylosilly | discord.gg/SUTpER4dNc',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local tabs = {
    main = window:AddTab('Main'),
    ['ui settings'] = window:AddTab('UI Settings')
}

local combat_group = tabs.main:AddLeftGroupbox('Combat Settings')
local game_group = tabs.main:AddRightGroupbox('Game Settings')
local menu_group = tabs['ui settings']:AddLeftGroupbox('Menu')

local replicated_storage = cloneref(game:GetService("ReplicatedStorage"))
local market = cloneref(game:GetService("MarketplaceService"))
local run_service = cloneref(game:GetService("RunService"))
local workspace = cloneref(game:GetService("Workspace"))
local players = cloneref(game:GetService("Players"))
local stats = cloneref(game:GetService("Stats"))
local info = market:GetProductInfo(game.PlaceId)

local local_player = players.LocalPlayer

local skewer_settings = require(replicated_storage.Shared.Dictionaries.SkewerSettings)

local active_stars = workspace:FindFirstChild("ActiveStars")

local hitbox_expander = false
local collect_stars = false
local show_hitbox = false
local kill_aura = false
local auto_farm = false
local auto_eat = false
local no_delay = false

local star_collect_delay = 0

local hitbox_x = 5
local hitbox_y = 5
local hitbox_z = 5

workspace.ChildAdded:Connect(function(h)
    if h.Name == "Hitbox" and hitbox_expander then
        h.Size = Vector3.new(hitbox_x, hitbox_y, hitbox_z)
    end

    if h.Name == "Hitbox" and show_hitbox then
        h.Transparency = 0
    end
end)

combat_group:AddDivider()

--// I got not idea how to make the delay good and prevent people staying after its more far away ik why it stays but i cant fix it gg
combat_group:AddToggle('kill_aura', {
    Text = 'Kill Aura',
    Default = kill_aura,
    Tooltip = 'Attacks nearby players with selected distance',

    Callback = function(Value)
        kill_aura = Value
        if Value then
            repeat
                local targets = {}
                if local_player.Character and local_player.Character:FindFirstChildOfClass("Tool") and local_player.Character:FindFirstChild("HumanoidRootPart") and #players:GetPlayers() > 1 then
                    for _, v in next, players:GetPlayers() do
                        if v ~= local_player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 and (v.Character:GetPivot().Position - local_player.Character:GetPivot().Position).Magnitude < 20 then
                            table.insert(targets, v)
                        end
                    end
                    if #targets > 0 then
                        for _, v in next, targets do
                            replicated_storage:WaitForChild("Remotes"):WaitForChild("Client"):WaitForChild("SkewerHit"):FireServer(v)
                            
                            if local_player.Character:FindFirstChildOfClass("Tool"):FindFirstChild("Bodies") and #local_player.Character:FindFirstChildOfClass("Tool").Bodies:GetChildren() > 3 then
                                replicated_storage:WaitForChild("Remotes"):WaitForChild("Client"):WaitForChild("EatSkewer"):FireServer()
                            end
                        end
                    end
                end
                task.wait()
            until not kill_aura
        end
    end
})

combat_group:AddToggle('auto_farm', {
    Text = 'Auto Farm',
    Default = auto_farm,
    Tooltip = 'Farms kills, coins',

    Callback = function(Value)
        auto_farm = Value
        if Value then
            local notified = false
            local last_position = local_player.Character:GetPivot().Position
            repeat
                if kill_aura then
                    library:Notify("This wont run when kill aura is on")
                    notified = true
                end

                if not kill_aura then
                    local player = players:GetPlayers()[math.random(1, #players:GetPlayers())]
                    if player ~= local_player and local_player.Character:FindFirstChildOfClass("Tool") and local_player.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                        local_player.Character:TranslateBy(player.Character:GetPivot().Position - local_player.Character:GetPivot().Position)
                        task.wait(.15)
                        replicated_storage:WaitForChild("Remotes"):WaitForChild("Client"):WaitForChild("SkewerHit"):FireServer(player)
                        
                        if local_player.Character:FindFirstChildOfClass("Tool"):FindFirstChild("Bodies") and #local_player.Character:FindFirstChildOfClass("Tool").Bodies:GetChildren() > 3 then
                            replicated_storage:WaitForChild("Remotes"):WaitForChild("Client"):WaitForChild("EatSkewer"):FireServer()
                        end
                        task.wait()
                    end
                end
                task.wait()
            until not auto_farm
            local_player.Character:TranslateBy(last_position - local_player.Character:GetPivot().Position)
        end
    end
})

combat_group:AddDivider()

combat_group:AddToggle('auto_eat', {
    Text = 'Auto Eat',
    Default = auto_eat,
    Tooltip = 'Automatically eats people',

    Callback = function(Value)
        auto_eat = Value
        if Value then
            local notified = false
            repeat
                if kill_aura and not notified then
                    library:Notify("This wont run when kill aura is on")
                    notified = true
                end
                if local_player.Character and local_player.Character:FindFirstChildOfClass("Tool") and local_player.Character:FindFirstChildOfClass("Tool"):FindFirstChild("Bodies"):FindFirstChildOfClass("Model") and not kill_aura then
                    replicated_storage:WaitForChild("Remotes"):WaitForChild("Client"):WaitForChild("EatSkewer"):FireServer()
                end
                task.wait(1)
            until not auto_eat
        end
    end
})

combat_group:AddToggle('no_delay', {
    Text = 'No Swing Cooldown',
    Default = no_delay,
    Tooltip = 'Removes cooldown on swings',

    Callback = function(Value)
        no_delay = Value
        if Value then
            skewer_settings.Cooldown = 0
        else
            skewer_settings.Cooldown = 1.5
        end
    end
})

combat_group:AddDivider()

combat_group:AddToggle('hitbox_expander', {
    Text = 'Swing Hitbox Expander',
    Default = hitbox_expander,
    Tooltip = 'Expands hitbox on swing',

    Callback = function(Value)
        hitbox_expander = Value
    end
})

combat_group:AddSlider('x', {
    Text = 'Hitbox Size X:',
    Default = hitbox_x,
    Min = 1,
    Max = 20,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        hitbox_x = Value
    end
})

combat_group:AddSlider('y', {
    Text = 'Hitbox Size Y:',
    Default = hitbox_y,
    Min = 1,
    Max = 20,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        hitbox_y = Value
    end
})

combat_group:AddSlider('z', {
    Text = 'Hitbox Size Z:',
    Default = hitbox_z,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        hitbox_z = Value
    end
})

combat_group:AddDivider()

combat_group:AddToggle('show_hitbox', {
    Text = 'Show Hitbox',
    Default = show_hitbox,
    Tooltip = 'Shows hitbox on swing',

    Callback = function(Value)
        show_hitbox = Value
    end
})

game_group:AddDivider()

game_group:AddToggle('collect_stars', {
    Text = 'Auto Collect Stars',
    Default = collect_stars,
    Tooltip = 'Automatically collects stars around the map',

    Callback = function(Value)
        collect_stars = Value
        if Value then
            repeat
                if local_player.Character and local_player.Character:FindFirstChild("HumanoidRootPart") and #active_stars:GetChildren() > 0 then
                    for _, v in next, active_stars:GetDescendants() do
                        if v:IsA("TouchTransmitter") then
                            firetouchinterest(local_player.Character.HumanoidRootPart, v.Parent, 0)
                            firetouchinterest(local_player.Character.HumanoidRootPart, v.Parent, 1)
                        end
                    end
                end
                task.wait(star_collect_delay)
            until not collect_stars
        end
    end
})

game_group:AddSlider('collect_delay', {
    Text = 'Star Collect Delay:',
    Default = star_collect_delay,
    Min = 0,
    Max = 60,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        star_collect_delay = Value
    end
})

local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local watermark_connection = run_service.RenderStepped:Connect(function()
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
    hitbox_expander = false
    collect_stars = false
    show_hitbox = false
    kill_aura = false
    auto_farm = false
    auto_eat = false
    no_delay = false
    skewer_settings.Cooldown = 1.5
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
save_manager:SetFolder('Astolfo Ware/kebab Fight')
save_manager:BuildConfigSection(tabs['ui settings'])
theme_manager:ApplyToTab(tabs['ui settings'])
save_manager:LoadAutoloadConfig()
