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
    Title = "Astolfo Ware | Made By @kylosilly | discord.gg/SUTpER4dNc",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local tabs = {
    main = window:AddTab("Main"),
    ["ui settings"] = window:AddTab("UI Settings")
}

local elevator_group = tabs.main:AddLeftGroupbox("Elevator Settings")
local player_group = tabs.main:AddRightGroupbox("Player Settings")
local menu_group = tabs["ui settings"]:AddLeftGroupbox("Menu")

-- Thx dementia enjoyer for this
get_service = setmetatable({}, {
    __index = function(self, index)
        return cloneref(game.GetService(game, index))
    end
})

local proximity_prompt_service = get_service.ProximityPromptService
local replicated_storage = get_service.ReplicatedStorage
local user_input_service = get_service.UserInputService
local market = get_service.MarketplaceService
local run_service = get_service.RunService
local workspace = get_service.Workspace
local players = get_service.Players
local stats = get_service.Stats

local info = market:GetProductInfo(game.PlaceId)
local local_player = players.LocalPlayer

local values = workspace:FindFirstChild("Values")
local room = values:FindFirstChild("CurrentRoom")

local inf_jump = false
local jumped = false

user_input_service.JumpRequest:Connect(function()
    if inf_jump and not jumped then
        jumped = true
        local_player.Character.Humanoid:ChangeState("Jumping")
        wait()
        jumped = false
    end
end)

elevator_group:AddDivider()

elevator_group:AddLabel("This is currently in testing and has been made as simple as possible. I will rewrite it as soon as possible!", true)
elevator_group:AddLabel("Current Supported Floors: 12", true)

elevator_group:AddDivider()

