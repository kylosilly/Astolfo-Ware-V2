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
local game_group = tabs.main:AddRightGroupbox("Game Settings")
local player_group = tabs.main:AddRightGroupbox("Player Settings")
local menu_group = tabs["ui settings"]:AddLeftGroupbox("Menu")

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

local spam_npcs = false
local inf_jump = false
local jumped = false

local spam_delay = 0

user_input_service.JumpRequest:Connect(function()
    if inf_jump and not jumped then
        jumped = true
        local_player.Character.Humanoid:ChangeState("Jumping")
        wait()
        jumped = false
    end
end)

elevator_group:AddDivider()

elevator_group:AddLabel("If you didn't get the room completed in some rooms, keep pressing it until it works.", true)

elevator_group:AddDivider()

elevator_group:AddLabel("Note: Run The Cheat Round First When The Round Actually Starts", true)

elevator_group:AddDivider()

elevator_group:AddLabel("Current Supported Floors: 28", true)

elevator_group:AddDivider()

elevator_group:AddButton({
    Text = 'Cheat Round',
    Func = function()
        if local_player:GetAttribute("inlobby") then
            library:Notify("Cant Run This In Lobby")
            return
        end

        if room.Value == nil then
            library:Notify("No Active Round Found")
            return
        end

        if not (local_player.Character or local_player.Character:FindFirstChild("HumanoidRootPart")) then
            library:Notify("LocalPlayer Not Found")
            return
        end

        if workspace:FindFirstChild("SnowySlope") then
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.SnowySlope.WinPart, 0)
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.SnowySlope.WinPart, 1)
            local_player.Character.HumanoidRootPart.CFrame = workspace.SnowySlope.WinPart.CFrame
            library:Notify("Teleported To End")
        elseif workspace:FindFirstChild("Splitsville_Wipeout") then
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.Splitsville_Wipeout.Checkpoints.EndCheckpoint, 0)
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.Splitsville_Wipeout.Checkpoints.EndCheckpoint, 1)
            local_player.Character.HumanoidRootPart.CFrame = workspace.Splitsville_Wipeout.Checkpoints.EndCheckpoint.CFrame
            library:Notify("Teleported To End")
        elseif workspace:FindFirstChild("WALL_OF") then
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.WALL_OF.Checkpoints.EndCheckpoint, 0)
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.WALL_OF.Checkpoints.EndCheckpoint, 1)
            library:Notify("Teleported To End")
        elseif workspace:FindFirstChild("TeapotDodgeball") then
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.TeapotDodgeball.Build.Finish, 0)
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.TeapotDodgeball.Build.Finish, 1)
            library:Notify("Teleported To End")
        elseif workspace:FindFirstChild("FindThePath") then
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.FindThePath.Build.End.win_zone, 0)
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.FindThePath.Build.End.win_zone, 1)
            local_player.Character.HumanoidRootPart.CFrame = workspace.FindThePath.Build.End.win_zone.CFrame
            library:Notify("Teleported To End")
        elseif workspace:FindFirstChild("StanelyRoom") then
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.StanelyRoom.Build.Generated.Ending.EndTouch, 0)
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.StanelyRoom.Build.Generated.Ending.EndTouch, 1)
            local_player.Character.HumanoidRootPart.CFrame = workspace.StanelyRoom.Build.Generated.Ending.EndTouch.CFrame
            library:Notify("Teleported To End")
        elseif workspace:FindFirstChild("FloodFillMine") then
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.FloodFillMine.Build.Shield.Bubble, 0)
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.FloodFillMine.Build.Shield.Bubble, 1)
            local_player.Character.HumanoidRootPart.CFrame = workspace.FloodFillMine.Build.Shield.Bubble.CFrame
            library:Notify("Teleported To End")
        elseif workspace:FindFirstChild("SuperDropper") then
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.SuperDropper.Build.WinPool, 0)
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.SuperDropper.Build.WinPool, 1)
            local_player.Character.HumanoidRootPart.CFrame = workspace.SuperDropper.Build.WinPool.CFrame
            library:Notify("Teleported To End")  
        elseif workspace:FindFirstChild("Dance") then
            local_player.Character.HumanoidRootPart.CFrame = workspace.Elevator.Floor.CFrame + Vector3.new(0, 5, 0)
            library:Notify("Teleported To Safe Spot!")
        elseif workspace:FindFirstChild("SLIDE_9999999999_FEET_DOWN_RAINBOW") then
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.SLIDE_9999999999_FEET_DOWN_RAINBOW.Build.Target.MiddleRing, 0)
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.SLIDE_9999999999_FEET_DOWN_RAINBOW.Build.Target.MiddleRing, 1)
            library:Notify("Touched Middle Point")
        elseif workspace:FindFirstChild("Minefield") then
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.Minefield.Build.WinPart, 0)
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.Minefield.Build.WinPart, 1)
            local_player.Character.HumanoidRootPart.CFrame = workspace.Minefield.Build.WinPart.CFrame
            library:Notify("Teleported To End")
        elseif workspace:FindFirstChild("Obby") then
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.Obby.Build.EndPlatform, 0)
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.Obby.Build.EndPlatform, 1)
            local_player.Character.HumanoidRootPart.CFrame = workspace.Obby.Build.EndPlatform.CFrame
            library:Notify("Teleported To End")
        elseif workspace:FindFirstChild("FunTimesAtSquishyFlood") then
            local_player.Character.HumanoidRootPart.CFrame = workspace.FunTimesAtSquishyFlood.Build.Winparts:GetChildren()[4].CFrame
            library:Notify("Teleported To End")
        elseif workspace:FindFirstChild("Superhighway") then
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.Superhighway.WinPoint, 0)
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.Superhighway.WinPoint, 1)
            local_player.Character.HumanoidRootPart.CFrame = workspace.Superhighway.WinPoint.CFrame
            library:Notify("Teleported To End")
        elseif workspace:FindFirstChild("SuspiciouslyLongRoom") then
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.SuspiciouslyLongRoom.Build.WinPool, 0)
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.SuspiciouslyLongRoom.Build.WinPool, 1)
            local_player.Character.HumanoidRootPart.CFrame = workspace.SuspiciouslyLongRoom.Build.WinPool.CFrame
            library:Notify("Teleported To End")
        elseif workspace:FindFirstChild("HotelFloor6") then
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.HotelFloor6.Build.WinPart, 0)
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.HotelFloor6.Build.WinPart, 1)
            local_player.Character.HumanoidRootPart.CFrame = workspace.HotelFloor6.Build.WinPart.CFrame
            library:Notify("Teleported To End")
        elseif workspace:FindFirstChild("HALL_OF") then
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.HALL_OF.Build.YOU_WIN, 0)
            firetouchinterest(local_player.Character.HumanoidRootPart, workspace.HALL_OF.Build.YOU_WIN, 1)
            local_player.Character.HumanoidRootPart.CFrame = workspace.HALL_OF.Build.YOU_WIN.CFrame
            library:Notify("Teleported To End")
        elseif workspace:FindFirstChild("Jeremy") then
            local_player.Character.HumanoidRootPart.CFrame = workspace.Jeremy.Build.JeremyVictory.CFrame
            library:Notify("Teleported To Button")
        elseif workspace:FindFirstChild("ColorTheTiles") then
            for _, v in next, workspace.ColorTheTiles.Tiles:GetDescendants() do
                if v:IsA("TouchTransmitter") then
                    firetouchinterest(local_player.Character.HumanoidRootPart, v.Parent, 0)
                    firetouchinterest(local_player.Character.HumanoidRootPart, v.Parent, 1)
                end
            end
            library:Notify("Gooned All Over Tiles")
        elseif workspace:FindFirstChild("FunnyMaze") then
            for _, v in next, workspace.FunnyMaze.Build.FinalNotes:GetDescendants() do
                if v:IsA("ClickDetector") then
                    fireclickdetector(v)
                end
            end
            library:Notify("Collected All Notes")
        elseif workspace:FindFirstChild("SurvivalTheArea51") then
            for _, v in next, workspace.SurvivalTheArea51.Build:GetDescendants() do
                if v:IsA("ProximityPrompt") then
                    fireproximityprompt(v)
                end
            end
            library:Notify("Activated All Generators")
        elseif workspace:FindFirstChild("UES") then
            for _, v in next, workspace.UES.Build:GetDescendants() do
                if v:IsA("ClickDetector") and not v.Parent:GetAttribute("InUse") then
                    fireclickdetector(v)
                end
            end
            library:Notify("Clicked All Boxes")
        elseif workspace:FindFirstChild("MozellesCastle") then
            workspace:WaitForChild("MozellesCastle"):WaitForChild("AddScore"):FireServer(9e9)
            library:Notify("Gave 9 Billion Points!")
        elseif workspace:FindFirstChild("3008_Room") then
            fireclickdetector(workspace["3008_Room"].Build.Lampert.ClickDetector)
            library:Notify("Found Silly Lampert")
        elseif workspace:FindFirstChild("RandomMazeWindows") then
            fireclickdetector(workspace.RandomMazeWindows.Build:GetChildren()[6])
            library:Notify("Found Silly Lampert")
        elseif workspace:FindFirstChild("ButtonCompetition") then
            for _, v in next, workspace.ButtonCompetition.Build.Buttons:GetDescendants() do
                if v:IsA("ClickDetector") and v.Parent.Parent:GetAttribute("Active") then
                    fireclickdetector(v)
                end
            end
            library:Notify("Clicked All Buttons")
        else
            library:Notify("Current Round Not Supported")
        end
    end,
    DoubleClick = false,
    Tooltip = 'Cheat current round'
})

