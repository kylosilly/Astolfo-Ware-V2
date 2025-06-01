-- uhm..............................?????
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

local auto_group = tabs.main:AddLeftGroupbox("Auto Stuff")
local auto_settings_group = tabs.main:AddRightGroupbox("Auto Settings")
--[[
local player_group = tabs.main:AddRightGroupbox("Player Settings")
local misc_group = tabs.main:AddLeftGroupbox("Misc Settings")
local restaurant_group = tabs.main:AddRightGroupbox("Restaurant Settings")
]]
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
local auto_give_food = false
local auto_do_order = false
local auto_order = false
local auto_bill = false
local auto_cook = false
local auto_seat = false

local toggle_delay = 0.1

surface.DescendantAdded:Connect(function(v)
    task.wait(1)
    if auto_dirty_dish and v.Name == "Trash" and v:GetAttribute("Taken") then
        replicated_storage:WaitForChild("Events"):WaitForChild("Restaurant"):WaitForChild("TaskCompleted"):FireServer({ Tycoon = tycoon, Name = "CollectDishes", FurnitureModel = v.Parent.Parent })
    end

    if auto_bill and v.Name == "Bill" then
        replicated_storage:WaitForChild("Events"):WaitForChild("Restaurant"):WaitForChild("TaskCompleted"):FireServer({ Tycoon = tycoon, Name = "CollectBill", FurnitureModel = v.Parent })
    end
end)

auto_group:AddDivider()

auto_group:AddLabel("Be near the restaurant for the features to work", true)

auto_group:AddDivider()

auto_group:AddToggle('auto_order', {
    Text = 'Auto Take Customer Orders',
    Default = auto_order,
    Tooltip = 'Collects dirty dish on tables',

    Callback = function(Value)
        auto_order = Value
        if Value then
            repeat
                for _, v in next, local_player.PlayerGui:GetDescendants() do
                    if v:IsA("ImageLabel") and v.Visible and v.Parent and v.Parent.Parent.Parent.Name == "CustomerSpeechUI" then
                        replicated_storage:WaitForChild("Events"):WaitForChild("Restaurant"):WaitForChild("TaskCompleted"):FireServer({ GroupId = tostring(v.Parent.Parent.Parent.Adornee.Parent.Parent.Name), Tycoon = tycoon, Name = "TakeOrder", CustomerId = tostring(v.Parent.Parent.Parent.Adornee.Parent.Name) })
                        task.wait()
                    end
                end
                task.wait(toggle_delay)
            until not auto_order
        end
    end
})

auto_group:AddToggle('auto_dirty_dish', {
    Text = 'Auto Collect Dirty Dish',
    Default = auto_dirty_dish,
    Tooltip = 'Collects dirty dishes on tables',

    Callback = function(Value)
        auto_dirty_dish = Value
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
    Default = auto_seat,
    Tooltip = 'Automatically seats customers',

    Callback = function(Value)
        auto_seat = Value
        if Value then
            repeat
                for _, v in next, local_player.PlayerGui:GetDescendants() do
                    if v:IsA("TextLabel") and v.Text:find("table") and v.Parent and v.Parent.Parent.Parent.Name == "CustomerSpeechUI" then
                        for _, v2 in next, surface:GetChildren() do
                            if v2.Name:find("T") and not v2:GetAttribute("InUse") then
                                replicated_storage:WaitForChild("Events"):WaitForChild("Restaurant"):WaitForChild("TaskCompleted"):FireServer({ GroupId = tostring(v.Parent.Parent.Parent.Adornee.Parent.Parent.Name), Tycoon = tycoon, Name = "SendToTable", FurnitureModel = v2 })
                                task.wait()
                            end
                        end
                    end
                end
                task.wait(toggle_delay)
            until not auto_seat
        end
    end
})

auto_group:AddToggle('auto_bill', {
    Text = 'Auto Collect Bills',
    Default = auto_bill,
    Tooltip = 'Collects dirty dishes on tables',

    Callback = function(Value)
        auto_bill = Value
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
    Default = auto_give_food,
    Tooltip = 'Automatically brings food to customers',

    Callback = function(Value)
        auto_give_food = Value
        if Value then
            repeat
                if #food:GetChildren() > 0 and #client_customers:GetChildren() > 0 then
                    for _, v in next, food:GetChildren() do
                        for _, v2 in next, local_player.PlayerGui:GetDescendants() do
                            if not v:GetAttribute("Taken") then
                                replicated_storage:WaitForChild("Events"):WaitForChild("Restaurant"):WaitForChild("GrabFood"):InvokeServer(v)
                                task.wait()
                            end
                            if v2:IsA("ImageLabel") and v2.Visible and v2.Parent and v2.Parent.Parent.Parent.Name == "CustomerSpeechUI" then
                                replicated_storage:WaitForChild("Events"):WaitForChild("Restaurant"):WaitForChild("TaskCompleted"):FireServer({ Name = "Serve", GroupId = tostring(v2.Parent.Parent.Parent.Adornee.Parent.Parent.Name), Tycoon = tycoon, FoodModel = v, CustomerId = tostring(v2.Parent.Parent.Parent.Adornee.Parent.Name) })
                                task.wait()
                            end
                        end
                    end
                end
                task.wait(toggle_delay)
            until not auto_give_food
        end
    end
})

auto_group:AddToggle('auto_do_order', {
    Text = 'Auto Do Orders',
    Default = auto_do_order,
    Tooltip = 'Does orders for customers',

    Callback = function(Value)
        auto_do_order = Value
        if Value then
            repeat
                if #temp:GetChildren() > 0 then
                    for _, v in next, temp:GetChildren() do
                        if v:IsA("Part") and v:FindFirstChildOfClass("ProximityPrompt") then
                            fireproximityprompt(v:FindFirstChildOfClass("ProximityPrompt"))
                            task.wait()
                        end
                    end
                end
                task.wait(toggle_delay)
            until not auto_do_order
        end
    end
})

auto_group:AddToggle('auto_cook', {
    Text = 'Auto Cook',
    Default = auto_cook,
    Tooltip = 'Automatically cooks food',

    Callback = function(Value)
        auto_cook = Value
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
                elseif not oven then
                    library:Notify("No Oven Found")
                    return
                end
                task.wait(toggle_delay)
            until not auto_cook
        end
    end
})

auto_settings_group:AddSlider('toggle_delay', {
    Text = 'Toggle Repeat Delay',
    Default = toggle_delay,
    Min = 0,
    Max = 5,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        toggle_delay = Value
        if Value == 0 then
            library:Notify("0 Is Not Recommended As It May Cause Lag")
        end
    end
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
    auto_give_food = false
    auto_do_order = false
    auto_order = false
    auto_bill = false
    auto_cook = false
    auto_seat = false
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
