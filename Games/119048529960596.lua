--// If anyone is skidding or reading this mb for the ass optimizations </3
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

local auto_group = tabs.main:AddLeftGroupbox("Auto Settings")
local player_group = tabs.main:AddRightGroupbox("Player Settings")
local misc_group = tabs.main:AddLeftGroupbox("Misc Settings")
local menu_group = tabs["ui settings"]:AddLeftGroupbox("Menu Settings")

local marketplace_service = game:GetService("MarketplaceService")
local replicated_storage = game:GetService("ReplicatedStorage")
local virtual_user = game:GetService("VirtualUser")
local run_service = game:GetService("RunService")
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local stats = game:GetService("Stats")

local info = marketplace_service:GetProductInfo(game.PlaceId)
local get_gc = getconnections or get_signal_cons
local local_player = players.LocalPlayer

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

local auto_dirty_dish = false
local auto_put_orders = false
local auto_give_food = false
local instant_food = false
local auto_order = false
local auto_bills = false
local auto_claim = false
local fast_cook = false
local auto_sit = false
local auto_jar = false

auto_group:AddDivider()

auto_group:AddLabel("Must be near restaurant for features to work!", true)

auto_group:AddDivider()

auto_group:AddToggle('auto_dirty_dish', {
    Text = 'Auto Collect Dirty Dish',
    Default = auto_dirty_dish,
    Tooltip = 'Collects dirty dish on tables',

    Callback = function(Value)
        auto_dirty_dish = Value
        if Value then
            repeat
                for _, v in next, surface:GetDescendants() do
                    if v.Name == "Trash" and v:GetAttribute("Taken") then
                        replicated_storage:WaitForChild("Events"):WaitForChild("Restaurant"):WaitForChild("TaskCompleted"):FireServer({ Tycoon = tycoon, Name = "CollectDishes", FurnitureModel = v.Parent.Parent })
                    end
                end
                task.wait()
            until not auto_dirty_dish
        end
    end
})

auto_group:AddToggle('auto_sit', {
    Text = 'Auto Seat Customers',
    Default = auto_sit,
    Tooltip = 'Automatically gives customers a seat',

    Callback = function(Value)
        auto_sit = Value
        if Value then
            repeat
                for _, v in next, client_customers:GetChildren() do
                    for _, v2 in next, surface:GetChildren() do
                        if v2.Name:find("T") and not v2:GetAttribute("InUse") and v:IsA("Folder") then
                            replicated_storage:WaitForChild("Events"):WaitForChild("Restaurant"):WaitForChild("TaskCompleted"):FireServer({ GroupId = tostring(v.Name), Tycoon = tycoon, Name = "SendToTable", Furniture = v2 })
                        end
                    end
                end
                task.wait(1)
            until not auto_sit
        end
    end
})

auto_group:AddToggle('auto_jar', {
    Text = 'Auto Collect Tip Jar',
    Default = auto_jar,
    Tooltip = 'Collects tip jars',

    Callback = function(Value)
        auto_jar = Value
        if Value then
            repeat
                for _, v in next, furniture:GetDescendants() do
                    if v.Name:find("Jar") and v.Parent:GetAttribute("Value") > 0 then
                        replicated_storage:WaitForChild("Events"):WaitForChild("Restaurant"):WaitForChild("TipsCollected"):FireServer(tycoon)
                    end
                end
                task.wait()
            until not auto_jar
        end
    end
})

auto_group:AddToggle('auto_bills', {
    Text = 'Auto Collect Bills',
    Default = auto_bills,
    Tooltip = 'Auto collects bills from tables',

    Callback = function(Value)
        auto_bills = Value
        if Value then
            repeat
                for _, v in next, surface:GetDescendants() do
                    if v.Name == "Bill" then
                        replicated_storage:WaitForChild("Events"):WaitForChild("Restaurant"):WaitForChild("TaskCompleted"):FireServer({ Tycoon = tycoon, Name = "CollectBill", FurnitureModel = v.Parent })
                    end
                end
                task.wait()
            until not auto_bills
        end
    end
})

auto_group:AddToggle('auto_order', {
    Text = 'Auto Take Orders',
    Default = auto_order,
    Tooltip = 'Automatically takes orders from customers',

    Callback = function(Value)
        auto_order = Value
        if Value then
            repeat
                for _, v in next, client_customers:GetDescendants() do
                    if v:IsA("Model") then
                        replicated_storage:WaitForChild("Events"):WaitForChild("Restaurant"):WaitForChild("TaskCompleted"):FireServer({ GroupId = tostring(v.Parent.Name), Tycoon = tycoon, Name = "TakeOrder", CustomerId = tostring(v.Name) })
                    end
                end
                task.wait(.5)
            until not auto_order
        end
    end
})

auto_group:AddToggle('auto_claim', {
    Text = 'Auto Claim Food',
    Default = auto_claim,
    Tooltip = 'Auto collects food after done with reward',

    Callback = function(Value)
        auto_claim = Value
        if Value then
            repeat
                if local_player.PlayerGui:FindFirstChild("Objectives"):FindFirstChild("Frame"):FindFirstChild("CollectRewardButton").Visible then
                    replicated_storage:WaitForChild("Events"):WaitForChild("Rewards"):WaitForChild("RewardRequested"):FireServer()
                end
                task.wait(2)
                if local_player.PlayerGui:FindFirstChild("SelectReward"):FindFirstChild("Frame").Visible then
                    for _, v in next, local_player.PlayerGui.SelectReward.Frame:FindFirstChild("List"):GetDescendants() do
                        if v:IsA("ImageButton") then
                            for _, v2 in next, (getconnections(v.MouseButton1Click)) do
                                v2:Fire()
                            end
                        end
                    end
                end
                task.wait()
            until not auto_claim
        end
    end
})

