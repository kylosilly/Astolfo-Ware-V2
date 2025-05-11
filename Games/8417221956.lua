local repo = 'https://raw.githubusercontent.com/KINGHUB01/Gui/main/'

local library = loadstring(game:HttpGet(repo .. 'Gui%20Lib%20%5BLibrary%5D'))()
local theme_manager = loadstring(game:HttpGet(repo .. 'Gui%20Lib%20%5BThemeManager%5D'))()
local save_manager = loadstring(game:HttpGet(repo .. 'Gui%20Lib%20%5BSaveManager%5D'))()

if not game:IsLoaded() then
    library:Notify("Waiting for game to load...")
    game.Loaded:Wait()
    library:Notify("Loaded Game")
end

local window = library:CreateWindow({
    Title = 'Astolfo Ware | https://discord.gg/SUTpER4dNc | Made by @kylosilly',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local tabs = {
    main = window:AddTab('Main'),
    esp = window:AddTab('Esp'),
    world = window:AddTab('World'),
    ['ui settings'] = window:AddTab('UI Settings')
}

local game_group = tabs.main:AddLeftGroupbox('Game Settings')
local player_group = tabs.main:AddRightGroupbox('Player Settings')
local ghost_esp_group = tabs.esp:AddLeftGroupbox('Ghost Esp Settings')
local player_esp_group = tabs.esp:AddRightGroupbox('Player Esp Settings')
local item_esp_group = tabs.esp:AddLeftGroupbox('Item Esp Settings')
local cursed_esp_group = tabs.esp:AddRightGroupbox('Cursed Esp Settings')
local evidence_esp_group = tabs.esp:AddLeftGroupbox('Evidence Esp Settings')
local closet_esp_group = tabs.esp:AddRightGroupbox('Closet Esp Settings')
local world_group = tabs.world:AddLeftGroupbox('World Settings')
local menu_group = tabs['ui settings']:AddLeftGroupbox('Menu')
local credits_group = tabs['ui settings']:AddRightGroupbox('Credits')
local settings_group = tabs['ui settings']:AddRightGroupbox('Menu Settings')

local proximity_prompt_service = game:GetService('ProximityPromptService')
local replicated_storage = game:GetService('ReplicatedStorage')
local user_input_service = game:GetService('UserInputService')
local text_chat_service = game:GetService('TextChatService')
local teleport_service = game:GetService('TeleportService')
local market = game:GetService('MarketplaceService')
local run_service = game:GetService('RunService')
local info = market:GetProductInfo(game.PlaceId)
local workspace = game:GetService('Workspace')
local lighting = game:GetService('Lighting')
local players = game:GetService('Players')
local local_player = players.LocalPlayer
local stats = game:GetService('Stats')
local camera = workspace.CurrentCamera

local evidence_folder = workspace.Dynamic.Evidence
local fingerprints = evidence_folder.Fingerprints
local dropped_equipment = workspace.Equipment
local motions = evidence_folder.MotionGrids
local orbs = evidence_folder.Orbs
local emfs = evidence_folder.EMF
local ghost = workspace.NPCs
local van = workspace.Van
local van_equipment = van.Equipment
local map = workspace.Map
local cursed_objects = map:FindFirstChild('cursed_object')
local bone = map:FindFirstChild('Bone')
local fuse_box = map:FindFirstChild("Fusebox"):FindFirstChild("Fusebox")
local closets = map.Closets
local rooms = map.Rooms

local cursed_object_highlight = false
local cursed_object_name = false
local found_fingerprint = false
local player_highlight = false
local closet_highlight = false
local highlight_ghost = false
local got_spirit_box = false
local item_highlight = false
local speed_sprint = false
local third_person = false
local jump_enabled = false
local closet_name = false
local player_name = false
local full_bright = false
local inf_stamina = false
local anti_touch = false
local show_ghost = false
local got_motion = false
local ghost_name = false
local no_motion = false
local item_name = false
local found_emf = false
local found_orb = false
local orbs_name = false
local emf_name = false
local inf_jump = false
local no_hold = false

local touch_distance = 7
local sprint_speed = 1

local ghost_room = nil

if game:IsLoaded() then
    local device = local_player:GetAttribute('Device')
    local gid = local_player:GetAttribute("GID")
    local join_time = local_player:GetAttribute('JoinTime')

    if device or gid or join_time then
        print("Script made by @kylosilly feel free to support me by joining my discord server!")
        print("Device: " .. device)
        print("LocalPlayer GID: " .. gid)
        print("Join Time: " .. os.date("%Y-%m-%d %H:%M:%S", join_time))
    end
else
    local_player:Kick('Game failed to load, please rejoin and retry... (If it keeps happening please contact @kylosilly on discord!)')
end

local emf_label = game_group:AddLabel('EMF 5: Not Found')
local fingerprint_label = game_group:AddLabel('Fingerprints: Not Found')
local freezing_label = game_group:AddLabel('Freezing: Not Found')
local motion_label = game_group:AddLabel('Motion: Not Found')
local orb_label = game_group:AddLabel('Orbs: Not Found')
local spirit_box_label = game_group:AddLabel('Spirit Box: Not Found')

game_group:AddDivider()

local last_emf_label = game_group:AddLabel('Last EMF: None')
local ghost_room_label = game_group:AddLabel('Ghost Room: Not Found')
local ghost_speed_label = game_group:AddLabel('Ghost Speed: Not Found')
local sanity_label = player_group:AddLabel('Sanity:')

emfs.ChildAdded:Connect(function(emf)
    if emf:IsA("Part") and emf.Name == 'EMF5' and not found_emf then
        emf_label:SetText('EMF 5: Yes')
        library:Notify("Found EMF 5")
        found_emf = true
    end

    if emf:IsA("Part") then
        last_emf_label:SetText('Last EMF: ' .. emf.Name)
        library:Notify("Last EMF: " .. emf.Name)
    end
end)

fingerprints.ChildAdded:Connect(function(fingerprint)
    if fingerprint:IsA("Part") and not found_fingerprint then
        fingerprint_label:SetText('Fingerprints: Yes')
        library:Notify("Found Fingerprint")
        found_fingerprint = true
    end
end)

orbs.ChildAdded:Connect(function(orb)
    if orb:IsA("Part") and not found_orb then
        orb_label:SetText('Orbs: Yes')
        library:Notify("Found Orbs")
        found_orb = true
    end
end)

motionconnection = run_service.RenderStepped:Connect(function()
    for _, motion in pairs(motions:GetDescendants()) do
        if motion:IsA("Part") then
            if motion.Color == Color3.fromRGB(252, 52, 52) then
                motion_label:SetText('Motion: Yes')
                library:Notify("Found Motion")
                got_motion = true
                motionconnection:Disconnect()
                break
            elseif motion.BrickColor == BrickColor.new("Toothpaste") then
                motion_label:SetText('Motion: No')
                library:Notify("No Motion Found")
                no_motion = true
                motionconnection:Disconnect()
                break
            end
        end
    end
end)

sanityconnection = run_service.RenderStepped:Connect(function()
    local sanity = van.SanityBoard.SurfaceGui.Frame.Players:FindFirstChild(local_player.DisplayName).Entire.Val

    if sanity then
        local sanity_value = sanity.Text
        sanity_label:SetText('Sanity: ' .. sanity_value)
    end

    if local_player.Character.Humanoid.Health < 0 then
        sanity_label:SetText('Sanity: Dead')
        sanityconnection:Disconnect()
    end
end)

ghostconnection = run_service.RenderStepped:Connect(function()
    if anti_touch then
        for _, v in pairs(ghost:GetChildren()) do
            if v:IsA("Model") then
                local Distance = (local_player.Character.HumanoidRootPart.Position - v.PrimaryPart.Position).Magnitude
                if Distance < touch_distance then
                    local_player.Character.HumanoidRootPart.CFrame = van.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
                    Library:Notify("Ghost was too close teleported to save place.")
                end
            end
        end

        for _, v in pairs(ghost:GetChildren()) do
            if v:IsA("Model") then
                local humanoid = v:FindFirstChild("Humanoid")
                ghost_speed_label:SetText('Ghost Speed: ' .. string.format("%.1f", humanoid.WalkSpeed))
            end
        end
    end
end)

playerconnection = run_service.RenderStepped:Connect(function()
    if inf_stamina then
        local_player:SetAttribute('Stamina', 100)
    end

    if speed_sprint then
        local_player:SetAttribute('Speed', sprint_speed)
    end

    if noclip then
        local_player.Character.HumanoidRootPart.CanCollide = false
        local_player.Character.UpperTorso.CanCollide = false
        local_player.Character.LowerTorso.CanCollide = false
        local_player.Character.Head.CanCollide = false
    end
end)

espconnection = run_service.RenderStepped:Connect(function()
    if not local_player.Character then
        local_player.CharacterAdded:Wait()
    end

    if show_ghost then
        for _, silly_ghost in pairs(ghost:GetChildren()) do
            if silly_ghost:IsA("Model") then
                silly_ghost:FindFirstChildOfClass("MeshPart").Transparency = 0
            end
        end

        if highlight_ghost then
            for _, silly_ghost in pairs(ghost:GetChildren()) do
                if silly_ghost:IsA("Model") and not silly_ghost:FindFirstChild("Highlight") then
                    local Highlight = Instance.new("Highlight")
                    Highlight.Parent = silly_ghost
                    Highlight.FillColor = highlight_color_ghost
                    Highlight.OutlineColor = highlight_color_ghost
                end
            end
        end

        if ghost_name then
            for _, silly_ghost in pairs(ghost:GetChildren()) do
                if silly_ghost:IsA("Model") and not silly_ghost:FindFirstChild("Esp BillBoard") then
                    local esp_billboard = Instance.new("BillboardGui")
                    esp_billboard.Parent = silly_ghost
                    esp_billboard.Name = "Esp BillBoard"
                    esp_billboard.Adornee = silly_ghost.PrimaryPart
                    esp_billboard.Size = UDim2.new(0, 100, 0, 50)
                    esp_billboard.StudsOffset = Vector3.new(0, 5, 0)
                    esp_billboard.AlwaysOnTop = true

                    local esp_text = Instance.new("TextLabel")
                    esp_text.Parent = esp_billboard
                    esp_text.Name = "Name Esp"
                    esp_text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    esp_text.Size = UDim2.new(1, 0, 1, 0)
                    esp_text.Text = "Ghost [" .. silly_ghost.Name .. "]"
                    esp_text.TextColor3 = Color3.fromRGB(255, 255, 255)
                    esp_text.TextSize = 14
                    esp_text.Font = "SourceSansBold"
                    esp_text.BackgroundTransparency = 1
                    esp_text.TextStrokeTransparency = 0
                    esp_text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                end
            end
        end
    end

    if player_name then
        for _, player in pairs(players:GetPlayers()) do
            if player ~= local_player and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("Humanoid") then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid.Health > 0 and not player.Character.Head:FindFirstChild("Esp BillBoard") then
                    local esp_billboard = Instance.new("BillboardGui")
                    esp_billboard.Parent = player.Character.Head
                    esp_billboard.Name = "Esp BillBoard"
                    esp_billboard.Adornee = player.Character.Head
                    esp_billboard.Size = UDim2.new(0, 100, 0, 50)
                    esp_billboard.StudsOffset = Vector3.new(0, 2, 0)
                    esp_billboard.AlwaysOnTop = true

                    local esp_text = Instance.new("TextLabel")
                    esp_text.Parent = esp_billboard
                    esp_text.Name = "Name Esp"
                    esp_text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    esp_text.Size = UDim2.new(1, 0, 1, 0)
                    esp_text.Text = player.DisplayName
                    esp_text.TextColor3 = Color3.fromRGB(255, 255, 255)
                    esp_text.TextSize = 14
                    esp_text.Font = "SourceSansBold"
                    esp_text.BackgroundTransparency = 1
                    esp_text.TextStrokeTransparency = 0
                    esp_text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                end
            end
        end
    end

    if player_highlight then
        for _, player in pairs(players:GetPlayers()) do
            if player ~= local_player and player.Character and player.Character:FindFirstChild("Humanoid") then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid.Health > 0 and not player.Character:FindFirstChild("Highlight") then
                    local Highlight = Instance.new("Highlight")
                    Highlight.Parent = player.Character
                    Highlight.FillColor = player_highlight_color
                    Highlight.OutlineColor = player_highlight_color
                end
            end
        end
    end

    if item_name then
        for _, v in next, van_equipment:GetChildren() do
            if v:IsA("Model") and not v:FindFirstChild("Esp BillBoard") then
                local esp_billboard = Instance.new("BillboardGui")
                esp_billboard.Parent = v
                esp_billboard.Name = "Esp BillBoard"
                esp_billboard.Adornee = v.PrimaryPart
                esp_billboard.Size = UDim2.new(0, 100, 0, 50)
                esp_billboard.StudsOffset = Vector3.new(0, 1, 0)
                esp_billboard.AlwaysOnTop = true

                local esp_text = Instance.new("TextLabel")
                esp_text.Parent = esp_billboard
                esp_text.Name = "Name Esp"
                esp_text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                esp_text.Size = UDim2.new(1, 0, 1, 0)
                esp_text.Text = v.Name
                esp_text.TextColor3 = Color3.fromRGB(255, 255, 255)
                esp_text.TextSize = 14
                esp_text.Font = "SourceSansBold"
                esp_text.BackgroundTransparency = 1
                esp_text.TextStrokeTransparency = 0
                esp_text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            end
        end
    end

    if item_name then
        for _, v in next, dropped_equipment:GetChildren() do
            if v:IsA("Model") and not v:FindFirstChild("Esp BillBoard") then
                local esp_billboard = Instance.new("BillboardGui")
                esp_billboard.Parent = v
                esp_billboard.Name = "Esp BillBoard"
                esp_billboard.Adornee = v.PrimaryPart
                esp_billboard.Size = UDim2.new(0, 100, 0, 50)
                esp_billboard.StudsOffset = Vector3.new(0, 1, 0)
                esp_billboard.AlwaysOnTop = true

                local esp_text = Instance.new("TextLabel")
                esp_text.Parent = esp_billboard
                esp_text.Name = "Name Esp"
                esp_text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                esp_text.Size = UDim2.new(1, 0, 1, 0)
                esp_text.Text = v.Name
                esp_text.TextColor3 = Color3.fromRGB(255, 255, 255)
                esp_text.TextSize = 14
                esp_text.Font = "SourceSansBold"
                esp_text.BackgroundTransparency = 1
                esp_text.TextStrokeTransparency = 0
                esp_text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            end
        end
    end

    if item_highlight then
        for _, v in next, dropped_equipment:GetChildren() do
            if v:IsA("Model") and not v:FindFirstChild("Highlight") then
                local Highlight = Instance.new("Highlight")
                Highlight.Parent = v
                Highlight.FillColor = item_highlight_color
                Highlight.OutlineColor = item_highlight_color
            end
        end
    end

    if item_highlight then
        for _, v in next, van_equipment:GetChildren() do
            if v:IsA("Model") and not v:FindFirstChild("Highlight") then
                local Highlight = Instance.new("Highlight")
                Highlight.Parent = v
                Highlight.FillColor = item_highlight_color
                Highlight.OutlineColor = item_highlight_color
            end
        end
    end
    
    if cursed_object_name then
        for _, v in next, cursed_objects:GetChildren() do
            if (v:IsA("MeshPart") or v:IsA("Model") or v:IsA("Part")) and not (v.Name == "Chair" or v.Name == "Body" or v.Name == "Eye1" or v.Name == "Eye2") and not v:FindFirstChild("Esp BillBoard") then
                local esp_billboard = Instance.new("BillboardGui")
                esp_billboard.Parent = v
                esp_billboard.Name = "Esp BillBoard"
                esp_billboard.Adornee = v
                esp_billboard.Size = UDim2.new(0, 100, 0, 50)
                esp_billboard.StudsOffset = Vector3.new(0, 1, 0)
                esp_billboard.AlwaysOnTop = true

                local esp_text = Instance.new("TextLabel")
                esp_text.Parent = esp_billboard
                esp_text.Name = "Name Esp"
                esp_text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                esp_text.Size = UDim2.new(1, 0, 1, 0)
                esp_text.Text = v.Name
                esp_text.TextColor3 = Color3.fromRGB(255, 255, 255)
                esp_text.TextSize = 14
                esp_text.Font = "SourceSansBold"
                esp_text.BackgroundTransparency = 1
                esp_text.TextStrokeTransparency = 0
                esp_text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            end
        end
    end

    if cursed_object_highlight then
        for _, v in next, cursed_objects:GetChildren() do
            if (v:IsA("MeshPart") or v:IsA("Model") or v:IsA("Part")) and not (v.Name == "Chair" or v.Name == "Body") and not v:FindFirstChild("Highlight") then
                local Highlight = Instance.new("Highlight")
                Highlight.Parent = v
                Highlight.FillColor = cursed_object_highlight_color
                Highlight.OutlineColor = cursed_object_highlight_color
            end
        end
    end

    if emf_name then
        for _, v in next, emfs:GetChildren() do
            if v:IsA("Part") and not v:FindFirstChild("Esp BillBoard") then
                local esp_billboard = Instance.new("BillboardGui")
                esp_billboard.Parent = v
                esp_billboard.Name = "Esp BillBoard"
                esp_billboard.Adornee = v
                esp_billboard.Size = UDim2.new(0, 100, 0, 50)
                esp_billboard.StudsOffset = Vector3.new(0, 1, 0)
                esp_billboard.AlwaysOnTop = true

                local esp_text = Instance.new("TextLabel")
                esp_text.Parent = esp_billboard
                esp_text.Name = "Name Esp"
                esp_text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                esp_text.Size = UDim2.new(1, 0, 1, 0)
                esp_text.Text = v.Name
                esp_text.TextColor3 = Color3.fromRGB(255, 255, 255)
                esp_text.TextSize = 14
                esp_text.Font = "SourceSansBold"
                esp_text.BackgroundTransparency = 1
                esp_text.TextStrokeTransparency = 0
                esp_text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            end
        end
    end

    if orbs_name then
        for _, v in next, orbs:GetChildren() do
            if v:IsA("Part") and not v:FindFirstChild("Esp BillBoard") then
                local esp_billboard = Instance.new("BillboardGui")
                esp_billboard.Parent = v
                esp_billboard.Name = "Esp BillBoard"
                esp_billboard.Adornee = v
                esp_billboard.Size = UDim2.new(0, 100, 0, 50)
                esp_billboard.StudsOffset = Vector3.new(0, 1, 0)
                esp_billboard.AlwaysOnTop = true

                local esp_text = Instance.new("TextLabel")
                esp_text.Parent = esp_billboard
                esp_text.Name = "Name Esp"
                esp_text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                esp_text.Size = UDim2.new(1, 0, 1, 0)
                esp_text.Text = v.Name
                esp_text.TextColor3 = Color3.fromRGB(255, 255, 255)
                esp_text.TextSize = 14
                esp_text.Font = "SourceSansBold"
                esp_text.BackgroundTransparency = 1
                esp_text.TextStrokeTransparency = 0
                esp_text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            end
        end
    end

    if closet_name then
        for _, v in next, closets:GetChildren() do
            if v:IsA("Model") and not v:FindFirstChild("Esp BillBoard") then
                local esp_billboard = Instance.new("BillboardGui")
                esp_billboard.Parent = v
                esp_billboard.Name = "Esp BillBoard"
                esp_billboard.Adornee = v
                esp_billboard.Size = UDim2.new(0, 100, 0, 50)
                esp_billboard.StudsOffset = Vector3.new(0, 5, 0)
                esp_billboard.AlwaysOnTop = true

                local esp_text = Instance.new("TextLabel")
                esp_text.Parent = esp_billboard
                esp_text.Name = "Name Esp"
                esp_text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                esp_text.Size = UDim2.new(1, 0, 1, 0)
                esp_text.Text = v.Name
                esp_text.TextColor3 = Color3.fromRGB(255, 255, 255)
                esp_text.TextSize = 14
                esp_text.Font = "SourceSansBold"
                esp_text.BackgroundTransparency = 1
                esp_text.TextStrokeTransparency = 0
                esp_text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            end
        end
    end

    if closet_highlight then
        for _, v in next, closets:GetChildren() do
            if v:IsA("Model") and not v:FindFirstChild("Highlight") then
                local highlight = Instance.new("Highlight")
                highlight.Parent = v
                highlight.FillColor = closet_highlight_color
                highlight.OutlineColor = closet_highlight_color
            end
        end
    end
end)

proximity_prompt_service.PromptButtonHoldBegan:Connect(function(prompt)
    if no_hold then
        prompt.HoldDuration = 0
    end
end)

user_input_service.JumpRequest:Connect(function()
    if inf_jump then
        local_player.Character.Humanoid:ChangeState("Jumping")
    end
end)

game_group:AddDivider()

game_group:AddButton({
    Text = 'Collect Bone',

    Func = function()
        if bone then
            bone_prompt = bone:FindFirstChildOfClass("ProximityPrompt")
            last_pos = local_player.Character.HumanoidRootPart.CFrame

            if bone_prompt then
                local_player.Character.HumanoidRootPart.CFrame = bone.CFrame + Vector3.new(0, 5, 0)
                task.wait(.25)
                fireproximityprompt(bone_prompt)
                task.wait(.25)
                local_player.Character.HumanoidRootPart.CFrame = last_pos
                library:Notify("Collected Bone")
            end
        else
            library:Notify("Bone not found")
        end
    end,
    DoubleClick = false,
    Tooltip = 'Collects the bone'
})

game_group:AddButton({
    Text = 'Enable Power',

    Func = function()
        for _, v in next, fuse_box:GetChildren() do
            if v:IsA("ProximityPrompt") and v.name == "FuseboxPrompt" then
                local last_pos = local_player.Character.HumanoidRootPart.CFrame
                local_player.Character.HumanoidRootPart.CFrame = v.Parent.CFrame
                task.wait(.2)
                fireproximityprompt(v)
                task.wait(.2)
                local_player.Character.HumanoidRootPart.CFrame = last_pos
                local fuse_box_toggles = Workspace.Map.Fusebox
                if fuse_box_toggles then
                    if fuse_box_toggles:FindFirstChild("On").Transparency == 0 then
                        library:Notify("Turned off power box.")
                    else
                        if fuse_box_toggles:FindFirstChild("Off").Transparency == 0 then
                            library:Notify("Turned on power box.")
                        end
                    end
                end
            end
        end
    end,
    DoubleClick = false,
    Tooltip = 'Turns on/off the power box'
})

game_group:AddDivider()

game_group:AddButton({
    Text = 'Find Ghost Room',

    Func = function()
        local emf_tool = local_player.Character and local_player.Character:FindFirstChild("EquipmentModel") and local_player.Character.EquipmentModel:FindFirstChild("2")
        local emf = local_player.Character and local_player.Character:FindFirstChild("EquipmentModel") and local_player.Character.EquipmentModel:FindFirstChild("1")
        local last_pos = local_player.Character.HumanoidRootPart.CFrame

        if not emf_tool then
            library:Notify("Equip EMF reader first!")
            return
        end

        if not emf or emf.Color ~= Color3.fromRGB(52, 142, 64) then
            replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("Toggle"):InvokeServer("EMF Reader")
        end

        if not ghost:FindFirstChildOfClass("Model") then
            library:Notify("Open the van first!")
            return
        end

        for _, room in pairs(rooms:GetChildren()) do
            if room:IsA("Folder") then
                local hitbox = room:FindFirstChild("Hitbox")

                if hitbox then
                    local_player.Character.HumanoidRootPart.CFrame = hitbox.CFrame
                    camera.CFrame = hitbox.CFrame
                    task.wait(0.75)

                    if emf_tool.Color == Color3.fromRGB(131, 156, 49) then
                        ghost_room = hitbox.CFrame
                        ghost_room_label:SetText("Ghost Room: " .. room.Name)
                        library:Notify("Ghost Room: " .. room.Name .. " (It Not Might Be Always The Ghost Room!)")
                        local_player.Character.HumanoidRootPart.CFrame = last_pos
                        break
                    end
                end
            end
        end

        if not ghost_room then
            task.wait(0.75)
            library:Notify("Ghost room not found retrying...")
            for _, room in pairs(rooms:GetChildren()) do
                if room:IsA("Folder") then
                    local hitbox = room:FindFirstChild("Hitbox")

                    if hitbox then
                        local_player.Character.HumanoidRootPart.CFrame = hitbox.CFrame
                        camera.CFrame = hitbox.CFrame
                        task.wait(0.75)

                        if emf_tool.Color == Color3.fromRGB(131, 156, 49) then
                            ghost_room = hitbox.CFrame
                            ghost_room_label:SetText("Ghost Room: " .. room.Name)
                            library:Notify("Ghost Room: " .. room.Name .. " (It Not Might Be Always The Ghost Room!)")
                            local_player.Character.HumanoidRootPart.CFrame = last_pos
                            break
                        end
                    end
                end
            end

            if not ghost_room then
                library:Notify("Ghost room not found")
                local_player.Character.HumanoidRootPart.CFrame = last_pos
            end
        end
    end,
    DoubleClick = false,
    Tooltip = 'Searches for the ghost room with the EMF reader'
})

game_group:AddButton({
    Text = 'Check Freezing',

    Func = function()
            local thermometer = local_player.Character:FindFirstChild("EquipmentModel") and local_player.Character.EquipmentModel:FindFirstChild("Temp") and local_player.Character.EquipmentModel.Temp:FindFirstChild("SurfaceGui") and local_player.Character.EquipmentModel.Temp.SurfaceGui:FindFirstChild("TextLabel")
            local thermometer_screen = local_player.Character:FindFirstChild("EquipmentModel") and local_player.Character.EquipmentModel:FindFirstChild("Temp") and local_player.Character.EquipmentModel.Temp:FindFirstChild("SurfaceGui")

            if not thermometer then
                library:Notify("Equip thermometer first!")
                return
            end

            if not thermometer_screen.Enabled then
                replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("Toggle"):InvokeServer("Thermometer")
            end

            if not ghost_room then
                Library:Notify("Ghost room not found")
                return
            end

            if ghost_room then
                local last_pos = local_player.Character.HumanoidRootPart.CFrame
                local_player.Character.HumanoidRootPart.CFrame = ghost_room

                task.wait(9)

                local tempeture = tonumber(thermometer.Text:match("[-%d]+"))

                if tempeture and tempeture < 0 then
                    library:Notify("Got Freezing Temperature")
                    freezing_label:SetText("Freezing: Yes")
                    got_freezing = true
                    checked_freezing = true
                else
                    library:Notify("No Freezing Temperature")
                    freezing_label:SetText("Freezing: No")
                    checked_freezing = true
                end

                local_player.Character.HumanoidRootPart.CFrame = last_pos
            end
    end,
    DoubleClick = false,
    Tooltip = 'Checks for freezing temperature'
})

game_group:AddButton({
    Text = 'Check Spirit Box',

    Func = function()
        local spirit_box = local_player.Character:FindFirstChild("EquipmentModel") and local_player.Character.EquipmentModel:FindFirstChild("Main")
        local spirit_box_screen = local_player.Character:FindFirstChild("EquipmentModel") and local_player.Character.EquipmentModel:FindFirstChild("Screen")

        if not spirit_box then
            library:Notify("Equip spirit box first!")
            return
        end

        if spirit_box_screen.Color == Color3.fromRGB(0, 0, 0) then
            replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("Toggle"):InvokeServer("Spirit Box")
        end

        if not ghost_room then
            Library:Notify("Ghost room not found")
            return
        end

        if ghost_room then
            local last_pos = local_player.Character.HumanoidRootPart.CFrame
            local_player.Character.HumanoidRootPart.CFrame = ghost_room

            local responses
            responses = spirit_box.DescendantAdded:Connect(function(reply)
                if reply:IsA("BillboardGui") then
                    responses:Disconnect()
                    got_spirit_box = true
                    library:Notify("Got Spirit Box")
                    spirit_box_label:SetText("Spirit Box: Yes")
                end
            end)

            for i = 1, 15 do
                text_chat_service:FindFirstChild("TextChannels").RBXGeneral:SendAsync("Where are you?")
                task.wait(1)

                if got_spirit_box then
                    local_player.Character.HumanoidRootPart.CFrame = last_pos
                    break
                end
            end

            if not got_spirit_box then
                library:Notify("No Spirit Box")
                spirit_box_label:SetText("Spirit Box: No")
                local_player.Character.HumanoidRootPart.CFrame = last_pos
            end
        end
    end,
    DoubleClick = false,
    Tooltip = 'Checks for spirit box'
})

game_group:AddButton({
    Text = 'Tp Motion Sensor To Ghost',

    Func = function()
        local motion_grid = evidence_folder.MotionGrids:FindFirstChild("SensorGrid")

        if motion_grid then
            library:Notify("Teleporting Motion Grids to the ghost...")
            local last_pos = {}

            for _, motion_grids in pairs(motion_grid:GetChildren()) do
                if motion_grids:IsA("Part") then
                    last_pos[motion_grids] = motion_grids.CFrame
                    local ghost = workspace.NPCs:FindFirstChildOfClass("Model")
                    motion_grids.CFrame = ghost.HumanoidRootPart.CFrame + Vector3.new(1, 0, 0)
                end
            end
        
            task.wait()
        
            for v, pos in pairs(last_pos) do
                v.CFrame = pos
            end
        end

        if not motion_grid then
            library:Notify("Motion Grids not found place one before using this feature!")
        end
    end,
    DoubleClick = false,
    Tooltip = 'Teleports Motion Grids to the ghost to check for motion'
})

game_group:AddDivider()

game_group:AddButton({
    Text = 'Tp To Van',

    Func = function()
        local_player.Character.HumanoidRootPart.CFrame = van.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
    end,
    DoubleClick = false,
    Tooltip = 'Teleports you to the van'
})

game_group:AddButton({
    Text = 'Tp To Ghost Room',

    Func = function()
        if ghost_room then
            local_player.Character.HumanoidRootPart.CFrame = ghost_room
        else
            Library:Notify("Ghost room not found")
        end
    end,
    DoubleClick = false,
    Tooltip = 'Teleports you to the ghost room'
})

game_group:AddDivider()

game_group:AddToggle('anti_ghost_touch', {
    Text = 'Anti Ghost Touch',
    Default = false,
    Tooltip = 'Prevents you from touching the ghost and dying',

    Callback = function(Value)
        anti_touch = Value
    end,
}):AddKeyPicker('anti_touch_keybind', {
    Default = '',
    SyncToggleState = true,
    Mode = 'Toggle',
    Text = 'Anti Touch Ghost',
    NoUI = false,
    Callback = function()
    end,
})

game_group:AddSlider('anti_touch_distance', {
    Text = 'Anti Touch Distance',
    Default = 7,
    Min = 7,
    Max = 12,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        touch_distance = Value
    end
})

player_group:AddDivider()

player_group:AddToggle('no_hold', {
    Text = 'No Hold',
    Default = false,
    Tooltip = 'Removes hold time from proximityprompts',

    Callback = function(Value)
        no_hold = Value
    end
})

player_group:AddToggle('third_person', {
    Text = '3rd Person',
    Default = false,
    Tooltip = 'idk why i really added it bc its uselss',

    Callback = function(Value)
        third_person = Value
        if Value then
            local_player.Character.Humanoid.CameraOffset = Vector3.new(0, 1, 2)
        else
            local_player.Character.Humanoid.CameraOffset = Vector3.new(0, 0, -1)
        end
    end,
}):AddKeyPicker('third_person_keybind', {
    Default = '',
    SyncToggleState = true,
    Mode = 'Toggle',
    Text = '3rd Person',
    NoUI = false,
    Callback = function()
    end,
})

player_group:AddToggle('allow_jumping', {
    Text = 'Enable Jumping',
    Default = false,
    Tooltip = 'Lets you jump',

    Callback = function(Value)
        jump_enabled = Value
        if Value then
            local_player.Character.Humanoid.JumpPower = 30
            local_player.Character.Humanoid.JumpHeight = 7.2
        else
            local_player.Character.Humanoid.JumpPower = 0
            local_player.Character.Humanoid.JumpHeight = 0
        end
    end
})

player_group:AddToggle('inf_jump', {
    Text = 'Inf Jump',
    Default = false,
    Tooltip = 'Lets you jump forever',

    Callback = function(Value)
        inf_jump = Value
    end
})

player_group:AddToggle('no_clip', {
    Text = 'No Clip',
    Default = false,
    Tooltip = 'Lets you clip through walls',

    Callback = function(Value)
        noclip = Value
        if not Value then
            local_player.Character.HumanoidRootPart.CanCollide = true
            local_player.Character.UpperTorso.CanCollide = true
            local_player.Character.LowerTorso.CanCollide = true
            local_player.Character.Head.CanCollide = true
        end
    end
})

player_group:AddDivider()

player_group:AddToggle('inf_stamina', {
    Text = 'Inf Stamina',
    Default = false,
    Tooltip = 'Gives you inf stamina',

    Callback = function(Value)
        inf_stamina = Value
    end
})

player_group:AddToggle('speed sprint modify', {
    Text = 'Speed Sprint Changer',
    Default = false,
    Tooltip = 'Changes how fast you sprint',

    Callback = function(Value)
        speed_sprint = Value
    end
})

player_group:AddSlider('sprint_speed', {
    Text = 'Sprint Speed',
    Default = 1,
    Min = 0.1,
    Max = 10,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        sprint_speed = Value
    end
})

player_group:AddDivider()

if map:GetAttribute("MapName") == "Cargo" then
    player_group:AddLabel("Unlocks Plunge Badge With Skin On Click (Run This Before Round Start Or You Will Die.)", true)
    player_group:AddButton({
        Text = 'Unlock Easeter Egg',
    
        Func = function()
            local easter_egg = map:FindFirstChild("EE"):FindFirstChild("Jump"):FindFirstChildOfClass("ProximityPrompt")
            if easter_egg then
                local last_pos = local_player.Character.HumanoidRootPart.CFrame
                local_player.Character.HumanoidRootPart.CFrame = easter_egg.Parent.CFrame
                task.wait(0.1)
                local_player.Character.HumanoidRootPart.CFrame = last_pos
                fireproximityprompt(easter_egg)
                library:Notify("Unlocked Plunge Easeter Egg")
            else
                library:Notify("Plunge Easter Egg Not Found?? (Report To @kylosilly On Discord)")
            end
        end,
        DoubleClick = false,
        Tooltip = 'Unlocks Plunge Badge With Skin'
    })
elseif map:GetAttribute("MapName") == "Luxury Home" then
    player_group:AddLabel("Unlocks The Laptop Badge With Skin On Click", true)
    player_group:AddButton({
        Text = 'Unlock Easeter Egg',
    
        Func = function()
            local laptop = map:FindFirstChild("EE"):FindFirstChild("Laptop"):FindFirstChild("Screen"):FindFirstChildOfClass("ProximityPrompt")
            if laptop then
                local last_pos = local_player.Character.HumanoidRootPart.CFrame
                local_player.Character.HumanoidRootPart.CFrame = laptop.Parent.CFrame
                task.wait(0.1)
                fireproximityprompt(laptop)
                local_player.Character.HumanoidRootPart.CFrame = last_pos
                library:Notify("Unlocked Laptop Easeter Egg")
            else
                library:Notify("Laptop not found?? (Report To @kylosilly On Discord)")
            end
        end,
        DoubleClick = false,
        Tooltip = 'Unlocks Laptop Badge With Skin'
    })
elseif map:FindFirstChild("EE") then
    player_group:AddLabel("Found Easter Egg On This Map But Is Not Supported", true)
else
    player_group:AddLabel("No Easter Eggs Found On This Map", true)
end

ghost_esp_group:AddToggle('always_show', {
    Text = 'Always Show Ghost',
    Default = false,
    Tooltip = 'Shows the ghost at all times',

    Callback = function(Value)
        show_ghost = Value
        if not Value then
            for _, v in next, ghost:GetChildren() do
                if v:IsA("Model") then
                    v:FindFirstChildOfClass("MeshPart").Transparency = 1
                end
            end
        end
    end
})

ghost_esp_group:AddToggle('ghost_name', {
    Text = 'Ghost Name Esp',
    Default = false,
    Tooltip = 'Shows the ghost name',

    Callback = function(Value)
        ghost_name = Value
        if not Value then
            for _, v in next, ghost:GetChildren() do
                if v:IsA("Model") and v:FindFirstChild("Esp BillBoard") then
                    v:FindFirstChild("Esp BillBoard"):Destroy()
                end
            end
        end
    end
})

ghost_esp_group:AddToggle('highlight_ghost', {
    Text = 'Highlight Ghost',
    Default = false,
    Tooltip = 'Highlights the ghost',

    Callback = function(Value)
        highlight_ghost = Value
        if not Value then
            for _, v in next, ghost:GetChildren() do
                if v:IsA("Model") and v:FindFirstChild("Highlight") then
                    v:FindFirstChild("Highlight"):Destroy()
                end
            end
        end
    end
}):AddColorPicker('highlight_color_ghost', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'Highlight Color',

    Callback = function(Value)
        highlight_color_ghost = Value
        for _, v in next, ghost:GetChildren() do
            if v:IsA("Model") and v:FindFirstChild("Highlight") then
                v:FindFirstChild("Highlight").FillColor = Value
                v:FindFirstChild("Highlight").OutlineColor = Value
            end
        end
    end
})

player_esp_group:AddToggle('player_name', {
    Text = 'Player Name Esp',
    Default = false,
    Tooltip = 'Shows the player name',

    Callback = function(Value)
        player_name = Value
        if not Value then
            for _, v in next, players:GetPlayers() do
                if v.Character and v.Character:FindFirstChild("Head") then
                    local esp_billboard = v.Character.Head:FindFirstChild("Esp BillBoard")
                    if esp_billboard then
                        espbillboard:Destroy()
                    end
                end
            end
        end
    end
})

player_esp_group:AddToggle('highlight_player', {
    Text = 'Highlight Player',
    Default = false,
    Tooltip = 'Highlights the player',

    Callback = function(Value)
        player_highlight = Value
        if not Value then
            for _, v in next, players:GetPlayers() do
                if v.Character and v.Character:FindFirstChild("Highlight") then
                    local highlight = v.Character:FindFirstChild("Highlight")
                    if highlight then
                        highlight:Destroy()
                    end
                end
            end
        end
    end
}):AddColorPicker('highlight_color_player', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'Highlight Color',

    Callback = function(Value)
        player_highlight_color = Value
        for _, v in next, players:GetPlayers() do
            if v.Character and v.Character:FindFirstChild("Highlight") then
                local highlight = v.Character:FindFirstChild("Highlight")
                if highlight then
                    highlight.FillColor = Value
                    highlight.OutlineColor = Value
                end
            end
        end
    end
})

