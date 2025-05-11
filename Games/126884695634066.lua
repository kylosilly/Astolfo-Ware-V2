if not game:IsLoaded() then
    print("Waiting for game to load...")
    game.Loaded:Wait()
    print("Loaded Game")
end

if getthreadcontext() > 7 then
    print("Executor Supported")
else
    print("Since Many Were Confused, Executor Isnt Thread 7 Which Is Required For This Script To Work Use Swift Or Volcano!")
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
    inventory = window:AddTab('Inventory'),
    shop = window:AddTab('Shop'),
    misc = window:AddTab('Misc'),
    event = window:AddTab('Event'),
    ['ui settings'] = window:AddTab('UI Settings')
}

local plant_group = tabs.main:AddLeftGroupbox('Plant Settings')
local egg_group = tabs.main:AddRightGroupbox('Egg Settings')
local favorite_group = tabs.inventory:AddLeftGroupbox('Favorite Settings')
local seed_shop_group = tabs.shop:AddLeftGroupbox('Seed Shop Settings')
local gear_shop_group = tabs.shop:AddRightGroupbox('Gear Shop Settings')
local egg_shop_group = tabs.shop:AddLeftGroupbox('Egg Shop Settings')
local sell_settings = tabs.shop:AddRightGroupbox('Sell Settings')
local player_group = tabs.misc:AddLeftGroupbox('Player Settings')
local event_group = tabs.event:AddLeftGroupbox('Event Settings')
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

--// Fix Shitsploit
if identifyexecutor() == "Swift" then
    print("Fixed Require")
    setthreadidentity(8)
end

local egg_shop = require(replicated_storage.Data.PetEggData)
local seed_shop = require(replicated_storage.Data.SeedData)
local gear_shop = require(replicated_storage.Data.GearData)

local selected_mutations = {}
local selected_seeds = {}
local selected_gears = {}
local selected_eggs = {}
local mutations = {}
local seeds = {}
local gears = {}
local eggs = {}

local egg_location = workspace:FindFirstChild("NPCS"):FindFirstChild("Pet Stand"):FindFirstChild("EggLocations")
local seed_models = replicated_storage:FindFirstChild("Seed_Models")
local pets = workspace:FindFirstChild("PetsPhysical")
local farm = nil

for _, v in next, workspace:FindFirstChild("Farm"):GetDescendants() do
    if v.Name == "Owner" and v.Value == local_player.Name then
        farm = v.Parent.Parent
    end
end

for i, v in next, seed_shop do
    if v.StockChance > 0 then -- Can also use: if v.DisplayInShop then
        table.insert(seeds, i)
    end
end

for _, v in next, egg_shop do
    if v.StockChance > 0 then
        table.insert(eggs, v.EggName)
    end
end

for _, v in next, gear_shop do
    if v.StockChance > 0 then
        table.insert(gears, v.GearName)
    end
end

for _, v in next, replicated_storage.Mutation_FX:GetChildren() do
    table.insert(mutations, v.Name)
end
table.insert(mutations, "Gold")
table.insert(mutations, "Rainbow")

local auto_give_moonlits = false
local auto_buy_seeds = false
local auto_buy_gears = false
local auto_buy_eggs = false
local auto_favorite = false
local pickup_aura = false
local auto_plant = false
local hatch_aura = false
local auto_sell = false

local pickup_aura_range = 20
local pickup_aura_delay = 0.1
local hatch_aura_delay = 0.1
local min_pickup_aura = 0.01
local favorite_delay = 0.1
local gear_buy_delay = 1
local seed_buy_delay = 1
local egg_buy_delay = 1
local dupe_amount = 1
local plant_delay = 0.1
local sell_delay = 10
local min_weight = 0.01

local plant_position = nil

local auto_plant_method = "Player Position"
local dupe_method = "Closest"

function closest_pet()
    local pet = nil
    local distance = math.huge

    for _, v in next, pets:GetChildren() do
        if v:IsA("Part") and v:GetAttribute("OWNER") == local_player.Name and v:GetAttribute("UUID") then
            local dist = (v:GetPivot().Position - local_player.Character:GetPivot().Position).Magnitude
            if dist < distance then
                distance = dist
                pet = v
            end
        end
    end

    return pet
end

