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
    Title = 'Astolfo Ware | Made By @kylosilly | Have Fun Patching <3',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local tabs = {
    main = window:AddTab('Main'),
    auto = window:AddTab('Auto'),
    misc = window:AddTab('Misc'),
    ['ui settings'] = window:AddTab('UI Settings')
}

local game_group = tabs.main:AddLeftGroupbox('Game Settings')
local misc_group = tabs.main:AddRightGroupbox('Misc Settings')
local farm_group = tabs.auto:AddLeftGroupbox('Auto Farm Settings')
local shop_group = tabs.auto:AddRightGroupbox('Shop Stuff')
local enchant_group = tabs.auto:AddRightGroupbox('Auto Enchant Settings')
local teleport_group = tabs.misc:AddLeftGroupbox('Teleport Settings')
local player_group = tabs.misc:AddRightGroupbox('Player Settings')
local menu_group = tabs['ui settings']:AddLeftGroupbox('Menu')

local replicated_storage = cloneref(game:GetService("ReplicatedStorage"))
local user_input_service = cloneref(game:GetService("UserInputService"))
local teleport_service = cloneref(game:GetService("TeleportService"))
local market = cloneref(game:GetService("MarketplaceService"))
local virtual_user = cloneref(game:GetService('VirtualUser'))
local run_service = cloneref(game:GetService("RunService"))
local workspace = cloneref(game:GetService("Workspace"))
local players = cloneref(game:GetService("Players"))
local stats = cloneref(game:GetService("Stats"))
local info = market:GetProductInfo(game.PlaceId)
local getgc = getconnections or get_signal_cons
local local_player = players.LocalPlayer
local camera = workspace.CurrentCamera

local player_functions = require(replicated_storage.Modules.PlayerFunctions)
local client_utlility = require(replicated_storage.Modules.ClientUtility)
local game_state = require(replicated_storage.Modules.GameState)
local teleports = require(replicated_storage.Modules.Teleport)
local tables = require(replicated_storage.Modules.Table)

local slot1 = local_player.PlayerGui.ScreenGui.Enchant.Content.Slots["1"].EnchantName
local slot2 = local_player.PlayerGui.ScreenGui.Enchant.Content.Slots["2"].EnchantName

local custom_message = false
local auto_enchant = false
local show_health = false
local auto_mine = false
local auto_sell = false
local inf_jump = false
local view_ore = false
local delay = false

local selected_enchantment = ""
local selected_pickaxe = ""
local enchant_pickaxe = ""
local selected_npc = ""
local selected_ore = ""

local selected_amount = 1
local selected_slot = 1
local sell_delay = 1

local enchantments = {
    "Abnormal Speed",
    "Light Damage",
    "Considerable Luck",
    "More Damage",
    "Mighty Luck",
    "Deadly Damage",
    "Mighty++ Luck",
    "Deadly++ Damage",
    "Incredible Luck",
    "Incredible Damage",
    "Magic Ores"
}

local node_name = {}
local pickaxes = {}
local npcs = {}

local node_names = replicated_storage:FindFirstChild("Nodes")
local items = replicated_storage:FindFirstChild("Items")
local nodes = workspace:FindFirstChild("Nodes")
local npc = workspace:FindFirstChild("NPCs")

local selected_level = "Level 1"

for _, v in next, node_names:GetChildren() do
    table.insert(node_name, v.Name)
end

for _, v in next, items:GetChildren() do
    if v.Name:find("Pickaxe") or v.Name:find("Pick") or v.Name:find("Chopper") or v.Name:find("Sharkee") or v.Name:find("Demonaxe") then
        table.insert(pickaxes, v.Name)
    end
end

for _, v in next, npc:GetChildren() do
    table.insert(npcs, v.Name)
end

function closest_ore()
    local ore = nil;
    local max_distance = math.huge;

    for _, v in next, nodes:GetChildren() do
        if v:FindFirstChild("Info") and v.Info:FindFirstChild("Frame") and v.Info.Frame:FindFirstChild("SeedTitle") and v.Info.Frame.SeedTitle.Text == selected_ore then
            local distance = (local_player.Character:GetPivot().Position - v:GetPivot().Position).magnitude
            if distance < max_distance then
                max_distance = distance
                ore = v
            end
        end
    end

    return ore
end

user_input_service.JumpRequest:Connect(function()
    if inf_jump and not delay then
        delay = true
        local_player.Character:FindFirstChild("Humanoid"):ChangeState("Jumping")
        wait()
        delay = false
    end
end)