item_esp_group:AddToggle('item_name', {
    Text = 'Item Name Esp',
    Default = false,
    Tooltip = 'Shows the item name',

    Callback = function(Value)
        item_name = Value
        if not Value then
            for _, tool in next, van_equipment:GetChildren() do
                if tool:IsA("Model") and tool:FindFirstChild("Esp BillBoard") then
                    tool:FindFirstChild("Esp BillBoard"):Destroy()
                end
            end

            for _, tool in next, dropped_equipment:GetChildren() do
                if tool:IsA("Model") and tool:FindFirstChild("Esp BillBoard") then
                    tool:FindFirstChild("Esp BillBoard"):Destroy()
                end
            end
        end
    end
})

item_esp_group:AddToggle('highlight_item', {
    Text = 'Highlight Item',
    Default = false,
    Tooltip = 'Highlights the item',

    Callback = function(Value)
        item_highlight = Value
        if not Value then
            for _, tool in next, van_equipment:GetChildren() do
                if tool:IsA("Model") and tool:FindFirstChild("Highlight") then
                    tool:FindFirstChild("Highlight"):Destroy()
                end
            end

            for _, tool in next, dropped_equipment:GetChildren() do
                if tool:IsA("Model") and tool:FindFirstChild("Highlight") then
                    tool:FindFirstChild("Highlight"):Destroy()
                end
            end
        end
    end
}):AddColorPicker('highlight_color_item', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'Highlight Color',

    Callback = function(Value)
        item_highlight_color = Value
        for _, v in next, van_equipment:GetChildren() do
            if v:IsA("Model") and v:FindFirstChild("Highlight") then
                v:FindFirstChild("Highlight").FillColor = Value
                v:FindFirstChild("Highlight").OutlineColor = Value
            end
        end

        for _, v in next, dropped_equipment:GetChildren() do
            if v:IsA("Model") and v:FindFirstChild("Highlight") then
                v:FindFirstChild("Highlight").FillColor = Value
                v:FindFirstChild("Highlight").OutlineColor = Value
            end
        end
    end
})