plant_group:AddDivider()

plant_group:AddLabel("If Pickup Aura Delay Is Low Theres A Chance To Insta Collect Before Planted", true)

plant_group:AddDivider()

plant_group:AddToggle('pickup_aura', {
    Text = 'Pickup Aura',
    Default = pickup_aura,
    Tooltip = 'Collects avaible plants',

    Callback = function(Value)
        pickup_aura = Value
        if Value then
            if not min_pickup_aura or tonumber(min_pickup_aura) < 0.01 then
                library:Notify("Min Weight Must Be Above 0.01")
                return
            end

            repeat
                for _, v in next, farm:FindFirstChild("Plants_Physical"):GetChildren() do
                    if v:IsA("Model") and local_player.Character:FindFirstChild("HumanoidRootPart") then
                        for _, v2 in next, v:GetDescendants() do
                            if v2:IsA("ProximityPrompt") and v2.Parent.Parent:FindFirstChild("Weight") and v2.Parent.Parent.Weight.Value > tonumber(min_pickup_aura) and (v:GetPivot().Position - local_player.Character:GetPivot().Position).Magnitude < pickup_aura_range then
                                fireproximityprompt(v2)
                                task.wait(pickup_aura_delay)
                            end
                        end
                    end
                end
                task.wait()
            until not pickup_aura
        end
    end
})

plant_group:AddSlider('pickup_aura_delay', {
    Text = 'Pickup Aura Delay:',
    Default = pickup_aura_delay,
    Min = 0.1,
    Max = 60,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        pickup_aura_delay = Value
    end
})

plant_group:AddSlider('pickup_aura_range', {
    Text = 'Pickup Aura Range:',
    Default = pickup_aura_range,
    Min = 5,
    Max = 20,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        pickup_aura_range = Value
    end
})

plant_group:AddInput('pickup_min_weight', {
    Default = min_pickup_aura,
    Numeric = true,
    Finished = true,

    Text = 'Pickup At Min Weight:',
    Tooltip = 'Will pick up above the weight',

    Placeholder = '',

    Callback = function(Value)
        min_pickup_aura = Value
    end
})

plant_group:AddDivider()

plant_group:AddToggle('auto_plant', {
    Text = 'Auto Plant',
    Default = auto_plant,
    Tooltip = 'Auto plants held seed',

    Callback = function(Value)
        auto_plant = Value
        if Value then
            if auto_plant_method == "Choosen Position" and not plant_position then
                library:Notify("No Position Found To Plant")
                return
            end

            repeat
                if local_player.Character and local_player.Character:FindFirstChildOfClass("Tool") and local_player.Character:FindFirstChildOfClass("Tool"):GetAttribute("ItemType") == "Seed" then

                    if auto_plant_method == "Choosen Position" then
                        replicated_storage:WaitForChild("GameEvents"):WaitForChild("Plant_RE"):FireServer(plant_position, local_player.Character:FindFirstChildOfClass("Tool"):GetAttribute("ItemName"))
                    elseif auto_plant_method == "Player Position" then
                        replicated_storage:WaitForChild("GameEvents"):WaitForChild("Plant_RE"):FireServer(local_player.Character:GetPivot().Position, local_player.Character:FindFirstChildOfClass("Tool"):GetAttribute("ItemName"))
                    end

                    task.wait(plant_delay)
                end
                task.wait()
            until not auto_plant
        end
    end
})

plant_group:AddDropdown('auto_plant_method', {
    Values = { 'Choosen Position', 'Player Position' },
    Default = auto_plant_method,
    Multi = false,

    Text = 'Select Auto Plant Method:',
    Tooltip = 'Auto plants with selected method',

    Callback = function(Value)
        auto_plant_method = Value
    end
})

plant_group:AddSlider('plant_delay', {
    Text = 'Auto Plant Delay:',
    Default = plant_delay,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        plant_delay = Value
    end
})

plant_group:AddDivider()

plant_group:AddButton({
    Text = 'Get Choosen Position',
    Func = function()
        if local_player.Character then
            plant_position = local_player.Character:GetPivot().Position
        end
    end,
    DoubleClick = false,
    Tooltip = 'Get Position For Choosen Position',
})

egg_group:AddDivider()

