-- uhm..............................????? (thx ! nfpw for helping me with stuff <3)
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
    misc = window:AddTab("Misc"),
    ["ui settings"] = window:AddTab("UI Settings")
}

local auto_group = tabs.main:AddLeftGroupbox("Auto Stuff")
local auto_settings_group = tabs.main:AddRightGroupbox("Auto Settings")
local food_group = tabs.main:AddRightGroupbox("Food Settings")
local npc_group = tabs.main:AddRightGroupbox("NPC Settings")
local teleport_group = tabs.misc:AddLeftGroupbox("Teleport Settings")
local player_group = tabs.misc:AddRightGroupbox("Player Settings")
local menu_group = tabs["ui settings"]:AddLeftGroupbox("Menu Settings")

local marketplace_service = game:GetService("MarketplaceService")
local user_input_service = game:GetService("VirtualInputManager")
local replicated_storage = game:GetService("ReplicatedStorage")
local virtual_user = game:GetService("VirtualUser")
local run_service = game:GetService("RunService")
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local stats = game:GetService("Stats")

local info = marketplace_service:GetProductInfo(game.PlaceId)
local get_gc = getconnections or get_signal_cons
local local_player = players.LocalPlayer

if not get_gc then
    local_player:Kick("Exploit not supported!")
end

local tycoon = nil

for _, v in next, workspace:FindFirstChild("Tycoons"):GetDescendants() do
    if v.Name == "Player" and v.Value == local_player then
        tycoon = v.Parent
    end
end

if not tycoon then
    local_player:Kick("Player restaurant not found!")
end

local client_customers = tycoon:FindFirstChild("ClientCustomers")

if not client_customers then
    local_player:Kick("Load in your tycoon first fully!")
end

local items = tycoon:FindFirstChild("Items")

if not items then
    local_player:Kick("Items folder not found!")
end

local food = tycoon:FindFirstChild("Objects"):FindFirstChild("Food")

if not food then
    local_player:Kick("Food folder not found!")
end

local furniture = items:FindFirstChild("Furniture")
local surface = items:FindFirstChild("Surface")

if not (furniture and surface) then
    local_player:Kick("???")
end

local temp = workspace:FindFirstChild("Temp")

if not temp then
    local_player:Kick("Temp folder not found!")
end

local buildings = workspace:FindFirstChild("Exteriors")

if not buildings then
    local_player:Kick("Buildings folder not found!")
end

local ingredient_module = require(replicated_storage:FindFirstChild("Source"):FindFirstChild("Data"):FindFirstChild("Food"):FindFirstChild("IngredientData"))

if not ingredient_module then
    local_player:Kick("Ingredient module not found!")
end

local path_utility = require(replicated_storage:FindFirstChild("Source"):FindFirstChild("Utility"):FindFirstChild("NPC"):FindFirstChild("PathUtility"))

if not path_utility then
    local_player:Kick("Path utility not found!")
end

getgenv().settings = {
    auto_dirty_dish = false,
    auto_give_food = false,
    auto_do_order = false,
    auto_order = false,
    auto_bill = false,
    auto_cook = false,
    auto_seat = false,
    fast_npcs = false,
    auto_tip = false,
    toggle_delay = 0.1,
    selected_place = "",
    selected_food = "",
}

local building_names = {}
local ingredients = {}

for _, v in next, ingredient_module do
    for i, v2 in next, v do
        if i == "DisplayName" then
            table.insert(ingredients, v2)
        end
    end
end

for _, v in next, buildings:GetChildren() do
    table.insert(building_names, v.Name)
end

table.insert(building_names, "Tycoon")

-- you can mess around w this idk
func = hookfunction(path_utility.GetMovementTime, function(...)
    if settings.fast_npcs then
        return 0.01
    end
    return func(...)
end)

surface.DescendantAdded:Connect(function(v)
    task.wait(1)
    if settings.auto_dirty_dish and v.Name == "Trash" and v:GetAttribute("Taken") and v.Parent then
        replicated_storage:WaitForChild("Events"):WaitForChild("Restaurant"):WaitForChild("TaskCompleted"):FireServer({ Tycoon = tycoon, Name = "CollectDishes", FurnitureModel = v.Parent.Parent })
    end

    if settings.auto_bill and v.Name == "Bill" and v.Parent then
        replicated_storage:WaitForChild("Events"):WaitForChild("Restaurant"):WaitForChild("TaskCompleted"):FireServer({ Tycoon = tycoon, Name = "CollectBill", FurnitureModel = v.Parent })
    end
end)

auto_group:AddDivider()

auto_group:AddLabel("Be near the restaurant for the features to work", true)

auto_group:AddDivider()