cursed_esp_group:AddToggle('cursed_object_name', {
    Text = 'Cursed Object Name',
    Default = false,
    Tooltip = 'Shows the cursed object name',

    Callback = function(Value)
        cursed_object_name = Value
        if not Value then
            for _, v in next, cursed_objects:GetChildren() do
                if (v:IsA("MeshPart") or v:IsA("Model") or v:IsA("Part")) and not (v.Name == "Chair" or v.Name == "Body") and v:FindFirstChild("Esp BillBoard") then
                    v:FindFirstChild("Esp BillBoard"):Destroy()
                end
            end
        end
    end
})

cursed_esp_group:AddToggle('cursed_object_highlight', {
    Text = 'Cursed Object Highlight',
    Default = false,
    Tooltip = 'Highlights cursed objects',

    Callback = function(Value)
        cursed_object_highlight = Value
        if not Value then
            for _, v in next, cursed_objects:GetChildren() do
                if (v:IsA("MeshPart") or v:IsA("Model") or v:IsA("Part")) and v:FindFirstChild("Highlight") then
                    v.Highlight:Destroy()
                end
            end
        end
    end
}):AddColorPicker('cursed_object_highlight_color', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'Highlight Color',

    Callback = function(Value)
        cursed_object_highlight_color = Value
        for _, v in next, cursed_objects:GetChildren() do
            if (v:IsA("MeshPart") or v:IsA("Model") or v:IsA("Part")) and v:FindFirstChild("Highlight") then
                v.Highlight.FillColor = Value
                v.Highlight.OutlineColor = Value
            end
        end
    end
})