elevator_group:AddButton({
    Text = 'Cheat Round',
    Func = function()
        if local_player:GetAttribute("inlobby") then
            library:Notify("Cant Run This While In Lobby!")
            return
        end

        if room.Value == nil then
            library:Notify("No Active Round Found!")
            return
        end

        if not (local_player.Character or local_player.Character:FindFirstChild("HumanoidRootPart")) then
            library:Notify("LocalPlayer Not Found!")
            return
        end

        if workspace:FindFirstChild("SnowySlope") then
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.SnowySlope.WinPart, 0)
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.SnowySlope.WinPart, 1)
            local_player.Character.HumanoidRootPart.CFrame = workspace.SnowySlope.WinPart.CFrame
            library:Notify("Teleported To End!")
        elseif workspace:FindFirstChild("Splitsville_Wipeout") then
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.Splitsville_Wipeout.WinPart, 0)
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.Splitsville_Wipeout.WinPart, 1)
            local_player.Character.HumanoidRootPart.CFrame = workspace.Splitsville_Wipeout.WinPart.CFrame
            library:Notify("Teleported To End!")
        elseif workspace:FindFirstChild("ColorTheTiles") then
            for _, v in next, workspace.ColorTheTiles.Tiles:GetDescendants() do
                if v:IsA("TouchTransmitter") then
                    firetouchinterest(local_player.Character.HumanoidRootPart, v.Parent, 0)
                    firetouchinterest(local_player.Character.HumanoidRootPart, v.Parent, 1)
                end
            end
            library:Notify("Done Coloring Tiles!")
        elseif workspace:FindFirstChild("WALL_OF") then
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.WALL_OF.Checkpoints.EndCheckpoint, 0)
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.WALL_OF.Checkpoints.EndCheckpoint, 1)
            library:Notify("Teleported To End!")
        elseif workspace:FindFirstChild("Minefield") then
            for _, v in next, workspace.Minefield.Build.MinesFolder.Mines:GetDescendants() do
                if v:IsA("TouchTransmitter") then
                    firetouchinterest(local_player.Character.HumanoidRootPart, v.Parent, 0)
                    firetouchinterest(local_player.Character.HumanoidRootPart, v.Parent, 1)
                end
            end
            library:Notify("Exploded All Mines!")
        elseif workspace:FindFirstChild("TeapotDodgeball") then
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.TeapotDodgeball.Build.Finish, 0)
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.TeapotDodgeball.Build.Finish, 1)
            library:Notify("Teleported To Finish!")
        elseif workspace:FindFirstChild("FunnyMaze") then
            for _, v in next, workspace.FunnyMaze.Build.FinalNotes:GetDescendants() do
                if v:IsA("ClickDetector") then
                    fireclickdetector(v)
                end
            end
            library:Notify("Collected All Notes!")
        elseif workspace:FindFirstChild("SurvivalTheArea51") then
            for _, v in next, workspace.SurvivalTheArea51.Build:GetDescendants() do
                if v:IsA("ProximityPrompt") then
                    fireproximityprompt(v)
                end
            end
            library:Notify("Activated All Generators!")
        elseif workspace:FindFirstChild("FloodFillMine") then
            local billboard = Instance.new("BillboardGui", workspace.FloodFillMine.Build.Shield.Bubble)
            local text = Instance.new("TextLabel", billboard)
            billboard.Size = UDim2.new(0, 100, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 1, 0)
            billboard.AlwaysOnTop = true

            text.Size = UDim2.new(1, 0, 1, 0)
            text.Text = "Protective Shield"
            text.TextColor3 = Color3.fromRGB(255, 255, 255)
            text.TextSize = 14
            text.Font = "SourceSansBold"
            text.BackgroundTransparency = 1
            text.TextStrokeTransparency = 0
            text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        elseif workspace:FindFirstChild("THEROCK") then
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.THEROCK.WinPart, 0)
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.THEROCK.WinPart, 1)
            local_player.Character.HumanoidRootPart.CFrame = workspace.THEROCK.WinPart.CFrame
            library:Notify("Teleported To End!")
        elseif workspace:FindFirstChild("UES") then
            for _, v in next, workspace.UES.Build:GetDescendants() do
                if v:IsA("ClickDetector") and not v.Parent:GetAttribute("InUse") then
                    fireclickdetector(v)
                end
            end
            library:Notify("Clicked All Boxes!")
        elseif workspace:FindFirstChild("FindThePath") then
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.FindThePath.Build.End.win_zone, 0)
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.FindThePath.Build.End.win_zone, 1)
            local_player.Character.HumanoidRootPart.CFrame = workspace.FindThePath.Build.End.win_zone.CFrame
            library:Notify("Teleported To End!")
        elseif workspace:FindFirstChild("StanelyRoom") then
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.StanelyRoom.Build.Generated.Ending.EndTouch, 0)
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.StanelyRoom.Build.Generated.Ending.EndTouch, 1)
            local_player.Character.HumanoidRootPart.CFrame = workspace.StanelyRoom.Build.Generated.Ending.EndTouch.CFrame
            library:Notify("Teleported To End!")
        else
            library:Notify("Round Not Supported!")
        end
    end,
    DoubleClick = false,
    Tooltip = 'Cheats current round in elevator'
})

elevator_group:AddButton({
    Text = 'Join Game',
    Func = function()
        if local_player:GetAttribute("inlobby") then
            replicated_storage:WaitForChild("RE"):WaitForChild("PutInElevator"):FireServer()
        else
            library:Notify("Not In Lobby!")
        end
    end,
    DoubleClick = false,
    Tooltip = 'This is the main button'
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

player_group:AddDivider()

player_group:AddButton({
    Text = 'Reset Character',
    Func = function()
        replicated_storage:WaitForChild("RE"):WaitForChild("Respawn"):FireServer()
        library:Notify("Character Reset!")
    end,
    DoubleClick = false,
    Tooltip = 'Resets your character'
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
    inf_jump = false
    library:Unload()
end)

menu_group:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
library.ToggleKeybind = Options.MenuKeybind
theme_manager:SetLibrary(library)
save_manager:SetLibrary(library)
save_manager:IgnoreThemeSettings()
save_manager:SetIgnoreIndexes({ 'MenuKeybind' })
theme_manager:SetFolder('Astolfo Ware')
save_manager:SetFolder('Astolfo Ware/Regretavator')
save_manager:BuildConfigSection(tabs['ui settings'])
theme_manager:ApplyToTab(tabs['ui settings'])
save_manager:LoadAutoloadConfig()