egg_group:AddToggle('hatch_aura', {
    Text = 'Hatch Aura',
    Default = hatch_aura,
    Tooltip = 'Hatches avaible eggs',

    Callback = function(Value)
        hatch_aura = Value
        if Value then
            repeat
                for _, v in next, farm:FindFirstChild("Objects_Physical"):GetChildren() do
                    if v:IsA("Model") and v:GetAttribute("TimeToHatch") == 0 and local_player.Character and (v:GetPivot().Position - local_player.Character:GetPivot().Position).Magnitude < 20 then
                        for _, v2 in next, v:FindFirstChildOfClass("Model"):GetChildren() do
                            if v2:IsA("ProximityPrompt") and v2.Name == "ProximityPrompt" then
                                fireproximityprompt(v2)
                                task.wait(hatch_aura_delay)
                            end
                        end
                    end
                end
            task.wait()
            until not hatch_aura
        end
    end
})

egg_group:AddSlider('hatch_aura_delay', {
    Text = 'Hatch Aura Delay:',
    Default = hatch_aura_delay,
    Min = 0.1,
    Max = 60,
    Rounding = 2,
    Compact = false,

    Callback = function(Value)
        hatch_aura_delay = Value
    end
})

egg_group:AddDivider()

egg_group:AddButton({
    Text = 'Max Feed Nearest Pet',
    Func = function()
        local tool = local_player.Character:FindFirstChildOfClass("Tool")

        if not tool then
            library:Notify("Not Holding A Tool")
            return
        end

        if tool:GetAttribute("ItemType") and not tool:GetAttribute("ItemType") == "Holdable" then
            library:Notify("Not Holding A Holdable Item")
            return
        end

        if tool:GetAttribute("Favorite") then
            library:Notify("Cannot Feed Favorited Item")
            return
        end

        if dupe_method == "Closest" then
            local pet = closest_pet()

            if not pet then
                library:Notify("No Pets Found")
                return
            end

            for i = 1, dupe_amount do
                replicated_storage:WaitForChild("GameEvents"):WaitForChild("ActivePetService"):FireServer("Feed", pet:GetAttribute("UUID"))
            end
            library:Notify("Done Feeding Pet")
            return
        end

        if dupe_method == "All" then
            for i = 1, dupe_amount do
                for _, v in next, pets:GetChildren() do
                    if v:IsA("Part") and v:GetAttribute("OWNER") == local_player.Name and v:GetAttribute("UUID") then
                        replicated_storage:WaitForChild("GameEvents"):WaitForChild("ActivePetService"):FireServer("Feed", v:GetAttribute("UUID"))
                    end
                end
            end
            library:Notify("Done Feeding Pets")
            return
        end
    end,
    DoubleClick = false,
    Tooltip = 'Feeds pets to max',
})

egg_group:AddDropdown('dupe_method', {
    Values = {'Closest', 'All'},
    Default = dupe_method,
    Multi = false,

    Text = 'Select Max Feed Method:',
    Tooltip = 'Max feeds pets with selected method',

    Callback = function(Value)
        dupe_method = Value
    end
})

egg_group:AddSlider('dupe_amount', {
    Text = 'Dupe Amount:',
    Default = dupe_amount,
    Min = 1,
    Max = 1000,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        dupe_amount = Value
    end
})

favorite_group:AddDivider()

favorite_group:AddToggle('auto_favorite', {
    Text = 'Auto Favorite',
    Default = auto_favorite,
    Tooltip = 'Favorites fruits above choosen weight',

    Callback = function(Value)
        auto_favorite = Value
        if Value then
            if not min_weight or tonumber(min_weight) < 0.01 then
                library:Notify("Min Weight Must Be Above 0.01")
                return
            end

            repeat
                for _, v in next, local_player:FindFirstChild("Backpack"):GetChildren() do
                    for _, v2 in next, seed_models:GetChildren() do
                        if v:IsA("Tool") and not v:GetAttribute("Favorite") and v:GetAttribute("ItemName") == v2.Name and v:FindFirstChild("Weight") and v.Weight.Value > tonumber(min_weight) then
                            replicated_storage:WaitForChild("GameEvents"):WaitForChild("Favorite_Item"):FireServer(v)
                        elseif selected_mutations then
                            for i, _ in next, selected_mutations do
                                if v:IsA("Tool") and not v:GetAttribute("Favorite") and v:GetAttribute("ItemName") == v2.Name and v.Name:find(i) then
                                    replicated_storage:WaitForChild("GameEvents"):WaitForChild("Favorite_Item"):FireServer(v)
                                end
                            end
                        end
                    end
                end
                task.wait(favorite_delay)
            until not auto_favorite
        end
    end
})