evidence_esp_group:AddToggle('emf_name', {
    Text = 'Show Active EMFs',
    Default = false,
    Tooltip = 'Shows active EMFs done by ghost',

    Callback = function(Value)
        emf_name = Value
        if not Value then
            for i, v in next, emfs:GetChildren() do
                if v:IsA("Part") and v:FindFirstChild("Esp BillBoard") then
                    v:FindFirstChild("Esp BillBoard"):Destroy()
                end
            end
        end
    end
})

evidence_esp_group:AddToggle('orbs_name', {
    Text = 'Show Active Orbs',
    Default = false,
    Tooltip = 'Shows active orbs',

    Callback = function(Value)
        orbs_name = Value
        if not Value then
            for i, v in next, orbs:GetChildren() do
                if v:IsA("Part") and v:FindFirstChild("Esp BillBoard") then
                    v:FindFirstChild("Esp BillBoard"):Destroy()
                end
            end
        end
    end
})

closet_esp_group:AddToggle('closet_name', {
    Text = 'Closet Esp Name',
    Default = false,
    Tooltip = 'Enables names to all closets',

    Callback = function(Value)
        closet_name = Value
        if not Value then
            for i, v in next, closets:GetChildren() do
                if v:IsA("Model") and v:FindFirstChild("Esp BillBoard") then
                    v:FindFirstChild("Esp BillBoard"):Destroy()
                end
            end
        end
    end
})