auto_group:AddToggle('auto_order', {
    Text = 'Auto Take Customer Orders',
    Default = settings.auto_order,
    Tooltip = 'Collects dirty dish on tables',

    Callback = function(Value)
        settings.auto_order = Value
        if Value then
            repeat
                for _, v in next, local_player.PlayerGui:GetDescendants() do
                    if v:IsA("ImageLabel") and v.Parent.Parent.Parent.Name == "CustomerSpeechUI" and v.Parent.Parent.Size == UDim2.new(1, 0, 1, 0) then
                        local group = v.Parent.Parent.Parent.Adornee.Parent.Parent.Name
                        local customer = v.Parent.Parent.Parent.Adornee.Parent.Name
                        replicated_storage:WaitForChild("Events"):WaitForChild("Restaurant"):WaitForChild("TaskCompleted"):FireServer({ GroupId = tostring(group), Tycoon = tycoon, Name = "TakeOrder", CustomerId = tostring(customer) })
                        task.wait()
                    end
                end
                task.wait(settings.toggle_delay)
            until not settings.auto_order
        end
    end
})

auto_group:AddToggle('auto_dirty_dish', {
    Text = 'Auto Collect Dirty Dish',
    Default = settings.auto_dirty_dish,
    Tooltip = 'Collects dirty dishes on tables',

    Callback = function(Value)
        settings.auto_dirty_dish = Value
        if Value then
            for _, v in next, surface:GetDescendants() do
                if v.Name == "Trash" and v:GetAttribute("Taken") then
                    replicated_storage:WaitForChild("Events"):WaitForChild("Restaurant"):WaitForChild("TaskCompleted"):FireServer({ Tycoon = tycoon, Name = "CollectDishes", FurnitureModel = v.Parent.Parent })
                end
            end
        end
    end
})

auto_group:AddToggle('auto_seat', {
    Text = 'Auto Seat Customers',
    Default = settings.auto_seat,
    Tooltip = 'Automatically seats customers',

    Callback = function(Value)
        settings.auto_seat = Value
        if Value then
            repeat
                for _, v in next, local_player.PlayerGui:GetDescendants() do
                    if v:IsA("TextLabel") and v.Text:find("table") and v.Parent.Parent.Parent.Name == "CustomerSpeechUI" and v.Parent.Parent.Size == UDim2.new(1, 0, 1, 0) then
                        for _, v2 in next, surface:GetChildren() do
                            if v2.Name:find("T") and not v2:GetAttribute("InUse") then
                                local group = v.Parent.Parent.Parent.Adornee.Parent.Parent.Name
                                replicated_storage:WaitForChild("Events"):WaitForChild("Restaurant"):WaitForChild("TaskCompleted"):FireServer({ GroupId = tostring(group), Tycoon = tycoon, Name = "SendToTable", FurnitureModel = v2 })
                                task.wait()
                            end
                        end
                    end
                end
                task.wait(settings.toggle_delay)
            until not settings.auto_seat
        end
    end
})

auto_group:AddToggle('auto_bill', {
    Text = 'Auto Collect Bills',
    Default = settings.auto_bill,
    Tooltip = 'Collects dirty dishes on tables',

    Callback = function(Value)
        settings.auto_bill = Value
        if Value then
            for _, v in next, surface:GetDescendants() do
                if v.Name == "Bill" then
                    replicated_storage:WaitForChild("Events"):WaitForChild("Restaurant"):WaitForChild("TaskCompleted"):FireServer({ Tycoon = tycoon, Name = "CollectBill", FurnitureModel = v.Parent })
                end
            end
        end
    end
})

auto_group:AddToggle('auto_give_food', {
    Text = 'Auto Give Food',
    Default = settings.auto_give_food,
    Tooltip = 'Automatically brings food to customers',

    Callback = function(Value)
        settings.auto_give_food = Value
        if Value then
            repeat
                if #food:GetChildren() > 0 then
                    for _, v in next, food:GetChildren() do
                        if not v:GetAttribute("Taken") then
                            replicated_storage:WaitForChild("Events"):WaitForChild("Restaurant"):WaitForChild("GrabFood"):InvokeServer(v)
                            for _, v2 in next, local_player.PlayerGui:GetDescendants() do
                                if v2:IsA("ImageLabel") and v2.Parent and v2.Parent.Parent.Parent.Name == "CustomerSpeechUI" and v2.Parent.Parent.Size == UDim2.new(1, 0, 1, 0) then
                                    local group = v2.Parent.Parent.Parent.Adornee.Parent.Parent.Name
                                    local customer = v2.Parent.Parent.Parent.Adornee.Parent.Name
                                    replicated_storage:WaitForChild("Events"):WaitForChild("Restaurant"):WaitForChild("TaskCompleted"):FireServer({ Name = "Serve", GroupId = tostring(group), Tycoon = tycoon, FoodModel = v, CustomerId = tostring(customer) })
                                    task.wait()
                                end
                            end
                        end
                    end
                end
                task.wait(settings.toggle_delay)
            until not settings.auto_give_food
        end
    end
})

auto_group:AddToggle('auto_do_order', {
    Text = 'Auto Do Orders',
    Default = settings.auto_do_order,
    Tooltip = 'Takes orders from order booths',

    Callback = function(Value)
        settings.auto_do_order = Value
        if Value then
            repeat
                if #temp:GetChildren() > 0 then
                    for _, v in next, temp:GetDescendants() do
                        if v:IsA("ProximityPrompt") then
                            fireproximityprompt(v)
                            task.wait()
                        end
                    end
                end
                task.wait(settings.toggle_delay)
            until not settings.auto_do_order
        end
    end
})

