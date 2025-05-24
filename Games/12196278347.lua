--// Made by @kylosilly on discord ;-b last updated version: Beta v.13
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
    farm = window:AddTab("Farm"),
    item = window:AddTab("Item"),
    ["ui settings"] = window:AddTab("UI Settings")
}

local player_group = tabs.main:AddLeftGroupbox("Player Settings")
local grab_group = tabs.main:AddRightGroupbox("Grab Settings")
local anti_staff_group = tabs.main:AddRightGroupbox("Anti Staff Settings")
local farm_group = tabs.farm:AddLeftGroupbox("Farm Settings")
local fishing_group = tabs.farm:AddRightGroupbox("Fishing Settings")
local legit_group = tabs.farm:AddRightGroupbox("Legit Settings")
local sell_item_teleport_group = tabs.item:AddLeftGroupbox("Sell Item Teleport Settings")
local misc_item_teleport_group = tabs.item:AddRightGroupbox("Misc Item Teleport Settings")
local item_teleport_settings_group = tabs.item:AddRightGroupbox("Item Teleport Settings")
local menu_group = tabs["ui settings"]:AddLeftGroupbox("Menu")

get_service = setmetatable({}, {
    __index = function(self, index)
        return cloneref(game.GetService(game, index))
    end
})

local marketplace_service = get_service.MarketplaceService
local replicated_storage = get_service.ReplicatedStorage
local user_input_service = get_service.UserInputService
local tween_service = get_service.TweenService
local virtual_user = get_service.VirtualUser
local run_service = get_service.RunService
local workspace = get_service.Workspace
local players = get_service.Players
local stats = get_service.Stats

local info = marketplace_service:GetProductInfo(game.PlaceId)
local get_gc = getconnections or get_signal_cons
local local_player = players.LocalPlayer
local camera = workspace.CurrentCamera

local fish_sell_zone = workspace.Map.Structures.Nautic_Sellary.SellZone:GetPivot().Position
local ore_sell_zone = workspace.Map.Structures.Nova_Sellary.SellZone.Area:GetPivot().Position

local plot = nil

for _, v in next, workspace:FindFirstChild("Plots"):GetChildren() do
    if v:IsA("Model") and v:GetAttribute("Owner") and v:GetAttribute("Owner") == local_player.Name then
        plot = v
        break
    end
end

if plot == nil then
    local_player:Kick("player plot not found!")
end

local grab_module = require(local_player:FindFirstChild("PlayerGui"):FindFirstChild("Grab"):FindFirstChild("Config"))

if not grab_module then
    local_player:Kick("no grab found!")
end

local ore_models = replicated_storage:FindFirstChild("Content"):FindFirstChild("Ores")

if not ore_models then
    local_player:Kick("ores not found!")
end

local tree_models = replicated_storage:FindFirstChild("Content"):FindFirstChild("Trees")

if not tree_models then
    local_player:Kick("trees not found!")
end

-- idk what to name them :sob:
local tree_spawns = workspace:FindFirstChild("WorldSpawn"):FindFirstChild("Trees")
local ore_spawns = workspace:FindFirstChild("WorldSpawn"):FindFirstChild("Ores")
local npc_models = workspace:FindFirstChild("Npcs")

if not (tree_spawns or ore_spawns or npc_models) then
    local_player:Kick("???")
end

local range_modifier = false
local modify_charge = false
local staff_check = false
local anti_chest = false
local auto_mine = false
local auto_fish = false
local anti_rare = false
local no_damage = false
local anti_key = false
local inf_jump = false
local tp_walk = false

local ore_selector_teleport = ""
local selected_mine_method = ""
local auto_hit_method = "Legit"
local selected_mine_tree = ""
local selected_mine_ore = ""
local selected_tp_tree = ""
local selected_tp_ore = ""
local selected_npc = ""

local max_grab_distance = 12
local auto_hit_precent = 100
local auto_mine_chance = 100
local fishing_precent = 100
local tp_walk_speed = 5