closet_esp_group:AddToggle('closet_highlight', {
    Text = 'Closet Esp Highlight',
    Default = false,
    Tooltip = 'Highlights closets',

    Callback = function(Value)
        closet_highlight = Value
        if not Value then
            for i, v in next, closets:GetChildren() do
                if v:IsA("Model") and v:FindFirstChild("Highlight") then
                    v.Highlight:Destroy()
                end
            end
        end
    end
}):AddColorPicker('closet_highlight_color', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'Highlight Color',

    Callback = function(Value)
        closet_highlight_color = Value
        for i, v in next, closets:GetChildren() do
            if v:IsA("Model") and v:FindFirstChild("Highlight") then
                v.Highlight.FillColor = Value
                v.Highlight.OutlineColor = Value
            end
        end
    end
})

world_group:AddToggle('fb', {
    Text = 'Full Bright',
    Default = false,
    Tooltip = 'This so tuff features fr...',

    Callback = function(Value)
        full_bright = Value
        if Value then
            lighting.ClockTime = 12
            lighting.GlobalShadows = false
        else
            lighting.ClockTime = 0
            lighting.GlobalShadows = true
        end
    end
})

library:SetWatermarkVisibility(true)

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
    anti_touch = false
    no_hold = false
    inf_stamina = false
    speed_sprint = false
    jump_enabled = false
    full_bright = false
    show_ghost = false
    highlight_ghost = false
    ghost_name = false
    player_name = false
    player_highlight = false
    item_name = false
    item_highlight = false
    cursed_object_highlight = false
    cursed_object_name = false
    orbs_name = false
    emf_name = false
    closet_name = false
    closet_highlight = false

    for _, v in next, ghost:GetChildren() do
        if v:IsA("Model") then
            v:FindFirstChildOfClass("MeshPart").Transparency = 1
        end
    end

    for _, esp in next, workspace:GetDescendants() do
        if esp.Name == "Esp BillBoard" or esp.Name == "Highlight" then
            esp:Destroy()
        end
    end

    local_player.Character.Humanoid.JumpPower = 0
    local_player.Character.Humanoid.JumpHeight = 0
    local_player.Character.Humanoid.CameraOffset = Vector3.new(0, 0, -1)
    local_player.Character.HumanoidRootPart.CanCollide = true
    local_player.Character.UpperTorso.CanCollide = true
    local_player.Character.LowerTorso.CanCollide = true
    local_player.Character.Head.CanCollide = true
    lighting.ClockTime = 0
    lighting.GlobalShadows = true
    watermark_connection:Disconnect()
    motionconnection:Disconnect()
    sanityconnection:Disconnect()
    ghostconnection:Disconnect()
    playerconnection:Disconnect()
    library:Unload()