favorite_group:AddInput('min_weight', {
    Default = min_weight,
    Numeric = true,
    Finished = true,

    Text = 'Select Min Weight:',
    Tooltip = 'Will favorite above the min weight',

    Placeholder = '',

    Callback = function(Value)
        min_weight = Value
    end
})

favorite_group:AddSlider('favorite_delay', {
    Text = 'Select Favorite Delay:',
    Default = favorite_delay,
    Min = 0,
    Max = 60,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        favorite_delay = Value
    end
})

favorite_group:AddDropdown('mutation_selector', {
    Values = mutations,
    Default = selected_mutations,
    Multi = true,

    Text = 'Select Mutations To Favorite:',
    Tooltip = 'Favorites selected mutations',

    Callback = function(Value)
        selected_mutations = Value
    end
})

favorite_group:AddDivider()

favorite_group:AddButton({
    Text = 'Unfavorite All',
    Func = function()
        for _, v in next, local_player:FindFirstChild("Backpack"):GetChildren() do
            if v:GetAttribute("Favorite") then
                replicated_storage:WaitForChild("GameEvents"):WaitForChild("Favorite_Item"):FireServer(v)
            end
        end
    end,
    DoubleClick = false,
    Tooltip = 'Unfavorites all favorited fruits',
})

seed_shop_group:AddDivider()

seed_shop_group:AddToggle('auto_buy_seeds', {
    Text = 'Auto Buy Seeds',
    Default = auto_buy_seeds,
    Tooltip = 'Buys selected seeds',

    Callback = function(Value)
        auto_buy_seeds = Value
        if Value then
            repeat
                for i, _ in next, selected_seeds do
                    replicated_storage:WaitForChild("GameEvents"):WaitForChild("BuySeedStock"):FireServer(i)
                end
            task.wait(seed_buy_delay)
            until not auto_buy_seeds
        end           
    end
})

seed_shop_group:AddDropdown('seed_selector', {
    Values = seeds,
    Default = selected_seeds,
    Multi = true,

    Text = 'Select Seeds To Auto Buy:',
    Tooltip = 'Buys selected seeds',

    Callback = function(Value)
        selected_seeds = Value
    end
})

seed_shop_group:AddSlider('seed_buy_delay', {
    Text = 'Seed Buy Delay:',
    Default = seed_buy_delay,
    Min = 0,
    Max = 60,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        seed_buy_delay = Value
    end
})

seed_shop_group:AddDivider()

seed_shop_group:AddButton({
    Text = 'Buy Seeds',
    Func = function()
        for i, _ in next, selected_seeds do
            replicated_storage:WaitForChild("GameEvents"):WaitForChild("BuySeedStock"):FireServer(i)
        end
    end,
    DoubleClick = false,
    Tooltip = 'Buys selected seeds'
})

gear_shop_group:AddDivider()

gear_shop_group:AddToggle('auto_buy_gears', {
    Text = 'Auto Buy Gears',
    Default = auto_buy_gears,
    Tooltip = 'Buys selected gears',

    Callback = function(Value)
        auto_buy_gears = Value
        if Value then
            repeat
                for i, _ in next, selected_gears do
                    replicated_storage:WaitForChild("GameEvents"):WaitForChild("BuyGearStock"):FireServer(i)
                end
            task.wait(gear_buy_delay)
            until not auto_buy_gears
        end
    end
})

gear_shop_group:AddDropdown('gear_selector', {
    Values = gears,
    Default = selected_gears,
    Multi = true,

    Text = 'Select Gear To Buy:',
    Tooltip = 'Buys selected gear',

    Callback = function(Value)
        selected_gears = Value
    end
})

gear_shop_group:AddSlider('gear_buy_delay', {
    Text = 'Gear Buy Delay:',
    Default = gear_buy_delay,
    Min = 0,
    Max = 60,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        gear_buy_delay = Value
    end
})