game_group:AddButton({
    Text = "Unlock Level 2",
    Func = function()
        local progression = game_state:GetData().Progression["Unlocked Level 2 Keyhole"]

        if not (progression and progression.Complete) then
            replicated_storage:WaitForChild("Remotes"):WaitForChild("GrabLevel2Key"):FireServer()
            replicated_storage:WaitForChild("Remotes"):WaitForChild("UnlockLevel2Keyhole"):FireServer()
        else
            client_utlility:AddNotification("Already unlocked level 2", Color3.fromRGB(255, 105, 180), 1)
        end
    end,
    DoubleClick = false,
    Tooltip = 'Unlocks elevator level 2'
})

game_group:AddButton({
    Text = 'Unlock Cave',
    Func = function()
        if game_state:GetData().Money < 450 then
            client_utlility:AddNotification("Not Enough Money", Color3.fromRGB(255, 105, 180), 1)
            return
        end
        for i = 1,3 do
            replicated_storage:WaitForChild("Remotes"):WaitForChild("BuyTool"):FireServer("Dynamite")
        end
        task.wait(.1)
        for i = 1,3 do
            replicated_storage:WaitForChild("Remotes"):WaitForChild("PlaceDynamite"):FireServer(i)
        end
        task.wait(.1)
        replicated_storage:WaitForChild("Remotes"):WaitForChild("DetonateDynamite"):FireServer()
    end,
    DoubleClick = false,
    Tooltip = 'Unlocks cave enterance'
})

game_group:AddButton({
    Text = 'Unlock Drilling Door',
    Func = function()
        if game_state:GetData().Money < 9999 then
            client_utlility:AddNotification("Not Enough Money", Color3.fromRGB(255, 105, 180), 1)
            return
        end
        replicated_storage:WaitForChild("Remotes"):WaitForChild("GetDialogue"):InvokeServer("John", 3, 1)
        replicated_storage:WaitForChild("Remotes"):WaitForChild("UseKey"):FireServer("Drilling Site Key")
    end,
    DoubleClick = false,
    Tooltip = 'Unlocks drilling enterance'
})

game_group:AddDivider()

game_group:AddDropdown('level_selector', {
    Values = { 'Level 1', 'Level 2' },
    Default = selected_level,
    Multi = false,

    Text = 'Select Level:',
    Tooltip = 'Select a elevator level to teleport to',

    Callback = function(Value)
        selected_level = Value
    end
})

game_group:AddButton({
    Text = "Teleport To Choosen Level",
    Func = function()
        if selected_level == "Level 1" then
            teleports:UseElevator("Level 1")
            return
        elseif selected_level == "Level 2" then
            local progression = game_state:GetData().Progression["Unlocked Level 2 Keyhole"]

            if not (progression and progression.Complete) then
                client_utlility:AddNotification("You need to unlock level 2 keyhole first", Color3.fromRGB(255, 105, 180), 1)
                return
            end

            teleports:UseElevator("Level 2")
        end
    end,
    DoubleClick = false,
    Tooltip = 'Teleports to choosen level'
})

misc_group:AddButton({
    Text = 'Sell All [Testing]',
    Func = function()
        replicated_storage:WaitForChild("Remotes"):WaitForChild("SellAll"):FireServer()
    end,
    DoubleClick = true,
    Tooltip = 'Sells every ore in your inventory'
})

misc_group:AddDivider()

misc_group:AddToggle('auto_sell', {
    Text = 'Auto Sell',
    Default = auto_sell,
    Tooltip = 'Automatically sells everything for you',

    Callback = function(Value)
        auto_sell = Value
        if Value then
            repeat
                replicated_storage:WaitForChild("Remotes"):WaitForChild("SellAll"):FireServer()
                task.wait(sell_delay)
            until not auto_sell
        end
    end
})

misc_group:AddSlider('auto_sell_delay', {
    Text = 'Auto Sell Delay (Seconds)',
    Default = sell_delay,
    Min = 0,
    Max = 60,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        sell_delay = Value
    end
})

misc_group:AddDivider()

misc_group:AddButton({
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
        client_utlility:AddNotification("Anti Afk Enabled", Color3.fromRGB(255, 105, 180), 1)
    end,
    DoubleClick = false,
    Tooltip = 'Credits to inf yield <3',
})