end)

credits_group:AddLabel('@kylosilly: Who made the script', true)

credits_group:AddButton({
    Text = 'Join our discord!',
    Func = function()
        setclipboard('https://discord.gg/SUTpER4dNc')
    end,
    DoubleClick = false,
    Tooltip = 'Join our official discord server.'
})

credits_group:AddButton({
    Text = 'Kylosilly Scriptblox',
    Func = function()
        setclipboard('https://scriptblox.com/u/CatBoy')
    end,
    DoubleClick = false,
    Tooltip = 'My scriptblox profile'
})

credits_group:AddButton({
    Text = 'Kylosilly Github',
    Func = function()
        setclipboard('https://github.com/kylosilly')
    end,
    DoubleClick = false,
    Tooltip = 'My github profile'
})

settings_group:AddToggle('keybind_visibility', {
    Text = 'Keybind Visibility',
    Default = false,
    Tooltip = 'Enables/Disables the watermark',

    Callback = function(Value)
        library.KeybindFrame.Visible = Value
    end,
})

menu_group:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
library.ToggleKeybind = Options.MenuKeybind
theme_manager:SetLibrary(library)
save_manager:SetLibrary(library)
save_manager:IgnoreThemeSettings()
save_manager:SetIgnoreIndexes({ 'MenuKeybind' })
theme_manager:SetFolder('Astolfo Ware')
save_manager:SetFolder('Astolfo Ware/Specter')
save_manager:BuildConfigSection(tabs['ui settings'])
theme_manager:ApplyToTab(tabs['ui settings'])
save_manager:LoadAutoloadConfig()
