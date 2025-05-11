if not game:IsLoaded() then
    print("Waiting for game to load...")
    game.Loaded:Wait()
    print("Loaded Game")
end

if getthreadcontext() > 7 then
    print("Executor Supported")
else
    game:Shutdown()
end

local repo = 'https://raw.githubusercontent.com/KINGHUB01/Gui/main/'

local library = loadstring(game:HttpGet(repo .. 'Gui%20Lib%20%5BLibrary%5D'))()
local theme_manager = loadstring(game:HttpGet(repo .. 'Gui%20Lib%20%5BThemeManager%5D'))()
local save_manager = loadstring(game:HttpGet(repo .. 'Gui%20Lib%20%5BSaveManager%5D'))()

local window = library:CreateWindow({
    Title = 'Astolfo Ware | Made By @kylosilly',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local tabs = {
    main = window:AddTab('Main'),
    ['ui settings'] = window:AddTab('UI Settings')
}

local mine_group = tabs.main:AddLeftGroupbox('Mine Settings')
local shop_group = tabs.main:AddRightGroupbox('Shop Settings')
local player_group = tabs.main:AddRightGroupbox('Player Settings')
local menu_group = tabs['ui settings']:AddLeftGroupbox('Menu')

local replicated_storage = cloneref(game:GetService('ReplicatedStorage'))
local teleport_service = cloneref(game:GetService('TeleportService'))
local market = cloneref(game:GetService('MarketplaceService'))
local virtual_user = cloneref(game:GetService('VirtualUser'))
local run_service = cloneref(game:GetService('RunService'))
local workspace = cloneref(game:GetService('Workspace'))
local players = cloneref(game:GetService('Players'))
local stats = cloneref(game:GetService('Stats'))
local getgc = getconnections or get_signal_cons
local info = market:GetProductInfo(game.PlaceId)
local local_player = players.LocalPlayer

local plot = nil

local auto_collect = false
local auto_drill = false

local custom_drill_delay = 0

local auto_drill_method = "Custom Delay"
local drill_collect_method = "Full"

for _, v in next, workspace.Plots:GetDescendants() do
    if v.Parent.Name == "Plot" and v:IsA("ObjectValue") and v.Name == "Owner" and v.Value == local_player then
        plot = v.Parent
        break
    end
end

shop_group:AddButton({
    Text = 'Sell All',
    Func = function()
        local old = local_player.Character.HumanoidRootPart.CFrame
        local_player.Character.HumanoidRootPart.CFrame = workspace.Scripted.Sell.CFrame
        task.wait(.25)
        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("OreService"):WaitForChild("RE"):WaitForChild("SellAll"):FireServer()
        task.wait(.25)
        local_player.Character.HumanoidRootPart.CFrame = old
    end,
    DoubleClick = false,
    Tooltip = 'Sells All Ores'
})

player_group:AddButton({
    Text = 'Anti Afk',
    Func = function()
        if getgc then
            for _, v in next, getgc(local_player.Idled) do
                if v["Disable"] then
                    v["Disable"](v)
                elseif v["Disconnect"] then
                    v["Disconnect"](v)
                end
            end
        else
            local_player.Idled:Connect(function()
                virtual_user:CaptureController()
                virtual_user:ClickButton2(Vector2.new())
            end)
        end
        library:Notify("Anti Afk Enabled! (Credits to inf yield)")
    end,
    DoubleClick = false,
    Tooltip = 'Credits to inf yield <3',
})

player_group:AddButton({
    Text = 'Rejoin',
    Func = function()
        teleport_service:TeleportToPlaceInstance(game.PlaceId, game.JobId, local_player)
    end,
    DoubleClick = false,
    Tooltip = 'Rejoins server'
})

mine_group:AddToggle('auto_drill', {
    Text = 'Auto Drill',
    Default = auto_drill,
    Tooltip = 'Auto drills for you',

    Callback = function(Value)
        auto_drill = Value
        if Value then
            repeat
                if local_player.Character:FindFirstChildOfClass("Tool") and local_player.Character:FindFirstChildOfClass("Tool").Name:find("Hand") then
                    replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("OreService"):WaitForChild("RE"):WaitForChild("RequestRandomOre"):FireServer()
                end
                if auto_drill_method == "Drill Delay" then
                    task.wait(local_player.Character:FindFirstChildOfClass("Tool"):GetAttribute("ProgressAmt") / 20)
                elseif auto_drill_method == "Custom Delay" then
                    task.wait(custom_drill_delay)
                end
            until not auto_drill
        end
    end
})

mine_group:AddDropdown('drill_method', {
    Values = {'Drill Delay', 'Custom Delay'},
    Default = auto_drill_method,
    Multi = false,

    Text = 'Select Auto Drill Method:',
    Tooltip = 'Select a method to use for auto drill',

    Callback = function(Value)
        auto_drill_method = Value
    end
})

mine_group:AddSlider('custom_delay', {
    Text = 'Custom Delay:',
    Default = custom_drill_delay,
    Min = 0,
    Max = 5,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        custom_drill_delay = Value
    end
})

mine_group:AddDivider()

mine_group:AddToggle('auto_collect_drills', {
    Text = 'Auto Collect Drills',
    Default = auto_collect,
    Tooltip = 'Collects your drills',

    Callback = function(Value)
        auto_collect = Value
        if Value then
            repeat
                for _, v in next, plot.Drills:GetChildren() do
                    if drill_collect_method == "Full" and v:FindFirstChild("DrillData") and not v.DrillData:FindFirstChild("Drilling").Value then
                        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlotService"):WaitForChild("RE"):WaitForChild("CollectDrill"):FireServer(v)
                        task.wait(.5)
                    elseif drill_collect_method == "An Ore" and v:FindFirstChild("Ores") and v.Ores:FindFirstChildOfClass("IntValue") then
                        replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("PlotService"):WaitForChild("RE"):WaitForChild("CollectDrill"):FireServer(v)
                        task.wait(.5)
                    end
                end
                task.wait()
            until not auto_collect
        end
    end
})


mine_group:AddDropdown('drill_collect_method', {
    Values = {'Full', 'An Ore',},
    Default = drill_collect_method,
    Multi = false,

    Text = 'Collect When:',
    Tooltip = 'Select a method to use to collect drills',

    Callback = function(Value)
        drill_collect_method = Value
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
    auto_collect = false
    auto_drill = false
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
save_manager:SetFolder('Astolfo Ware/untitled drill game')
save_manager:BuildConfigSection(tabs['ui settings'])
theme_manager:ApplyToTab(tabs['ui settings'])
save_manager:LoadAutoloadConfig()