misc_group:AddButton({
    Text = 'Rejoin',
    Func = function()
        queue_on_teleport([[
            loadstring(game:HttpGet("https://raw.githubusercontent.com/kylosilly/astolfoware/refs/heads/main/astolfo%20ware%20loader.lua"))()
        ]])

        teleport_service:TeleportToPlaceInstance(game.PlaceId, game.JobId, local_player)
    end,
    DoubleClick = false,
    Tooltip = 'Rejoins the game'
})

farm_group:AddDropdown('ore_selector', {
    Values = node_name,
    Default = selected_ore,
    Multi = false,

    Text = 'Select Ore To Mine:',
    Tooltip = 'Select a ore to auto mine',

    Callback = function(Value)
        selected_ore = Value
    end
})

farm_group:AddToggle('auto_mine', {
    Text = 'Auto Mine',
    Default = auto_mine,
    Tooltip = 'Automatically mines for you from anywhere',

    Callback = function(Value)
        auto_mine = Value
        if Value then
            if selected_ore == "" then
                client_utlility:AddNotification("You need to select an ore to mine first", Color3.fromRGB(255, 105, 180), 1)
                return
            end
            repeat
                local ore = closest_ore()
                if ore and game_state:GetData():PickaxeIsEquipped() then
                    replicated_storage:WaitForChild("Remotes"):WaitForChild("DamageNode"):FireServer(ore.Name)
                end
                if ore and show_health and ore:FindFirstChild("Info") then
                    ore.Info.Enabled = true
                end
                if ore and view_ore then
                    camera.CameraType = "Custom"
                    camera.CameraSubject = ore.PrimaryPart
                end
                task.wait(player_functions:GetPickaxeSpeed(game_state:GetData()))
            until not auto_mine
        end
    end
})

farm_group:AddToggle('show_health', {
    Text = 'Show Ore Health',
    Default = show_health,
    Tooltip = 'Enabled the info billboard',

    Callback = function(Value)
        show_health = Value
        if not Value then
            for _, v in next, nodes:GetChildren() do
                if v:IsA("Model") and v:FindFirstChild("Info") then
                    v.Info.Enabled = false
                end
            end
        end
    end
})

farm_group:AddToggle('view_ore', {
    Text = 'View Closest Ore',
    Default = view_ore,
    Tooltip = 'Views closest ore',

    Callback = function(Value)
        view_ore = Value
        if not Value then
            camera.CameraSubject = local_player.Character.Humanoid
        end
    end
})

farm_group:AddDivider()

farm_group:AddButton({
    Text = 'Goto Safe Spot',
    Func = function()
        if not workspace:FindFirstChild("Safe") then
            local part = Instance.new("Part", workspace)
            part.Size = Vector3.new(50, 2, 50)
            part.CFrame = CFrame.new(9999, 9999, 9999)
            part.Anchored = true
            part.Name = "Safe"
        end
        local_player.Character.PrimaryPart.CFrame = workspace.Safe.CFrame + Vector3.new(0, 5, 0)
    end,
    DoubleClick = false,
    Tooltip = 'Teleports you somewhere where nobody can see you'
})

shop_group:AddDropdown('pickaxe_selector', {
    Values = pickaxes,
    Default = selected_pickaxe,
    Multi = false,

    Text = 'Select Pickaxe To Buy:',
    Tooltip = 'buys selected pickaxe from dropdown',

    Callback = function(Value)
        selected_pickaxe = Value
    end
})

shop_group:AddSlider('buy_amount', {
    Text = 'How Many Times To Buy Item:',
    Default = selected_amount,
    Min = 1,
    Max = 1000,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        selected_amount = Value
    end
})

shop_group:AddButton({
    Text = 'Buy Pickaxe',
    Func = function()
        if selected_pickaxe == "" then
            client_utlility:AddNotification("You need to select a pickaxe to buy first", Color3.fromRGB(255, 105, 180), 1)
            return
        end
        replicated_storage:WaitForChild("Remotes"):WaitForChild("BuyTool"):FireServer(selected_pickaxe, selected_amount)
        client_utlility:AddNotification("Bought "..selected_amount.." "..selected_pickaxe, Color3.fromRGB(255, 105, 180), 1)
    end,
    DoubleClick = false,
    Tooltip = 'Buys selected pickaxe'
})

enchant_group:AddLabel("Go in enchant gui and select the selected pickaxe before using!", true)

enchant_group:AddDropdown('enchant_selector', {
    Values = enchantments,
    Default = selected_enchantment,
    Multi = false,

    Text = 'Select A Enchant:',
    Tooltip = 'Select a enchant to enchant your pickaxe to', 

    Callback = function(Value)
        selected_enchantment = Value
    end
})