elevator_group:AddDivider()

elevator_group:AddButton({
    Text = 'Join Game',
    Func = function()
        if local_player:GetAttribute("inlobby") then
            replicated_storage:WaitForChild("RE"):WaitForChild("PutInElevator"):FireServer()
        else
            library:Notify("Youre already in game retard")
        end
    end,
    DoubleClick = false,
    Tooltip = 'Insta joins the game'
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

game_group:AddDivider()


game_group:AddToggle('spam_npcs', {
    Text = 'Spam Npcs',
    Default = spam_npcs,
    Tooltip = 'Spams the npcs to keep talking',

    Callback = function(Value)
        spam_npcs = Value
        if Value then
            replicated_storage:WaitForChild("RE"):WaitForChild("Items"):WaitForChild("UpdateIndexing"):FireServer({ ["Kitty"] = 2 })
            repeat
                if #workspace.Elevator.Npc.Npcs:GetChildren() > 0 then
                    for _, v in next, workspace.Elevator.Npc.Npcs:GetChildren() do
                        if v:IsA("Model") and v:GetAttribute("ID") then
                            replicated_storage:WaitForChild("RE"):WaitForChild("NPC"):WaitForChild("GiveItem"):FireServer(v:GetAttribute("ID"), "Kitty")
                            task.wait(spam_delay)
                        end
                    end
                end
                task.wait()
            until not spam_npcs
        end
    end
})

game_group:AddSlider('spam_delay', {
    Text = 'Npc Spam Delay',
    Default = spam_delay,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        spam_delay = Value
    end
})

game_group:AddDivider()

game_group:AddButton({
    Text = 'Explode All Mines',
    Func = function()
        if workspace:FindFirstChild("Minefield") then
            for _, v in next, workspace.Minefield.Build.MinesFolder.Mines:GetDescendants() do
                if v:IsA("TouchTransmitter") then
                    firetouchinterest(local_player.Character.HumanoidRootPart, v.Parent, 0)
                    firetouchinterest(local_player.Character.HumanoidRootPart, v.Parent, 1)
                end
            end
            library:Notify("5 Big Booms Boom Boom Boom")
        else
            library:Notify("Current Room Is Not Minefield!")
        end
    end,
    DoubleClick = false,
    Tooltip = 'Explode All Mines In Minefield Room'
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
    spam_npcs = false
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
