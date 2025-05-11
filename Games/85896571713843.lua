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

if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Intro") then
    library:Notify("Start the game first before using the script!")
    return
end

local window = library:CreateWindow({
    Title = 'Astolfo Ware | Public | Made By @kylosilly',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local tabs = {
    main = window:AddTab('Main'),
    auto = window:AddTab('Auto'),
    webhook = window:AddTab('Webhook'),
    ['ui settings'] = window:AddTab('UI Settings')
}

local farm_group = tabs.main:AddLeftGroupbox('Farm Settings')
local misc_group = tabs.main:AddRightGroupbox('Misc Stuff')
local auto_hatch_group = tabs.main:AddLeftGroupbox('Auto Hatch Settings')
local teleport_group = tabs.main:AddRightGroupbox('Teleport Settings')
--[[
local auto_enchant_group = tabs.main:AddRightGroupbox('Auto Enchant Settings')
]]
local auto_group = tabs.auto:AddLeftGroupbox('Auto Settings')
local auto_use_group = tabs.auto:AddRightGroupbox('Auto Use Settings')
local webhook_group = tabs.webhook:AddLeftGroupbox('Webhook Settings')
local menu_group = tabs['ui settings']:AddLeftGroupbox('Menu')

local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local replicated_storage = game:GetService('ReplicatedStorage')
local tween_service = game:GetService('TweenService')
local market = game:GetService('MarketplaceService')
local http_service = game:GetService('HttpService')
local virtual_user = game:GetService('VirtualUser')
local run_service = game:GetService('RunService')
local info = market:GetProductInfo(game.PlaceId)
local getgc = getconnections or get_signal_cons
local workspace = game:GetService('Workspace')
local players = game:GetService('Players')
local local_player = players.LocalPlayer
local stats = game:GetService('Stats')

local local_data = require(replicated_storage.Client.Framework.Services.LocalData)
local remote = require(replicated_storage.Shared.Framework.Network.Remote)
local shiny_utility = require(replicated_storage.Shared.Utils.ShinyUtil)
local pet_level = require(replicated_storage.Shared.Utils.PetLevelUtil)
local stat = require(replicated_storage.Shared.Utils.Stats.StatsUtil)
local pets = require(replicated_storage.Shared.Utils.Stats.PetUtil)
local codes = require(replicated_storage.Shared.Data.Codes)

local minigame_paradise_islands = workspace.Worlds["Minigame Paradise"].Islands
local overworld_islands = workspace.Worlds["The Overworld"].Islands
local dices = replicated_storage.Assets.Minigames.Dice
local eggs = replicated_storage.Assets.Eggs
local chest = workspace.Rendered.Chests
local gifts = workspace.Rendered.Gifts
local rifts = workspace.Rendered.Rifts
local pickables = nil
local game_eggs = nil

--// This prob so ass idk

for _, v in next, workspace.Rendered:GetChildren() do
    if v:IsA("Folder") then
        local model = v:FindFirstChildWhichIsA("Model")
        if model then
            if model:FindFirstChildWhichIsA("MeshPart") and (model:FindFirstChildWhichIsA("MeshPart").Name:find("Coin") or model:FindFirstChildWhichIsA("MeshPart").Name:find("Ticket") or model:FindFirstChildWhichIsA("MeshPart").Name:find("coin")) then
                pickables = v
            end
            if model.Name:find("Egg") then
                game_eggs = v
            end
        end
    end
end

local data = local_data:Get()

local enable_webhook = false
local auto_gold_orb = false
local auto_playtime = false
local auto_collect = false
local auto_ticket = false
local auto_season = false
local auto_potion = false
local auto_wheel = false
local log_chests = false
local equip_best = false
local auto_hatch = false
local auto_chest = false
local auto_doggy = false
local auto_gift = false
local log_gifts = false
local auto_open = false
local log_chats = false
local auto_blow = false
local auto_sell = false
local auto_roll = false
local log_eggs = false
local stop_at = false

local selected_enchant_method = ""
local selected_gift = "Mystery Box"
local collect_method = "Remote"
local selected_enchant = ""
local selected_island = ""
local selected_potion = ""
local selected_dice = ""
local selected_egg = ""

local selected_enchant_slot = 1
local selected_potion_tier = 1
local chest_open_delay = 1
local potion_use_delay = 1
local collect_speed = 2
local open_amount = 10

local island_names = {}
local dice = {}
local egg = {}

local enchantments = {
    "⚡ Team Up I",
    "⚡ Team Up II",
    "⚡ Team Up III",
    "⚡ Team Up IV",
    "⚡ Team Up V",
    "💰 Looter I",
    "💰 Looter II",
    "💰 Looter III",
    "💰 Looter IV",
    "💰 Looter V",
    "🫧 Bubbler I",
    "🫧 Bubbler II",
    "🫧 Bubbler III",
    "🫧 Bubbler IV",
    "🫧 Bubbler V",
    "✨ Gleaming I",
    "✨ Gleaming II",
    "✨ Gleaming III",
    "🎲 High Roller",
    "∞ Infinity",
    "🧲 Magnetism"
}

local shops = {
    "Alien Shop",
    "Shard Shop"
}

local webhooks = {
    eggs = "",
    chests = "",
    gifts = "",
    chats = ""
}

local roles = {
    ["x25"] = "",
    ["Man Egg"] = "",
    ["Royale Chest"] = "",
    ["Silly Egg"] = ""
}

local potions = {
    "Speed",
    "Lucky",
    "Coins",
    "Mythic",
    "Infinity Elixir"
}

for _, v in next, eggs:GetChildren() do
    if not (v.Name:find("Golden") or v.Name:find("Season") or v.Name:find("Shop") or v.Name:find("Package") or v.Name:find("Easter") or v.Name:find("Series") or v.Name:find("Bunny") or v.Name:find("Pastel") or v.Name:find("Throwback") or v.Name:find("100M")) then
        table.insert(egg, v.Name)
    end
end

for _, v in next, overworld_islands:GetChildren() do
    table.insert(island_names, v.Name)
end

for _, v in next, minigame_paradise_islands:GetChildren() do
    table.insert(island_names, v.Name)
end

for _, v in next, dices:GetChildren() do
    table.insert(dice, v.Name)
end

rifts.ChildAdded:Connect(function(egg)
    task.wait(1)
    if (egg.Name:find("egg") or egg.Name:find("event")) and enable_webhook and log_eggs then
        local data = {
            ["username"] = "Notifier Made By @kylosilly",
            ["embeds"] = {
                {
                    ["title"] = "Egg Spawned!",
                    ["description"] = "Spawned Egg: " .. egg.Name .. " [" .. egg:FindFirstChild("Display"):FindFirstChild("SurfaceGui"):FindFirstChild("Icon"):FindFirstChild("Luck").ContentText .. "]",
                    ["color"] = 16777215,
                    ["footer"] = {
                        ["text"] = "Server JobId: " .. game.JobId
                    },
                    ["fields"] = {
                        {
                            ["name"] = "Height:",
                            ["value"] = math.floor(egg:FindFirstChild("Display").CFrame.Position.Y) .. "M",
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Despawns:",
                            ["value"] = "<t:" .. math.floor(egg:GetAttribute("DespawnAt")) .. ":R>",
                            ["inline"] = true
                        }
                    }
                }
            }
        }

        if egg.Name == "silly-egg" and roles["Silly Egg"] ~= "" then
            data["content"] = roles["Silly Egg"] .. " | Silly Egg Spawned!"
        elseif egg.Name == "silly-egg" and roles ["Silly Egg"] == "" then
            data["content"] = "@everyone | Silly Egg Spawned!"
        end

        if egg.Name == "man-egg" and roles["Man Egg"] ~= "" then
            data["content"] = roles["Man Egg"] .. " | Man Egg Spawned!"
        elseif egg.Name == "man-egg" and roles ["Man Egg"] == "" then
            data["content"] = "@everyone | Man Egg Spawned!"
        end

        if egg.Display.SurfaceGui.Icon.Luck.Text == "x25" and roles["x25"] ~= "" then
            data["content"] = roles["x25"]
        elseif egg.Display.SurfaceGui.Icon.Luck.Text == "x25" and roles["x25"] == "" then
            data["content"] = "@everyone"
        end

        httprequest({
            Url = webhooks.eggs,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = http_service:JSONEncode(data)
        })
    end
end)

rifts.ChildAdded:Connect(function(chest)
    task.wait(1)
    if chest.Name:find("chest") and enable_webhook and log_chests then
        local data = {
            ["username"] = "Notifier Made By @kylosilly",
            ["embeds"] = {
                {
                    ["title"] = "Chest Spawned!",
                    ["description"] = "Spawned Chest: " .. chest.Name,
                    ["color"] = 16777215,
                    ["footer"] = {
                        ["text"] = "Server JobId: " .. game.JobId
                    },
                    ["fields"] = {
                        {
                            ["name"] = "Height:",
                            ["value"] = math.floor(chest:FindFirstChild("Display").CFrame.Position.Y) .. "M",
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Despawns:",
                            ["value"] = "<t:" .. math.floor(chest:GetAttribute("DespawnAt")) .. ":R>",
                            ["inline"] = true
                        }
                    }
                }
            }
        }

        if chest.Name == "royal-chest" and roles["Royale Chest"] ~= "" then
            data["content"] = roles["Royale Chest"]
        elseif chest.Name == "royal-chest" and roles["Royale Chest"] == "" then
            data["content"] = "@everyone"
        end

        httprequest({
            Url = webhooks.chests,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = http_service:JSONEncode(data)
        })
    end
end)

rifts.ChildAdded:Connect(function(gift)
    task.wait(1)
    if gift.Name:find("gift") and enable_webhook and log_gifts then
        local data = {
            ["username"] = "Notifier Made By @kylosilly",
            ["embeds"] = {
                {
                    ["title"] = "Gift Rift",
                    ["description"] = "Gift Rift Spawned",
                    ["color"] = 16777215,
                    ["footer"] = {
                        ["text"] = "Server JobId: " .. game.JobId
                    },
                    ["fields"] = {
                        {
                            ["name"] = "Height:",
                            ["value"] = math.floor(gift:FindFirstChild("Display").CFrame.Position.Y) .. "M",
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Despawns:",
                            ["value"] = "<t:" .. math.floor(gift:GetAttribute("DespawnAt")) .. ":R>",
                            ["inline"] = true
                        }
                    }
                }
            }
        }

        httprequest({
            Url = webhooks.gifts,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = http_service:JSONEncode(data)
        })
    end
end)

players.PlayerAdded:Connect(function(player)
    task.wait(1)
    if enable_webhook and log_chats then
        local data = {
            ["username"] = "Notifier Made By @kylosilly",
            ["embeds"] = {
                {
                    ["title"] = "Player Joined!",
                    ["description"] = player.DisplayName .. " Joined The Server",
                    ["color"] = 16777215,
                }
            }
        }
    
        httprequest({
            Url = webhooks.chats,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = http_service:JSONEncode(data)
        })
    end
end)

players.PlayerRemoving:Connect(function(player)
    task.wait(1)
    if enable_webhook and log_chats then
        local data = {
            ["username"] = "Notifier Made By @kylosilly",
            ["embeds"] = {
                {
                    ["title"] = "Player Left!",
                    ["description"] = player.DisplayName .. " Left The Server",
                    ["color"] = 16777215,
                }
            }
        }
    
        httprequest({
            Url = webhooks.chats,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = http_service:JSONEncode(data)
        })
    end
end)

farm_group:AddToggle('auto_blow', {
    Text = 'Auto Blow Bubbles',
    Default = false,
    Tooltip = 'Auto Blows Bubbles',
    Callback = function(Value)
        auto_blow = Value
        if Value then
            repeat
                remote:FireServer("BlowBubble")
                task.wait(.5)
            until not auto_blow
        end
    end
})

farm_group:AddToggle('auto_sell', {
    Text = 'Auto Sell Bubbles',
    Default = false,
    Tooltip = 'Auto Sells Your Bubbles (MUST BE CLOSE TO A SELLZONE)',
    Callback = function(Value)
        auto_sell = Value
        if Value then
            repeat
                remote:FireServer("SellBubble")
                task.wait(.5)
            until not auto_sell
        end
    end
})

farm_group:AddDivider()

farm_group:AddButton({
    Text = 'Unequip Team',
    Func = function()
        for _, v in next, data.Teams[data.TeamEquipped].Pets do
            remote:FireServer("UnequipPet", v)
        end
    end,
    DoubleClick = false,
    Tooltip = 'Unequips Current Team',
})

farm_group:AddButton({
    Text = 'Craft Shiny Pets',
    Func = function()
        for _, v in next, data.Pets do
            local pet_count = shiny_utility:GetOwnedCount(data, v)
            if pet_count > 15 then
                remote:FireServer("MakePetShiny", v.Id)
                library:Notify("Made: " .. v.Name .. " Shiny")
            end
        end
    end,
    DoubleClick = false,
    Tooltip = 'Makes Pets Shiny That Can Be Shiny',
})

farm_group:AddToggle('equip_best', {
    Text = 'Auto Equip Best',
    Default = false,
    Tooltip = 'Auto Equips Best Pets',
    Callback = function(Value)
        equip_best = Value
        if Value then
            repeat
                remote:FireServer("EquipBestPets")
                task.wait(10)
            until not equip_best
        end
    end
})

farm_group:AddDivider()

farm_group:AddToggle('auto_collect', {
    Text = 'Auto Collect Coins/Gems',
    Default = false,
    Tooltip = 'Auto Collects Coins/Gems',
    Callback = function(Value)
        auto_collect = Value
        if Value then
            repeat
                local collectables = {}

                for _, v in next, pickables:GetChildren() do
                    if v:IsA("Model") then
                        table.insert(collectables, v)
                    end
                end

                if #collectables > 1 then
                    for i, v in next, collectables do
                        v:Destroy()
                        replicated_storage:WaitForChild("Remotes"):WaitForChild("Pickups"):WaitForChild("CollectPickup"):FireServer(v.Name)
                        table.remove(collectables, i)
                        task.wait(collect_speed)
                    end
                end

                if stop_at and local_player.PlayerGui.ScreenGui.HUD.Left.Currency.Gems.Frame.Max.Visible then
                    library:Notify("Stopped AutoFarm: Reached Max Gems")
                    auto_collect = false
                    break
                end
            until not auto_collect
        end
    end
})


farm_group:AddToggle('stop_at_max', {
    Text = 'Stop At Max Gems',
    Default = false,
    Tooltip = 'Stops Collecting At Max Gems',
    Callback = function(Value)
        stop_at = Value
    end
})
farm_group:AddSlider('auto_collect_speed', {
    Text = 'Auto Collect Speed',
    Default = collect_speed,
    Min = 2,
    Max = 5,
    Rounding = 0,
    Callback = function(Value)
        collect_speed = Value
    end
})

misc_group:AddButton({
    Text = 'Redeem All Codes',
    Func = function()
        for code in next, codes do
            remote:InvokeServer("RedeemCode", code)
            library:Notify('Redeemed Code: ' .. code)
        end
    end,
    DoubleClick = false,
    Tooltip = 'Redeems all codes wowoowdowadaw',
})

misc_group:AddButton({
    Text = 'Claim Free Legendary',
    Func = function()
        remote:FireServer("FreeNotifyLegendary")
        library:Notify('Legendary Claimed!')
    end,
    DoubleClick = false,
    Tooltip = 'Claims Free Legendary Pet',
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
        library:Notify("Anti Afk Enabled! (Credits to inf yield)")
    end,
    DoubleClick = false,
    Tooltip = 'Credits to inf yield <3',
})

misc_group:AddDivider()

misc_group:AddButton({
    Text = 'Unlock Overworld Islands',
    Func = function()
        for _, v in next, overworld_islands:GetDescendants() do
            if v.Name == "UnlockHitbox" then
                for i = 1, 10 do
                    firetouchinterest(local_player.Character.HumanoidRootPart, v, 0)
                    firetouchinterest(local_player.Character.HumanoidRootPart, v, 1)
                    task.wait(.1)
                end
            end
        end
    end,
    DoubleClick = false,
    Tooltip = 'Unlocks all islands',
})

misc_group:AddButton({
    Text = 'Unlock Minigame Islands',
    Func = function()
        for _, v in next, minigame_paradise_islands:GetDescendants() do
            if v.Name == "UnlockHitbox" then
                for i = 1, 10 do
                    firetouchinterest(local_player.Character.HumanoidRootPart, v, 0)
                    firetouchinterest(local_player.Character.HumanoidRootPart, v, 1)
                    task.wait(.1)
                end
            end
        end
    end,
    DoubleClick = false,
    Tooltip = 'Unlocks all islands',
})

auto_hatch_group:AddLabel('Removed Lucky Goto Eggs For Now Until Rewroten', true)

auto_hatch_group:AddDropdown('egg_select', {
    Values = egg,
    Default = "",
    Multi = false,

    Text = 'Select Egg',
    Tooltip = 'Select an egg to hatch',

    Callback = function(Value)
        selected_egg = Value
        if Value and auto_hatch then
            goto_egg()
        end
    end
})

auto_hatch_group:AddToggle('auto_hatch', {
    Text = 'Auto Hatch',
    Default = false,
    Tooltip = 'Auto Hatch Selected Egg',
    Callback = function(Value)
        auto_hatch = Value
        if selected_egg == "" then
            library:Notify("Please select an egg")
            auto_hatch = false
            return
        end

        function goto_egg()
            if Value and selected_egg == "Game Egg" then
                remote:FireServer("Teleport", "Workspace.Worlds.Minigame Paradise.PortalSpawn")
                task.wait(0.5)
                local velocity_connection = run_service.Heartbeat:Connect(function()
                    if local_player.Character.HumanoidRootPart then
                        local_player.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                        local_player.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                    end
                end)
                local to = game_eggs:FindFirstChild(selected_egg):FindFirstChildWhichIsA("Part")
                local distance = (to.Position - local_player.Character.HumanoidRootPart.Position).magnitude
                local tween = tween_service:Create(local_player.Character.HumanoidRootPart, TweenInfo.new(distance / 25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = CFrame.new(to.Position) + Vector3.new(0, 0, 3)})
                tween:Play()
                tween.Completed:Wait()
                if velocity_connection then
                    velocity_connection:Disconnect()
                end
                return
            elseif Value and selected_egg ~= "Game Egg" then
                remote:FireServer("Teleport", "Workspace.Worlds.The Overworld.FastTravel.Spawn")
                task.wait(0.5)
                local velocity_connection = run_service.Heartbeat:Connect(function()
                    if local_player.Character.HumanoidRootPart then
                        local_player.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                        local_player.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                    end
                end)
                local tween = tween_service:Create(local_player.Character.HumanoidRootPart, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = CFrame.new(workspace.Rendered.Generic["Infinity Egg"].Hitbox.Position)})
                tween:Play()
                tween.Completed:Wait()
                if velocity_connection then
                    velocity_connection:Disconnect()
                end
                local to = game_eggs:FindFirstChild(selected_egg):FindFirstChildWhichIsA("Part")
                local distance = (to.Position - local_player.Character.HumanoidRootPart.Position).magnitude
                local tween = tween_service:Create(local_player.Character.HumanoidRootPart, TweenInfo.new(distance / 25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = CFrame.new(to.Position) + Vector3.new(0, 0, 3)})
                tween:Play()
                tween.Completed:Wait()
            end
        end

        goto_egg()

        repeat
            remote:FireServer("HatchEgg", selected_egg, stat:GetMaxEggHatches(data))
            task.wait(stat:GetHatchSpeed(data) / 5)
        until not auto_hatch
    end
})

teleport_group:AddDropdown('island_selector', {
    Values = island_names,
    Default = "",
    Multi = false,

    Text = 'Island Selector',
    Tooltip = 'Select a island to teleport to',

    Callback = function(Value)
        selected_island = Value
    end
})

teleport_group:AddButton({
    Text = 'Teleport to selected island',
    Func = function()
        if selected_island == "" then
            library:Notify("Please select an island")
            return
        end

        if overworld_islands:FindFirstChild(selected_island) then
            library:Notify('Teleported to ' .. selected_island)
            remote:FireServer("Teleport", "Workspace.Worlds.The Overworld.Islands." .. selected_island .. ".Island.Portal.Spawn")
        elseif minigame_paradise_islands:FindFirstChild(selected_island) then
            library:Notify('Teleported to ' .. selected_island)
            remote:FireServer("Teleport", "Workspace.Worlds.Minigame Paradise.Islands." .. selected_island .. ".Island.Portal.Spawn")
        end
    end,
    DoubleClick = false,
    Tooltip = 'Teleports to selected island',
})

--[[
auto_enchant_group:AddDropdown('enchant_selector', {
    Values = enchantments,
    Default = selected_enchant,
    Multi = false,

    Text = 'Select Enchant:',
    Tooltip = 'Select a enchant to enchant your pet with',

    Callback = function(Value)
        selected_enchant = Value
    end
})

auto_enchant_group:AddDropdown('auto_enchant_method', {
    Values = { 'Reroll All', 'Reroll Slot' },
    Default = "Reroll All",
    Multi = false,

    Text = 'Select Enchant Method:',
    Tooltip = 'Select an enchant method to use',

    Callback = function(Value)
        selected_enchant_method = Value
    end
})
]]

auto_group:AddToggle('auto_doggy', {
    Text = 'Auto Doggy Minigame',
    Default = false,
    Tooltip = 'Auto Claims Doggy Jump Minigame',
    Callback = function(Value)
        auto_doggy = Value
        if Value then
            repeat
                for i = 1, 3 do
                    remote:FireServer("DoggyJumpWin", i)
                    task.wait(.25)
                end
                task.wait(600)
            until not auto_doggy
        end
    end
})

auto_group:AddDivider()

auto_group:AddToggle('auto_claim_chest', {
    Text = 'Auto Claim Chest',
    Default = false,
    Tooltip = 'Auto Claims Chest',
    Callback = function(Value)
        auto_chest = Value
        if Value then
            repeat
                for _, v in next, chest:GetChildren() do
                    remote:FireServer("ClaimChest", v.Name, true)
                end
                task.wait(300)
            until not auto_chest
        end
    end
})

auto_group:AddToggle('auto_claim_playtime', {
    Text = 'Auto Claim Playtime Rewards',
    Default = false,
    Tooltip = 'Auto Claims Playtime Rewards',
    Callback = function(Value)
        auto_playtime = Value
        if Value then
            repeat
                for i = 1, 9 do
                    remote:FireServer("ClaimPlaytime", i)
                    remote:InvokeServer("ClaimPlaytime", i)
                    task.wait()
                end
                task.wait(60)
            until not auto_playtime
        end
    end
})

auto_group:AddToggle('auto_claim_tickets', {
    Text = 'Auto Claim Tickets',
    Default = false,
    Tooltip = 'Auto Claims Tickets',
    Callback = function(Value)
        auto_ticket = Value
        if Value then
            repeat
                remote:FireServer("ClaimFreeWheelSpin")
                task.wait(1260)
            until not auto_ticket
        end
    end
})

auto_group:AddToggle('auto_spin_wheel', {
    Text = 'Auto Spin Wheel',
    Default = false,
    Tooltip = 'Auto Spins Wheel',
    Callback = function(Value)
        auto_wheel = Value
        if Value then
            repeat
                remote:InvokeServer("WheelSpin")
                remote:FireServer("ClaimWheelSpinQueue")
                task.wait(5)
            until not auto_wheel
        end
    end
})

auto_group:AddToggle('auto_claim_seasonal', {
    Text = 'Auto Claim Season Rewards',
    Default = false,
    Tooltip = 'Auto Claims Season Rewards',
    Callback = function(Value)
        auto_season = Value
        if Value then
            repeat
                remote:FireServer("ClaimSeason")
                task.wait(5)
            until not auto_season
        end
    end
})

auto_group:AddDivider()

auto_group:AddButton({
    Text = 'Get Everything In Claw Mashine',
    Func = function()
        if workspace:FindFirstChild("ClawMachine") then
            for _, v in next, workspace.ClawMachine:GetChildren() do
                if v.Name:find("Capsule") then
                    remote:FireServer("GrabMinigameItem", v:GetAttribute("ItemGUID"))
                    v:Destroy()
                    task.wait(3.5)
                end
            end
            remote:FireServer("FinishMinigame")
        else
            library:Notify("Claw Machine Not Found")
        end
    end,
    DoubleClick = false,
    Tooltip = 'Gets every capsule from claw mashine'
})

auto_group:AddButton({
    Text = 'Finish Paradise Minigame',
    Func = function()
        if not (local_player.PlayerGui.ScreenGui.MinigameHUD["Cart Escape"].Visible or local_player.PlayerGui.ScreenGui.MinigameHUD["Pet Match"].Visible) then
            library:Notify("Minigame Not Found")
            return
        end

        library:Notify("Wait ~20 sec for it to finish")
        task.wait(20)
        remote:FireServer("FinishMinigame")
    end,
    DoubleClick = false,
    Tooltip = 'Finishes current minigame'
})

auto_group:AddDivider()

auto_group:AddDropdown('dice_selector', {
    Values = dice,
    Default = selected_dice,
    Multi = false,

    Text = 'Select Dice To Roll:',
    Tooltip = 'Select a dice to use for auto roll',

    Callback = function(Value)
        selected_dice = Value
    end
})

auto_group:AddToggle('auto_roll', {
    Text = 'Auto Roll Dice',
    Default = auto_roll,
    Tooltip = 'Rolls selected dice',

    Callback = function(Value)
        auto_roll = Value
        if Value then
            if selected_dice == "" then
                library:Notify("Please select a dice to roll before using this")
                return
            end

            repeat
                remote:InvokeServer("RollDice", selected_dice)
                remote:FireServer("ClaimTile")
                task.wait(2)
            until not auto_roll
        end
    end
})

auto_use_group:AddDropdown('potion_dropdown', {
    Values = potions,
    Default = "",
    Multi = false,

    Text = 'Potion Selector',
    Tooltip = 'Select a potion to use',

    Callback = function(Value)
        selected_potion = Value
    end
})

auto_use_group:AddDropdown('tier_dropdown', {
    Values = { 1, 2, 3, 4, 5, 6 },
    Default = 1,
    Multi = false,

    Text = 'Potion Tier Selector',
    Tooltip = 'Select a tier to use',

    Callback = function(Value)
        selected_potion_tier = Value
    end
})

auto_use_group:AddSlider('use_delay', {
    Text = 'Potion Use Delay',
    Default = potion_use_delay,
    Min = 0,
    Max = 10,
    Rounding = 0,
    Callback = function(Value)
        potion_use_delay = Value
    end
})

auto_use_group:AddToggle('auto_potion', {
    Text = 'Auto Use Potions',
    Default = false,
    Tooltip = 'Auto Uses Potions',
    Callback = function(Value)
        auto_potion = Value
        if Value then
            repeat
                remote:FireServer("UsePotion", selected_potion, selected_potion_tier)
                library:Notify('Used ' .. selected_potion .. ' tier ' .. selected_potion_tier)
                task.wait(potion_use_delay)
            until not auto_potion
        end
    end
})

auto_use_group:AddDivider()

auto_use_group:AddToggle('auto_gold_orb', {
    Text = 'Auto Use Gold Orbs',
    Default = false,
    Tooltip = 'Auto Uses Gold Orbs',
    Callback = function(Value)
        auto_gold_orb = Value
        if Value then
            repeat
                remote:FireServer("UseGoldenOrb")
                task.wait(900)
            until not auto_gold_orb
        end
    end
})

auto_use_group:AddDivider()

auto_use_group:AddDropdown('gift_method_selector', {
    Values = { 'Mystery Box', 'Golden Box' },
    Default = selected_gift,
    Multi = false,

    Text = 'Select Which Gift To Open:',
    Tooltip = 'Select an gift you wanna auto open',

    Callback = function(Value)
        selected_gift = Value
    end
})

auto_use_group:AddToggle('auto_open', {
    Text = 'Auto Gift Chests',
    Default = false,
    Tooltip = 'Auto Opens Chests',
    Callback = function(Value)
        auto_open = Value
        if Value then
            repeat
                remote:FireServer("UseGift", selected_gift, open_amount)
                task.wait()
                for _, v in next, gifts:GetChildren() do
                    remote:FireServer("ClaimGift", v.Name)
                    v:Destroy()
                end
                task.wait(chest_open_delay)
            until not auto_open
        end
    end
})

auto_use_group:AddSlider('auto_open_amount', {
    Text = 'Auto Open Gift Amount',
    Default = open_amount,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Callback = function(Value)
        open_amount = Value
    end
})

auto_use_group:AddSlider('chest_open_delay', {
    Text = 'Gift Open Delay',
    Default = chest_open_delay,
    Min = 0,
    Max = 10,
    Rounding = 0,
    Callback = function(Value)
        chest_open_delay = Value
    end
})

webhook_group:AddToggle('webhook_enabler', {
    Text = 'Enable',
    Default = false,
    Tooltip = 'Enables the webhook logging',

    Callback = function(Value)
        enable_webhook = Value
    end
})

webhook_group:AddDivider()

webhook_group:AddToggle('log_eggs', {
    Text = 'Log Eggs',
    Default = false,
    Tooltip = 'Logs spawned eggs',

    Callback = function(Value)
        log_eggs = Value
        if Value and enable_webhook then
            for _, v in next, rifts:GetChildren() do
                if (v.Name:find("egg") or v.Name:find("event")) then
                    local c = v:Clone()
                    c.Parent = rifts
                    task.wait(2)
                    c:Destroy()
                end
            end
        end

        if log_eggs and webhooks.eggs == "" then
            library:Notify("Put in a webhook first!")
            log_eggs = false
        elseif log_eggs and not enable_webhook then
            library:Notify("Enable webhook logging first!")
            log_eggs = false
        end
    end
})

webhook_group:AddToggle('log_chests', {
    Text = 'Log Chests',
    Default = false,
    Tooltip = 'Logs spawned rift chests',

    Callback = function(Value)
        log_chests = Value
        if Value and enable_webhook then
            for _, v in next, rifts:GetChildren() do
                if v.Name:find("chest") then
                    local c = v:Clone()
                    c.Parent = rifts
                    task.wait(2)
                    c:Destroy()
                end
            end
        end

        if log_chests and webhooks.chests == "" then
            library:Notify("Put in a webhook first or enable webhook logging first!")
            log_chests = false
        elseif log_chests and not enable_webhook then
            library:Notify("Enable webhook logging first!")
            log_chests = false
        end
    end
})

webhook_group:AddToggle('log_gifts', {
    Text = 'Log Gifts',
    Default = false,
    Tooltip = 'Logs spawned gift rifts',

    Callback = function(Value)
        log_gifts = Value
        if Value and enable_webhook then
            for _, v in next, rifts:GetChildren() do
                if v.Name:find("gift") then
                    local c = v:Clone()
                    c.Parent = rifts
                    task.wait(2)
                    c:Destroy()
                end
            end
        end

        if log_gifts and webhooks.gifts == "" then
            library:Notify("Put in a webhook first!")
            log_gifts = false
        elseif log_gifts and not enable_webhook then
            library:Notify("Enable webhook logging first!")
            log_gifts = false
        end
    end
})

webhook_group:AddToggle('log_players', {
    Text = 'Log Players',
    Default = false,
    Tooltip = 'Logs players joining and leaving',

    Callback = function(Value)
        log_chats = Value
        if log_chats and webhooks.chats == "" then
            library:Notify("Put in a webhook first or enable webhook logging first!")
            log_chats = false
        elseif log_chats and not enable_webhook then
            library:Notify("Enable webhook logging first!")
            log_chats = false
        end
    end
})

webhook_group:AddDivider()

webhook_group:AddInput('egg_webhook', {
    Default = '',
    Numeric = false,
    Finished = true,

    Text = 'Webhook For Eggs Here:',
    Tooltip = 'Wont work without a webhook obviously',

    Placeholder = '',

    Callback = function(Value)
        webhooks.eggs = Value
        library:Notify("Webhook set to: " .. Value)
    end
})

webhook_group:AddInput('chest_webhook', {
    Default = '',
    Numeric = false,
    Finished = true,

    Text = 'Webhook For Chests Here:',
    Tooltip = 'Wont work without a webhook obviously',

    Placeholder = '',

    Callback = function(Value)
        webhooks.chests = Value
        library:Notify("Webhook set to: " .. Value)
    end
})

webhook_group:AddInput('gift_webhook', {
    Default = '',
    Numeric = false,
    Finished = true,

    Text = 'Webhook For Gifts Here:',
    Tooltip = 'Wont work without a webhook obviously',

    Placeholder = '',

    Callback = function(Value)
        webhooks.gifts = Value
        library:Notify("Webhook set to: " .. Value)
    end
})

webhook_group:AddInput('chat_webhook', {
    Default = '',
    Numeric = false,
    Finished = true,

    Text = 'Webhook For Chats Here:',
    Tooltip = 'Wont work without a webhook obviously',

    Placeholder = '',

    Callback = function(Value)
        webhooks.chats = Value
        library:Notify("Webhook set to: " .. Value)
    end
})

webhook_group:AddDivider()

webhook_group:AddInput('25x_ping', {
    Default = '',
    Numeric = false,
    Finished = true,

    Text = 'Role To Ping If Egg x25 Luck:',
    Tooltip = 'You can leave this as blank if you want it to ping everyone',

    Placeholder = '',

    Callback = function(Value)
        roles["x25"] = Value
        library:Notify("Role ID set to: " .. Value)
    end
})

webhook_group:AddInput('man_egg_ping', {
    Default = '',
    Numeric = false,
    Finished = true,

    Text = 'Role To Ping If Man Egg:',
    Tooltip = 'You can leave this as blank if you want it to ping everyone',

    Placeholder = '',

    Callback = function(Value)
        roles["man"] = Value
        library:Notify("Role ID set to: " .. Value)
    end
})

webhook_group:AddInput('royale_chest_ping', {
    Default = '',
    Numeric = false,
    Finished = true,

    Text = 'Role To Ping If Royale Chest:',
    Tooltip = 'You can leave this as blank if you want it to ping everyone',

    Placeholder = '',

    Callback = function(Value)
        roles["royale"] = Value
        library:Notify("Role ID set to: " .. Value)
    end
})

webhook_group:AddInput('silly_egg_ping', {
    Default = '',
    Numeric = false,
    Finished = true,

    Text = 'Role To Ping If Silly Egg :',
    Tooltip = 'You can leave this as blank if you want it to ping everyone',

    Placeholder = '',

    Callback = function(Value)
        roles["Silly Egg"] = Value
        library:Notify("Role ID set to: " .. Value)
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
    enable_webhook = false
    auto_gold_orb = false
    auto_playtime = false
    auto_collect = false
    auto_ticket = false
    auto_season = false
    auto_potion = false
    auto_wheel = false
    log_chests = false
    auto_hatch = false
    auto_chest = false
    auto_doggy = false
    equip_best = false
    log_gifts = false
    auto_gift = false
    log_chats = false
    auto_blow = false
    auto_open = false
    auto_sell = false
    auto_dice = false
    log_eggs = false
    stop_at = false
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
save_manager:SetFolder('Astolfo Ware/BGSI')
save_manager:BuildConfigSection(tabs['ui settings'])
theme_manager:ApplyToTab(tabs['ui settings'])
save_manager:LoadAutoloadConfig()