-- you can also just fire proximityprompt in temp but i decided to take the long way ahdhasdhashdahsda
auto_group:AddToggle('auto_put_orders', {
    Text = 'Auto Put Orders',
    Default = auto_put_orders,
    Tooltip = 'Puts orders in order counters',

    Callback = function(Value)
        auto_put_orders = Value
        if Value then
            repeat
                if #temp:GetChildren() > 0 then
                    for _, v in next, surface:GetDescendants() do
                        if v.Name:find("Order") and v.Parent.Parent:GetAttribute("InUse") then
                            for _, v2 in next, temp:GetDescendants() do
                                if v2:IsA("ProximityPrompt") then
                                    replicated_storage:WaitForChild("Events"):WaitForChild("Restaurant"):WaitForChild("Interactions"):WaitForChild("Interacted"):FireServer(tycoon, { WorldPosition = v.Parent.Parent:GetPivot().Position, Model = v.Parent.Parent, ActionText = "Cook", InteractionType = "OrderCounter", Part = v.Parent, Prompt = v, TemporaryPart = v.Parent, Id = v.Name })
                                end
                            end
                        end
                    end
                end
                task.wait(.5)
            until not auto_put_orders
        end
    end
})

auto_group:AddToggle('auto_give_food', {
    Text = 'Auto Give Food',
    Default = auto_give_food,
    Tooltip = 'Automatically brings food to customers',

    Callback = function(Value)
        auto_give_food = Value
        if Value then
            repeat
                if #food:GetChildren() > 0 then
                    task.wait(.1)
                    for _, v in next, food:GetChildren() do
                        for _, v2 in next, client_customers:GetDescendants() do
                            if v2:IsA("Model") and v:GetAttribute("Taken") then
                                replicated_storage:WaitForChild("Events"):WaitForChild("Restaurant"):WaitForChild("TaskCompleted"):FireServer({ Name = "Serve", GroupId = tostring(v2.Parent.Name), Tycoon = tycoon, FoodModel = v, CustomerId = tostring(v2.Name) })
                            end
                        end
                        if not v:GetAttribute("Taken") then
                            replicated_storage:WaitForChild("Events"):WaitForChild("Restaurant"):WaitForChild("GrabFood"):InvokeServer(v)
                        end
                    end
                end
                task.wait()
            until not auto_give_food
        end
    end
})

auto_group:AddToggle('instant_food', {
    Text = 'Auto Make Food',
    Default = instant_food,
    Tooltip = 'Makes food very fast',

    Callback = function(Value)
        instant_food = Value
        if Value then
            repeat
                for _, v in next, surface:GetDescendants() do
                    if v.Name:find("Oven") then
                        replicated_storage:WaitForChild("Events"):WaitForChild("Cook"):WaitForChild("CookInputRequested"):FireServer("Interact", v.Parent, "Oven") -- this might not always be accurate to all ovens maybe idk
                    end
                end
                task.wait(.5)
            until not instant_food
        end
    end
})

player_group:AddDivider()

player_group:AddButton({
    Text = 'Anti Afk',
    Func = function()
        if get_gc then
            for _, v in next, get_gc(local_player.Idled) do
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
        library:Notify("Anti Afk Enabled!")
    end,
    DoubleClick = false,
    Tooltip = 'Wont disconnect you after 20 minutes'
})

player_group:AddButton({
    Text = 'Claim Daily Reward',
    Func = function()
        if not tycoon:FindFirstChild("Default"):FindFirstChild("DailyRewards") then
            library:Notify("Already Claimed")
            return
        end
        replicated_storage:WaitForChild("Events"):WaitForChild("DailyRewards"):WaitForChild("DailyRewardClaimed"):FireServer()
        library:Notify("Claimed Daily Reward")
    end,
    DoubleClick = false,
    Tooltip = 'Claims daily reward gift'
})

misc_group:AddDivider()

misc_group:AddButton({
    Text = 'Destory Waypoints',
    Func = function()
        for _, v in next, temp:GetDescendants() do
            if v.Name == "DirectionBeam" then
                v.Parent:Destroy()
            end
        end
        library:Notify("Waypoints Destroyed")
    end,
    DoubleClick = false,
    Tooltip = 'Destroys annoying waypoints'
})

misc_group:AddButton({
    Text = 'Destroy Leftover Cooking Resources',
    Func = function()
        for _, v in next, tycoon.Objects.CookingResources[local_player.Name]:GetChildren() do
            v:Destroy()
        end
        library:Notify("Leftover Cooking Resources Destroyed")
    end,
    DoubleClick = false,
    Tooltip = 'Delete leftover cooking resources'
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
    auto_dirty_dish = false
    auto_put_orders = false
    auto_give_food = false
    instant_food = false
    auto_order = false
    auto_bills = false
    auto_claim = false
    fast_cook = false
    auto_sit = false
    auto_jar = false
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