enchant_group:AddDropdown('pickaxe_selector', {
    Values = pickaxes,
    Default = enchant_pickaxe,
    Multi = false,

    Text = 'Select A Pickaxe:',
    Tooltip = 'Select a pickaxe to enchant', 

    Callback = function(Value)
        enchant_pickaxe = Value
    end
})

enchant_group:AddDropdown('slot_selector', {
    Values = { '1', '2' },
    Default = selected_slot,
    Multi = false,

    Text = 'Select Slot To Enchant:',
    Tooltip = 'This is a tooltip',

    Callback = function(Value)
        selected_slot = Value
    end
})

enchant_group:AddToggle('auto_enchant', {
    Text = 'Auto Enchant',
    Default = auto_enchant,
    Tooltip = 'Auto Enchants Pickaxe',

    Callback = function(Value)
        auto_enchant = Value
        if Value then
            if enchant_pickaxe == "" then
                client_utlility:AddNotification("You need to select a pickaxe to enchant first", Color3.fromRGB(255, 105, 180), 1)
                return
            end

            if not local_player.PlayerGui.ScreenGui.Enchant.Visible then
                client_utlility:AddNotification("Open enchant UI and select pickaxe first!", Color3.fromRGB(255, 105, 180), 1)
                return
            end

            local index = i
            for i, v in next, game_state:GetData().Inventory do
                if v.Name == enchant_pickaxe then
                    index = i
                    break
                end
            end

            if not index then
                client_utlility:AddNotification("Pickaxe not found", Color3.fromRGB(255, 105, 180), 1)
                return
            end
            
            repeat
                if selected_slot == 1 and slot1.Text == selected_enchantment then
                    return
                elseif selected_slot == 2 and slot2.Text == selected_enchantment then
                    return
                end

                replicated_storage:WaitForChild("Remotes"):WaitForChild("Enchant"):FireServer(index, selected_slot)
                task.wait(.1)
            until (selected_slot == 1 and slot1.Text == selected_enchantment) or (selected_slot == 2 and slot2.Text == selected_enchantment) or not auto_enchant or not local_player.PlayerGui.ScreenGui.Enchant.Visible
        end
    end
})

teleport_group:AddDropdown('npc_selector', {
    Values = npcs,
    Default = selected_npc,
    Multi = false,

    Text = 'Select Npc To Teleport To:',
    Tooltip = 'Teleports you to selected npc',

    Callback = function(Value)
        selected_npc = Value
    end
})

teleport_group:AddButton({
    Text = 'Teleport To Npc',
    Func = function()
        if selected_npc == "" then
            client_utlility:AddNotification("You need to select a npc to teleport to first", Color3.fromRGB(255, 105, 180), 1)
            return
        end
        for _, v in next, npc:GetChildren() do
            if v.Name == selected_npc then
                local_player.Character.PrimaryPart.CFrame = v.PrimaryPart.CFrame + v.PrimaryPart.CFrame.LookVector * 5
            end
        end
    end,
    DoubleClick = false,
    Tooltip = 'Teleports to selected npc'
})

player_group:AddSlider('fov_Changer', {
    Text = 'FOV Changer',
    Default = camera.FieldOfView,
    Min = 1,
    Max = 120,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        camera.FieldOfView = Value
    end
})

player_group:AddSlider('walkspeed_Changer', {
    Text = 'Walkspeed Changer',
    Default = local_player.Character.Humanoid.WalkSpeed,
    Min = 16,
    Max = 100,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        local_player.Character.Humanoid.WalkSpeed = Value
    end
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
    custom_message = false
    auto_enchant = false
    show_health = false
    auto_mine = false
    auto_sell = false
    view_ore = false
    inf_jump = false
    camera.FieldOfView = 70
    local_player.Character.Humanoid.WalkSpeed = 16
    camera.CameraSubject = local_player.Character.Humanoid
    for _, v in next, nodes:GetChildren() do
        if v:IsA("Model") and v:FindFirstChild("Info") then
            v.Info.Enabled = false
        end
    end
    if workspace:FindFirstChild("Safe") then
        workspace.Safe:Destroy()
    end
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
save_manager:SetFolder('Astolfo Ware/Mining World')
save_manager:BuildConfigSection(tabs['ui settings'])
theme_manager:ApplyToTab(tabs['ui settings'])
save_manager:LoadAutoloadConfig()
