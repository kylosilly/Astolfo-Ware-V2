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

local game_group = tabs.main:AddLeftGroupbox('Game Settings')
local misc_group = tabs.main:AddRightGroupbox('Misc Settings')
local menu_group = tabs['ui settings']:AddLeftGroupbox('Menu')

local proximity_prompt_service = cloneref(game:GetService('ProximityPromptService'))
local replicated_storage = cloneref(game:GetService('ReplicatedStorage'))
local local_player = cloneref(game:GetService('Players').LocalPlayer)
local market = cloneref(game:GetService('MarketplaceService'))
local run_service = cloneref(game:GetService('RunService'))
local workspace = cloneref(game:GetService('Workspace'))
local stats = cloneref(game:GetService('Stats'))
local info = market:GetProductInfo(game.PlaceId)

local goto_nearest = false
local remove_coins = false
local pickup_aura = false
local always_gold = false
local auto_sell = false
local no_hold = false

local pickup_aura_range = 15
local pickup_aura_delay = 0.1
local sell_delay = 0.1

proximity_prompt_service.PromptButtonHoldBegan:Connect(function(p)
    if no_hold then
        p.HoldDuration = 0
    end
end)

workspace.ChildAdded:Connect(function(c)
    if c.Name == "Coin" and remove_coins then
        c:Destroy()
    end
end)

function nearest_plant()
    local plant = nil
    local distance = math.huge
    for _, v in next, workspace.Plants:GetChildren() do
        if v:IsA("Model") and local_player.Character and local_player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (v:GetPivot().Position - local_player.Character:GetPivot().Position).Magnitude
            if dist < distance then
                distance = dist
                plant = v
            end
        end
    end
    return plant
end

game_group:AddDivider()

game_group:AddToggle('pickup_aura', {
    Text = 'Pickup Aura',
    Default = pickup_aura,
    Tooltip = 'Picks up closest plants',

    Callback = function(Value)
        pickup_aura = Value
        if Value then
            repeat
                for _, v in next, workspace.Plants:GetChildren() do
                    if v:IsA("Model") and v.PrimaryPart and local_player.Character and (v:GetPivot().Position - local_player.Character:GetPivot().Position).Magnitude < pickup_aura_range then
                        fireproximityprompt(v.PrimaryPart:FindFirstChildOfClass("ProximityPrompt"))
                    end
                end
                task.wait(pickup_aura_delay)
            until not pickup_aura
        end
    end
})

game_group:AddToggle('goto_nearest', {
    Text = 'Tp To Nearest Plant',
    Default = goto_nearest,
    Tooltip = 'Teleports you to closest plant',

    Callback = function(Value)
        goto_nearest = Value
        if Value then
            repeat
                local plant = nearest_plant()
                if plant and local_player.Character and local_player.Character:FindFirstChild("HumanoidRootPart") then
                    local_player.Character.HumanoidRootPart.CFrame = plant:GetPivot() + Vector3.new(0, 5, 0)
                end
                task.wait()
            until not goto_nearest
        end
    end
})

game_group:AddSlider('pickup_aura_range', {
    Text = 'Pickup Aura Range',
    Default = pickup_aura_range,
    Min = 5,
    Max = 15,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        pickup_aura_range = Value
    end
})

game_group:AddSlider('pickup_aura_delay', {
    Text = 'Pickup Aura Delay',
    Default = pickup_aura_delay,
    Min = 0.1,
    Max = 10,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        pickup_aura_delay = Value
    end
})

game_group:AddDivider()

game_group:AddToggle('auto_sell', {
    Text = 'Auto Sell',
    Default = auto_sell,
    Tooltip = 'Auto sells plants in crate',

    Callback = function(Value)
        auto_sell = Value
        if Value then
            repeat
                local crate = local_player.Character and local_player.Character:FindFirstChild("Crate")
                if crate then
                    for _, v in next, crate:GetChildren() do
                        if v:IsA("Model") then
                            replicated_storage:WaitForChild("Remotes"):WaitForChild("SellPlantFromCrate"):FireServer({IsGold = always_gold, Name = v.Name, UID = v:GetAttribute("UID")})
                        end
                    end
                end
                task.wait(sell_delay)
            until not auto_sell
        end
    end
})

game_group:AddToggle('always_gold', {
    Text = 'Always Gold Sell',
    Default = always_gold,
    Tooltip = 'Always sells any fruit as gold',

    Callback = function(Value)
        always_gold = Value
    end
})

game_group:AddSlider('sell_delay', {
    Text = 'Auto Sell Delay',
    Default = sell_delay,
    Min = 0.1,
    Max = 10,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        sell_delay = Value
    end
})

misc_group:AddDivider()

misc_group:AddToggle('no_hold', {
    Text = 'No Prompt Hold',
    Default = no_hold,
    Tooltip = 'Remotes hold time from proximityprompts',

    Callback = function(Value)
        no_hold = Value
    end
})

misc_group:AddDivider()

misc_group:AddToggle('remove_coins', {
    Text = 'Destroy Coins',
    Default = remove_coins,
    Tooltip = 'Deletes coins to prevent lag',

    Callback = function(Value)
        remove_coins = Value
        if Value then
            for _, v in next, workspace:GetChildren() do
                if v.Name == "Coin" then
                    v:Destroy()
                end
            end
        end
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
    goto_nearest = false
    pickup_aura = false
    auto_sell = false
    no_hold = false
    library:Unload()
end)

menu_group:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
library.ToggleKeybind = Options.MenuKeybind
theme_manager:SetLibrary(library)
save_manager:SetLibrary(library)
save_manager:IgnoreThemeSettings()
save_manager:SetIgnoreIndexes({ 'MenuKeybind' })
theme_manager:SetFolder('Astolfo Ware')
save_manager:SetFolder('Astolfo Ware/Steal A Garden')
save_manager:BuildConfigSection(tabs['ui settings'])
theme_manager:ApplyToTab(tabs['ui settings'])
save_manager:LoadAutoloadConfig()