local trees = {}
local ores = {}
local npcs = {}

local old; old = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if not (auto_mine or auto_fish ) and modify_charge and auto_hit_method == "Hook" and method == "FireServer" and self.Name == "Attack" and not checkcaller() then
        args[1]["Alpha"] = auto_hit_precent
        return old(self, unpack(args))
    end

    if no_damage and method == "FireServer" and self.Name == "DamageMe" and not checkcaller() then
        args[1] = 0
        return old(self, unpack(args))
    end

    return old(self, ...)
end)

user_input_service.JumpRequest:Connect(function()
    if inf_jump and not jumped then
        jumped = true
        local_player.Character.Humanoid:ChangeState("Jumping")
        wait()
        jumped = false
    end
end)

local speed_connection = run_service.Heartbeat:Connect(function()
    if tp_walk and local_player.Character and local_player.Character:FindFirstChild("Humanoid") then
         if local_player.Character.Humanoid.MoveDirection.Magnitude > 0 then
            local_player.Character:TranslateBy(local_player.Character.Humanoid.MoveDirection * tp_walk_speed / 10)
        end
    end
end)

players.PlayerAdded:Connect(function(v)
    if staff_check and v ~= local_player and v:GetRankInGroup(9486589) > 1 then
        local_player:Kick("Staff detected! Username: "..v.DisplayName)
    end
end)

function closest_mineral()
    local mineral = nil
    local distance = math.huge

    if selected_mine_method == "Tree" then
        if local_player.Character and local_player.Character:FindFirstChildOfClass("Tool") and local_player.Character:FindFirstChildOfClass("Tool").Name:find("Axe") then
            for _, v in next, tree_spawns:GetChildren() do
                if v:IsA("Model") and v.Name == selected_mine_tree and v:FindFirstChild("Hittable") and v.Hittable:FindFirstChildOfClass("Part") then
                    local dist = (v:GetPivot().Position - local_player.Character:GetPivot().Position).Magnitude
                    if dist < distance then
                        distance = dist
                        mineral = v.Hittable:FindFirstChildOfClass("Part")
                    end
                end
            end
        end
    elseif selected_mine_method == "Ore" then
        if local_player.Character and local_player.Character:FindFirstChildOfClass("Tool") and local_player.Character:FindFirstChildOfClass("Tool").Name:find("Pickaxe") then
            for _, v in next, ore_spawns:GetChildren() do
                if v:IsA("Model") and v.Name == selected_mine_ore and v:FindFirstChild("Hittable") and v.Hittable:FindFirstChildOfClass("Part") then
                    local dist = (v:GetPivot().Position - local_player.Character:GetPivot().Position).Magnitude
                    if dist < distance then
                        distance = dist
                        mineral = v.Hittable:FindFirstChildOfClass("Part")
                    end
                end
            end
        end
    end

    return mineral
end

for _, v in next, npc_models:GetChildren() do
    table.insert(npcs, v.Name)
end

for _, v in next, tree_models:GetChildren() do
    table.insert(trees, v.Name)
end

for _, v in next, ore_models:GetChildren() do
    table.insert(ores, v.Name)
end

player_group:AddDivider()

--[[
player_group:AddLabel("Run this before teleporting/using speed related features!", true)

player_group:AddLabel("Note: This breaks mining, fishing, and chopping. To revent just reset your character.", true)

player_group:AddButton({
    Text = 'Bypass Anti Teleport',
    Func = function()
        if local_player.Character and local_player.Character:FindFirstChild("Humanoid") and local_player.Character.Humanoid.SeatPart ~= nil then
            local old = local_player.Character:GetPivot().Position
            local_player.Character:MoveTo(workspace.Npcs._ExampleNPC:GetPivot().Position)
            local_player.Character:MoveTo(old)
            library:Notify("Bypassed Anti Cheat. If youre still being teleported back, try again or report it to @kylosilly on Discord!")
        else
            library:Notify("You are not in a vehicle!")
        end
    end,
    DoubleClick = false,
    Tooltip = 'Bypassses teleport related Anti Cheat.'
})
]]

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