gear_shop_group:AddDivider()

gear_shop_group:AddButton({
    Text = 'Buy Gears',
    Func = function()
        for i, _ in next, selected_gears do
            replicated_storage:WaitForChild("GameEvents"):WaitForChild("BuyGearStock"):FireServer(i)
        end
    end,
    DoubleClick = false,
    Tooltip = 'Buys selected gear'
})

egg_shop_group:AddDivider()

egg_shop_group:AddToggle('auto_buy_eggs', {
    Text = 'Auto Buy Eggs',
    Default = auto_buy_eggs,
    Tooltip = 'Buys selected eggs',

    Callback = function(Value)
        auto_buy_eggs = Value
        if Value then
            repeat
                for i, v in next, egg_location:GetChildren() do
                    for i2, _ in next, selected_eggs do
                        if v.Name == i2 and not v:GetAttribute("RobuxEggOnly") then
                            replicated_storage:WaitForChild("GameEvents"):WaitForChild("BuyPetEgg"):FireServer(i - 3)
                        end
                    end
                end
            task.wait(egg_buy_delay)
            until not auto_buy_eggs
        end
    end
})

egg_shop_group:AddDropdown('egg_selector', {
    Values = eggs,
    Default = selected_eggs,
    Multi = true,

    Text = 'Select Egg To Buy:',
    Tooltip = 'Buys selected egg',

    Callback = function(Value)
        selected_eggs = Value
    end
})

egg_shop_group:AddSlider('egg_buy_delay', {
    Text = 'Egg Buy Delay:',
    Default = egg_buy_delay,
    Min = 0,
    Max = 60,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        egg_buy_delay = Value
    end
})

egg_shop_group:AddDivider()

egg_shop_group:AddButton({
    Text = 'Buy Eggs',
    Func = function()
        for i, v in next, egg_location:GetChildren() do
            for i2, _ in next, selected_eggs do
                if v.Name == i2 and not v:GetAttribute("RobuxEggOnly") then
                    replicated_storage:WaitForChild("GameEvents"):WaitForChild("BuyPetEgg"):FireServer(i - 3)
                end
            end
        end
    end,
    DoubleClick = false,
    Tooltip = 'Buys selected egg'
})

sell_settings:AddDivider()

sell_settings:AddToggle('auto_sell', {
    Text = 'Auto Sell All',
    Default = auto_sell,
    Tooltip = 'Sells all automatically for you',

    Callback = function(Value)
        auto_sell = Value
        if Value then
            repeat
                if local_player.Character and local_player.Character:FindFirstChild("HumanoidRootPart") then
                    local old = local_player.Character:FindFirstChild("HumanoidRootPart").CFrame
                    local_player.Character:FindFirstChild("HumanoidRootPart").CFrame = workspace.Tutorial_Points.Tutorial_Point_2.CFrame
                    task.wait(.2)
                    replicated_storage:WaitForChild("GameEvents"):WaitForChild("Sell_Inventory"):FireServer()
                    task.wait(.2)
                    local_player.Character:FindFirstChild("HumanoidRootPart").CFrame = old
                    task.wait(sell_delay)
                end
            until not auto_sell
        end
    end
})

sell_settings:AddSlider('auto_sell_delay', {
    Text = 'Auto Sell Delay',
    Default = sell_delay,
    Min = 10,
    Max = 600,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        sell_delay = Value
    end
})

sell_settings:AddDivider()

sell_settings:AddButton({
    Text = 'Sell All',
    Func = function()
        local old = local_player.Character:FindFirstChild("HumanoidRootPart").CFrame
        local_player.Character:FindFirstChild("HumanoidRootPart").CFrame = workspace.Tutorial_Points.Tutorial_Point_2.CFrame
        task.wait(.2)
        replicated_storage:WaitForChild("GameEvents"):WaitForChild("Sell_Inventory"):FireServer()
        task.wait(.2)
        local_player.Character:FindFirstChild("HumanoidRootPart").CFrame = old
        library:Notify("Sold All")
    end,
    DoubleClick = false,
    Tooltip = 'Sells Inventory'
})