auto_group:AddToggle('auto_cook', {
    Text = 'Auto Cook',
    Default = settings.auto_cook,
    Tooltip = 'Automatically cooks food',

    Callback = function(Value)
        settings.auto_cook = Value
        if Value then
            local oven = nil
            for _, v in next, surface:GetDescendants() do
                if v.Name:find("Oven") then
                    oven = v.Parent
                    break
                end
            end
            repeat
                if oven then
                    replicated_storage:WaitForChild("Events"):WaitForChild("Cook"):WaitForChild("CookInputRequested"):FireServer("Interact", oven, "Oven")
                    task.wait()
                end
                task.wait(settings.toggle_delay)
            until not settings.auto_cook
        end
    end
})

auto_group:AddToggle('auto_tip', {
    Text = 'Auto Tip',
    Default = settings.auto_tip,
    Tooltip = 'Automatically takes tips from jars',

    Callback = function(Value)
        settings.auto_tip = Value
        if Value then
            repeat
                replicated_storage:WaitForChild("Events"):WaitForChild("Restaurant"):WaitForChild("TipsCollected"):FireServer(tycoon)
                task.wait(settings.toggle_delay)
            until not settings.auto_tip
        end
    end
})

auto_settings_group:AddDivider()

auto_settings_group:AddSlider('toggle_delay', {
    Text = 'Toggle Repeat Delay',
    Default = settings.toggle_delay,
    Min = 0,
    Max = 5,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        settings.toggle_delay = Value
        if Value == 0 then
            library:Notify("0 Is Not Recommended As It May Cause Lag")
        end
    end
})

food_group:AddDivider()

food_group:AddDropdown('selected_food', {
    Values = ingredients,
    Default = settings.selected_food,
    Multi = false,

    Text = 'Select Ingredient To Buy:',
    Tooltip = 'Buys the Ingredient you picked when you press the button',

    Callback = function(Value)
        settings.selected_food = Value
    end
})

food_group:AddButton({
    Text = 'Buy Ingredient',
    Func = function()
        if settings.selected_food ~= "" then
            replicated_storage:WaitForChild("Events"):WaitForChild("Food"):WaitForChild("PurchaseIngredientRequested"):FireServer(tycoon, tostring(selected_food))
            library:Notify("Bought "..settings.selected_food)    
        else
            library:Notify("Please select an ingredient")
        end
    end
})

npc_group:AddDivider()

npc_group:AddToggle('fast_npcs', {
    Text = 'Fast Npcs',
    Default = settings.fast_npcs,
    Tooltip = 'Makes all npcs teleport instant [Breaks Chefs!]',

    Callback = function(Value)
        settings.fast_npcs = Value
    end
})

teleport_group:AddDivider()

teleport_group:AddDropdown('selected_place', {
    Values = building_names,
    Default = settings.selected_place,
    Multi = false,

    Text = 'Select Place To Teleport To:',
    Tooltip = 'Teleports to the place you picked when you press the butto',

    Callback = function(Value)
        settings.selected_place = Value
    end
})

teleport_group:AddButton({
    Text = 'Teleport To Selected Place',
    Func = function()
        if selected_place == "" then
            library:Notify("Please select a place")
            return
        end

        if settings.selected_place == "Tycoon" then
            local_player.Character:SetPrimaryPartCFrame(tycoon:FindFirstChild("Locations"):FindFirstChild("DefaultWalkPoint").Value)
        elseif settings.selected_place == "FishShop" then
            local_player.Character:MoveTo(buildings[settings.selected_place]:FindFirstChild("FishmongerNPC"):GetPivot().Position)
        elseif settings.selected_place == "FarmerMarket" then
            local_player.Character:MoveTo(buildings[settings.selected_place]:FindFirstChild("FarmerNPC"):GetPivot().Position)
        elseif not (settings.selected_place == "Tycoon" or settings.selected_place == "FishShop" or settings.selected_place == "FarmerMarket") then
            replicated_storage:WaitForChild("Events"):WaitForChild("Teleports"):WaitForChild("RequestTeleport"):InvokeServer(settings.selected_place.."Interior")
        end
        library:Notify("Teleported to "..settings.selected_place)
    end,
    DoubleClick = false,
    Tooltip = 'Teleports you to selected place'
})

player_group:AddDivider()

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
    Tooltip = 'Wont disconnect you after 20 minutes'
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
    settings.auto_dirty_dish = false
    settings.auto_give_food = false
    settings.auto_do_order = false
    settings.auto_order = false
    settings.fast_npcs = false
    settings.auto_bill = false
    settings.auto_cook = false
    settings.auto_seat = false
    settings.auto_tip = false
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
save_manager:SetFolder('Astolfo Ware/Restaurant Tycoon 3')
save_manager:BuildConfigSection(tabs['ui settings'])
theme_manager:ApplyToTab(tabs['ui settings'])
save_manager:LoadAutoloadConfig()