player_group:AddButton({
    Text = 'Insta Reset',
    Func = function()
        if local_player.Character and local_player.Character:FindFirstChild("Humanoid") and local_player.Character.Humanoid.Health > 0 then
            replicated_storage:WaitForChild("Events"):WaitForChild("DamageMe"):FireServer(9999)
            library:Notify("Ded X-x")
        else
            library:Notify("Cant run this while dead")
        end
    end,
    DoubleClick = false,
    Tooltip = 'Kills you'
})

player_group:AddButton({
    Text = 'Join Discord',
    Func = function()
        setclipboard('discord.gg/SUTpER4dNc')
        library:Notify("Copied to clipboard!")
    end,
    DoubleClick = false,
    Tooltip = 'This is the main button'
})

player_group:AddToggle('no_damage', {
    Text = 'Anti DamageMe',
    Default = no_damage,
    Tooltip = 'Wont damage you when drowining etc.',

    Callback = function(Value)
        no_damage = Value
    end
})

player_group:AddToggle('free_clock', {
    Text = 'Free Clock',
    Default = false,
    Tooltip = 'Shows time for free',

    Callback = function(Value)
        if Value then
            local_player:WaitForChild("Values"):WaitForChild("_ClockPass").Value = true
        else
            local_player:WaitForChild("Values"):WaitForChild("_ClockPass").Value = false
        end
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

player_group:AddToggle('tp_walk', {
    Text = 'Tp Walk',
    Default = tp_walk,
    Tooltip = 'Goes fast voraworawrawra',

    Callback = function(Value)
        tp_walk = Value
    end
})

player_group:AddSlider('tp_walk_speed', {
    Text = 'Tp Walk Speed:',
    Default = tp_walk_speed,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        tp_walk_speed = Value
    end
})

grab_group:AddDivider()

grab_group:AddToggle('range_modifier', {
    Text = 'Modify Grab Distance',
    Default = range_modifier,
    Tooltip = 'Modifies max grab distance',

    Callback = function(Value)
        range_modifier = Value
        if Value then
            sigma = rawget(grab_module, "MaxGrabDistance")
            rawset(grab_module, "MaxGrabDistance", max_grab_distance)
        else
            rawset(grab_module, "MaxGrabDistance", sigma)
        end
    end
})

grab_group:AddSlider('max_grab_distance', {
    Text = 'Max Grab Distance:',
    Default = max_grab_distance,
    Min = 1,
    Max = 1000,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        max_grab_distance = Value
        if range_modifier then
            rawset(grab_module, "MaxGrabDistance", Value)
        end
    end
})

anti_staff_group:AddDivider()

anti_staff_group:AddToggle('anti_staff', {
    Text = 'Staff Check',
    Default = staff_check,
    Tooltip = 'Kicks you when staff joins',

    Callback = function(Value)
        staff_check = Value
        if Value then
            for _, v in next, players:GetPlayers() do
                if v ~= local_player then
                    local rank = v:GetRankInGroup(9486589)
                    if rank > 1 then
                        local_player:Kick("Staff detected! Username: "..v.DisplayName)
                    end
                end
            end
        end
    end
})

farm_group:AddDivider()

farm_group:AddToggle('auto_mine', {
    Text = 'Auto Mine',
    Default = auto_mine,
    Tooltip = 'Auto mines selected ore/tree',

    Callback = function(Value)
        auto_mine = Value
        if Value then
            if selected_mine_method == "" then
                library:Notify("You need to select what to mine first!")
                auto_mine = false
                return
            end

            repeat
                local mineral = closest_mineral()
                if mineral then
                    replicated_storage:WaitForChild("Events"):WaitForChild("Tools"):WaitForChild("Charge"):FireServer({ Target = mineral, HitPosition = local_player.Character:GetPivot().Position })
                    replicated_storage:WaitForChild("Events"):WaitForChild("Tools"):WaitForChild("Attack"):FireServer({ Alpha = auto_mine_chance, ResponseTime = 0 })
                end
                task.wait(local_player.Character:FindFirstChildOfClass("Tool") and local_player.Character:FindFirstChildOfClass("Tool"):FindFirstChild("Configuration"):FindFirstChild("Cooldown").Value / 3 or 0)
            until not auto_mine
        end
    end
})

farm_group:AddSlider('MySlider', {
    Text = 'Hit Chance Auto Mine:',
    Default = auto_mine_chance,
    Min = 1,
    Max = 100,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        auto_mine_chance = Value / 100
    end
})

farm_group:AddDropdown('auto_mine_method', {
    Values = { 'Tree', 'Ore'},
    Default = selected_mine_method,
    Multi = false,

    Text = 'Select What To Mine:',
    Tooltip = 'This is a tooltip',

    Callback = function(Value)
        selected_mine_method = Value
    end
})

local auto_mine_ore_dropdown = farm_group:AddDependencyBox()
local auto_mine_tree_dropdown = farm_group:AddDependencyBox()

auto_mine_ore_dropdown:AddDivider()

auto_mine_ore_dropdown:AddDropdown('auto_mine_ore_selector', {
    Values = ores,
    Default = selected_mine_ore,
    Multi = false,

    Text = 'Select An Ore To Mine:',
    Tooltip = 'Mines selected ore',

    Callback = function(Value)
        selected_mine_ore = Value
    end
})

auto_mine_ore_dropdown:SetupDependencies({
    { Options.auto_mine_method, "Ore" },
})

auto_mine_tree_dropdown:AddDivider()

auto_mine_tree_dropdown:AddDropdown('auto_mine_tree_selector', {
    Values = trees,
    Default = selected_mine_tree,
    Multi = false,

    Text = 'Select A Tree To Mine:',
    Tooltip = 'Mines selected tree',

    Callback = function(Value)
        selected_mine_tree = Value
    end
})

auto_mine_tree_dropdown:SetupDependencies({
    { Options.auto_mine_method, "Tree" },
})

legit_group:AddDivider()

legit_group:AddToggle('modify_charge', {
    Text = 'Auto Charge Hit',
    Default = modify_charge,
    Tooltip = 'This is a tooltip',

    Callback = function(Value)
        modify_charge = Value
        if Value then
            repeat
                if not (auto_mine or auto_fish) and auto_hit_method == "Instant" and local_player.PlayerGui:FindFirstChild("InterfaceGui") and local_player.PlayerGui.InterfaceGui:FindFirstChild("PowerBar") and local_player.PlayerGui.InterfaceGui.PowerBar:FindFirstChild("CurrentAlpha") and local_player.PlayerGui.InterfaceGui.PowerBar.Visible then
                    replicated_storage:WaitForChild("Events"):WaitForChild("Tools"):WaitForChild("Attack"):FireServer({ Alpha = auto_hit_precent, ResponseTime = local_player.PlayerGui.InterfaceGui.PowerBar.CurrentAlpha.Value })
                elseif not (auto_mine or auto_fish) and auto_hit_method == "Legit" and local_player.PlayerGui:FindFirstChild("InterfaceGui") and local_player.PlayerGui.InterfaceGui:FindFirstChild("PowerBar") and local_player.PlayerGui.InterfaceGui.PowerBar and local_player.PlayerGui.InterfaceGui.PowerBar:FindFirstChild("CurrentAlpha") and local_player.PlayerGui.InterfaceGui.PowerBar.Visible and local_player.PlayerGui.InterfaceGui.PowerBar.CurrentAlpha.Value >= auto_hit_precent then
                    replicated_storage:WaitForChild("Events"):WaitForChild("Tools"):WaitForChild("Attack"):FireServer({ Alpha = auto_hit_precent, ResponseTime = local_player.PlayerGui.InterfaceGui.PowerBar.CurrentAlpha.Value })
                end
                task.wait()
            until not modify_charge
        end
    end
})

legit_group:AddDropdown('auto_hit_method', {
    Values = { 'Instant', 'Hook', 'Legit' },
    Default = auto_hit_method,
    Multi = false,

    Text = 'Select Auto Charge Hit Method:',
    Tooltip = 'Uses selected method to auto charge hit',

    Callback = function(Value)
        auto_hit_method = Value
    end
})

legit_group:AddSlider('hit_precent', {
    Text = 'Selected Charge Hit %',
    Default = auto_hit_precent,
    Min = 1,
    Max = 100,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        auto_hit_precent = Value / 100
    end
})

fishing_group:AddDivider()

fishing_group:AddToggle('auto_fish', {
    Text = 'Auto Fish',
    Default = auto_fish,
    Tooltip = 'Fishes for you',

    Callback = function(Value)
        auto_fish = Value
        if Value then
            repeat
                local tool = local_player.Character and local_player.Character:FindFirstChildOfClass("Tool")
                local fish = local_player.PlayerGui:FindFirstChild("UserGui"):FindFirstChild("CatchFrame"):FindFirstChild("Fish")

                if tool and tool.Name:find("Rod") and not tool:FindFirstChild("_Bobber") then
                    replicated_storage.Events.Tools.Charge:FireServer({ HitPosition = local_player.Character:GetPivot().Position })
                    replicated_storage.Events.Tools.Attack:FireServer({ Alpha = fishing_precent, ResponseTime = 0 })
                    task.wait(.25)
                end

                if fish.Parent.Visible then
                    if fish.Rotation == 180 then
                        replicated_storage.Events.Tools.ChangeFishPull:FireServer({ Side = "Right" })
                    elseif fish.Rotation == 0 then
                        replicated_storage.Events.Tools.ChangeFishPull:FireServer({ Side = "Left" })
                    elseif fish.Rotation == 90 then
                        replicated_storage.Events.Tools.ChangeFishPull:FireServer({ Side = "Top" })
                    elseif fish.Rotation == -90 then
                        replicated_storage.Events.Tools.ChangeFishPull:FireServer({ Side = "Bottom" })
                    end
                end
                task.wait()
            until not auto_fish
        end
    end
})

fishing_group:AddSlider('fishing_precent', {
    Text = 'Selected Fishing %',
    Default = fishing_precent,
    Min = 1,
    Max = 100,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        fishing_precent = Value / 100
    end
})

sell_item_teleport_group:AddDivider()

sell_item_teleport_group:AddButton({
    Text = 'Bring Ocean Item To Sell Zone',
    Func = function()
        for _, v in next, workspace.Grab:GetChildren() do
            if v:IsA("Model") and v:GetAttribute("SellCategory") == "Nautic" and v:FindFirstChild("Owner") and v.Owner.Value == local_player and local_player.Character and local_player.Character:FindFirstChild("HumanoidRootPart") and (not anti_key or not v.Name:find("Key")) and (not anti_chest or not v.Name:find("Chest")) and (not anti_rare or v:GetAttribute("IsRare")) then
                local velocity_connection = run_service.Heartbeat:Connect(function()
                    local_player.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                    local_player.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                end)
                local to = tween_service:Create(local_player.Character.HumanoidRootPart, TweenInfo.new((v:GetPivot().Position - local_player.Character:GetPivot().Position).magnitude / 100, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = CFrame.new(v:GetPivot().Position) + Vector3.new(0, 5, 0)})
                to:Play()
                to.Completed:Wait()
                if velocity_connection then
                    velocity_connection:Disconnect()
                end
                task.wait(.25)
                replicated_storage:WaitForChild("Events"):WaitForChild("GrabHandler"):InvokeServer(v.PrimaryPart, "Grab", v:GetPivot().Position)
                if v:GetAttribute("_Network") == local_player.Name then
                    v:MoveTo(fish_sell_zone)
                end
            end
        end
        library:Notify("Done")
    end,
    DoubleClick = false,
    Tooltip = 'Brings fishes, etc. to sell zone'
})

sell_item_teleport_group:AddButton({
    Text = 'Bring Logs/Ores To Sell Zone',
    Func = function()
        for _, v in next, workspace.Grab:GetChildren() do
            if v:IsA("Model") and v.Name == "MaterialPart" and v:FindFirstChild("Owner") and v.Owner.Value == local_player and local_player.Character and local_player.Character:FindFirstChild("HumanoidRootPart") and (not anti_rare or v:GetAttribute("IsRare")) then
                local velocity_connection = run_service.Heartbeat:Connect(function()
                    local_player.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                    local_player.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                end)
                local to = tween_service:Create(local_player.Character.HumanoidRootPart, TweenInfo.new((v:GetPivot().Position - local_player.Character:GetPivot().Position).magnitude / 100, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = CFrame.new(v:GetPivot().Position) + Vector3.new(0, 5, 0)})
                to:Play()
                to.Completed:Wait()
                if velocity_connection then
                    velocity_connection:Disconnect()
                end
                task.wait(.25)
                replicated_storage:WaitForChild("Events"):WaitForChild("GrabHandler"):InvokeServer(v.PrimaryPart, "Grab", v:GetPivot().Position)
                if v:GetAttribute("_Network") == local_player.Name then
                    v:MoveTo(ore_sell_zone)
                end
            end
        end
        library:Notify("Done")
    end,
    DoubleClick = false,
    Tooltip = 'Brings oaks, ores, etc. to sell zone'
})

misc_item_teleport_group:AddDivider()

misc_item_teleport_group:AddButton({
    Text = 'Bring Keys To Plot',
    Func = function()
        for _, v in next, workspace.Grab:GetChildren() do
            if v:IsA("Model") and v.Name:find("Key") and v:FindFirstChild("Owner") and v.Owner.Value == local_player and local_player.Character and local_player.Character:FindFirstChild("HumanoidRootPart") then
                local velocity_connection = run_service.Heartbeat:Connect(function()
                    local_player.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                    local_player.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                end)
                local to = tween_service:Create(local_player.Character.HumanoidRootPart, TweenInfo.new((v:GetPivot().Position - local_player.Character:GetPivot().Position).magnitude / 100, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = CFrame.new(v:GetPivot().Position) + Vector3.new(0, 5, 0)})
                to:Play()
                to.Completed:Wait()
                if velocity_connection then
                    velocity_connection:Disconnect()
                end
                task.wait(.25)
                replicated_storage:WaitForChild("Events"):WaitForChild("GrabHandler"):InvokeServer(v.PrimaryPart, "Grab", v:GetPivot().Position)
                if v:GetAttribute("_Network") == local_player.Name then
                    v:MoveTo(plot:GetPivot().Position)
                end
            end
        end
        library:Notify("Done")
    end,
    DoubleClick = false,
    Tooltip = 'Brings keys to plot'
})

misc_item_teleport_group:AddButton({
    Text = 'Bring Chest To Plot',
    Func = function()
        for _, v in next, workspace.Grab:GetChildren() do
            if v:IsA("Model") and v.Name:find("Chest") and v:FindFirstChild("Owner") and v.Owner.Value == local_player and local_player.Character and local_player.Character:FindFirstChild("HumanoidRootPart") then
                local velocity_connection = run_service.Heartbeat:Connect(function()
                    local_player.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                    local_player.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                end)
                local to = tween_service:Create(local_player.Character.HumanoidRootPart, TweenInfo.new((v:GetPivot().Position - local_player.Character:GetPivot().Position).magnitude / 100, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = CFrame.new(v:GetPivot().Position) + Vector3.new(0, 5, 0)})
                to:Play()
                to.Completed:Wait()
                if velocity_connection then
                    velocity_connection:Disconnect()
                end
                task.wait(.25)
                replicated_storage:WaitForChild("Events"):WaitForChild("GrabHandler"):InvokeServer(v.PrimaryPart, "Grab", v:GetPivot().Position)
                if v:GetAttribute("_Network") == local_player.Name then
                    v:MoveTo(plot:GetPivot().Position)
                end
            end
        end
        library:Notify("Done")
    end,
    DoubleClick = false,
    Tooltip = 'Brings chest to plot'
})

misc_item_teleport_group:AddButton({
    Text = 'Bring Rare Items To Plot',
    Func = function()
        for _, v in next, workspace.Grab:GetChildren() do
            if v:IsA("Model") and v:GetAttribute("IsRare") and v:FindFirstChild("Owner") and v.Owner.Value == local_player and local_player.Character and local_player.Character:FindFirstChild("HumanoidRootPart") then
                local velocity_connection = run_service.Heartbeat:Connect(function()
                    local_player.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                    local_player.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                end)
                local to = tween_service:Create(local_player.Character.HumanoidRootPart, TweenInfo.new((v:GetPivot().Position - local_player.Character:GetPivot().Position).magnitude / 100, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = CFrame.new(v:GetPivot().Position) + Vector3.new(0, 5, 0)})
                to:Play()
                to.Completed:Wait()
                if velocity_connection then
                    velocity_connection:Disconnect()
                end
                task.wait(.25)
                replicated_storage:WaitForChild("Events"):WaitForChild("GrabHandler"):InvokeServer(v.PrimaryPart, "Grab", v:GetPivot().Position)
                if v:GetAttribute("_Network") == local_player.Name then
                    v:MoveTo(plot:GetPivot().Position)
                end
            end
        end
        library:Notify("Done")
    end,
    DoubleClick = false,
    Tooltip = 'Brings keys to plot'
})

item_teleport_settings_group:AddDivider()

item_teleport_settings_group:AddToggle('anti_key ', {
    Text = 'Ignore Keys',
    Default = anti_key,
    Tooltip = 'Dosent teleport keys to sell zone',

    Callback = function(Value)
        anti_key = Value
    end
})

item_teleport_settings_group:AddToggle('anti_rare', {
    Text = 'Ignore Rares',
    Default = anti_rare,
    Tooltip = 'Dosent teleport rares to sell zone',

    Callback = function(Value)
        anti_rare = Value
    end
})

item_teleport_settings_group:AddToggle('anti_chest', {
    Text = 'Ignore Chest',
    Default = anti_chest,
    Tooltip = 'Dosent teleport chests to sell zone',

    Callback = function(Value)
        anti_chest = Value
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

    library:SetWatermark(('Astolfo Ware | %s fps | %s ms | game: ' .. info.Name .. ''):format(
        math.floor(fps),
        math.floor(stats.Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);

menu_group:AddButton('Unload', function()
    modify_charge = false
    staff_check = false
    auto_mine = false
    auto_fish = false
    no_damage = false
    inf_jump = false
    tp_walk = false
    rawset(grab_module, "MaxGrabDistance", 12)
    local_player:WaitForChild("Values"):WaitForChild("_ClockPass").Value = false
    watermark_connection:Disconnect()
    speed_connection:Disconnect()
    library:Unload()
end)

menu_group:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
library.ToggleKeybind = Options.MenuKeybind
theme_manager:SetLibrary(library)
save_manager:SetLibrary(library)
save_manager:IgnoreThemeSettings()
save_manager:SetIgnoreIndexes({ 'MenuKeybind' })
theme_manager:SetFolder('Astolfo Ware')
save_manager:SetFolder('Astolfo Ware/Refinery Caves 2')
save_manager:BuildConfigSection(tabs['ui settings'])
theme_manager:ApplyToTab(tabs['ui settings'])
save_manager:LoadAutoloadConfig()