sell_settings:AddButton({
    Text = 'Sell Held Plant',
    Func = function()
        local tool = local_player.Character:FindFirstChildOfClass("Tool")

        if not tool then
            library:Notify("Not Holding A Tool")
            return
        end

        if tool:GetAttribute("Favorite") then
            library:Notify("Cannot Sell Favorited Item")
            return
        end

        for _, v in next, seeds:GetChildren() do
            if tool:GetAttribute("ItemType") == v.Name and tool:GetAttribute("ItemType") == "Holdable" then
                local old = local_player.Character:FindFirstChild("HumanoidRootPart").CFrame
                local_player.Character:FindFirstChild("HumanoidRootPart").CFrame = workspace.Tutorial_Points.Tutorial_Point_2.CFrame
                task.wait(.2)
                replicated_storage:WaitForChild("GameEvents"):WaitForChild("Sell_Item"):FireServer()
                task.wait(.2)
                local_player.Character:FindFirstChild("HumanoidRootPart").CFrame = old
                library:Notify("Sold Item")
            end
        end
    end,
    DoubleClick = false,
    Tooltip = 'Sells held item'
})

player_group:AddDivider()

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
        queue_on_teleport([[
            loadstring(game:HttpGet("https://raw.githubusercontent.com/kylosilly/astolfoware/refs/heads/main/astolfo%20ware%20loader.lua"))()
        ]])

        teleport_service:TeleportToPlaceInstance(game.PlaceId, game.JobId, local_player)
    end,
    DoubleClick = false,
    Tooltip = 'Rejoins the game'
})

player_group:AddButton({
    Text = 'Join Discord Server',
    Func = function()
        setclipboard('https://discord.gg/SUTpER4dNc')
        library:Notify('Copied discord invite to clipboard')
    end,
    DoubleClick = false,
    Tooltip = 'Copies discord invite to clipboard'
})

event_group:AddDivider()

event_group:AddToggle('auto_give_moonlits', {
    Text = 'Auto Give Moonlit Items',
    Default = auto_give_moonlits,
    Tooltip = 'Automatically gives moonlit items',

    Callback = function(Value)
        auto_give_moonlits = Value
        if Value then
            repeat
                for _, v in next, local_player.Backpack:GetChildren() do
                    if v:IsA("Tool") and v.Name:find("Moonlit") then
                        replicated_storage:WaitForChild("GameEvents"):WaitForChild("NightQuestRemoteEvent"):FireServer("SubmitAllPlants")
                    end
                end
                task.wait(1)
            until not auto_give_moonlits
        end
    end
})

event_group:AddDivider()

event_group:AddButton({
    Text = 'Tp To Event',
    Func = function()
        local_player.Character:FindFirstChild("HumanoidRootPart").CFrame = workspace.NightEvent.OwlNPCTree["26"].Part.CFrame + Vector3.new(0, 5, 0)
    end,
    DoubleClick = false,
    Tooltip = 'Teleports you to the event platform'
})

event_group:AddButton({
    Text = 'Give All Moonlit Items',
    Func = function()
        for _, v in next, local_player.Backpack:GetChildren() do
            if v:IsA("Tool") and v.Name:find("Moonlit") then
                replicated_storage:WaitForChild("GameEvents"):WaitForChild("NightQuestRemoteEvent"):FireServer("SubmitAllPlants")
                return
            end
        end

        library:Notify("No Moonlit Items Found")
    end,
    DoubleClick = false,
    Tooltip = 'Gives all moonlit items'
})

event_group:AddButton({
    Text = 'Give Held Moonlit Item',
    Func = function()
        local tool = local_player.Character:FindFirstChildOfClass("Tool")

        if not tool then
            library:Notify("Not Holding A Tool")
            return
        end

        if not tool.Name:find("Moonlit") then
            library:Notify("Not Holding A Moonlit Item")
            return
        end

        replicated_storage:WaitForChild("GameEvents"):WaitForChild("NightQuestRemoteEvent"):FireServer("SubmitHeldPlant")
    end,
    DoubleClick = false,
    Tooltip = 'Gives held moonlit item'
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
    auto_give_moonlits = false
    auto_buy_seeds = false
    auto_buy_gears = false
    auto_buy_eggs = false
    auto_favorite = false
    pickup_aura = false
    auto_plant = false
    hatch_aura = false
    auto_sell = false
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
