local notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()

local virtual_input_manager = game:GetService("VirtualInputManager");
local replicated_storage = game:GetService("ReplicatedStorage");
local local_player = game:GetService("Players").LocalPlayer;
local workspace = game:GetService("Workspace");

local_player.Idled:Connect(function()
    virtual_input_manager:CaptureController();
    virtual_input_manager:ClickButton2(Vector2.new());
end);

local atms = workspace:FindFirstChild("Map"):FindFirstChild("ATMS");

if not atms then
    local_player:Kick("No atms found!");
end

if not workspace:FindFirstChild("Part") then
    local safe_spot = Instance.new("Part", workspace);
    safe_spot.Position = Vector3.new(0, 5000, 0);
    safe_spot.Size = Vector3.new(100, 5, 100);
    safe_spot.Anchored = true;
    safe_spot.Name = "Part";
end

function closest_atm()
    local atm = nil;
    local dist = 9e999;

    for _, v in next, atms:GetChildren() do
        if local_player.Character and v:GetAttribute("State") == "Open" then
            local distance = (v:GetPivot().Position - local_player.Character:GetPivot().Position).Magnitude;
            if distance < dist then
                dist = distance;
                atm = v;
            end
        end
    end

    return atm;
end

if farm_atms then
    repeat
        local atm = closest_atm();
        if atm then
            notification:Notify("Robbing "..atm.Name);
            local hack_remote = atm:FindFirstChildOfClass("RemoteFunction");
            local collect_remote = atm:FindFirstChildOfClass("RemoteEvent");
            local cash_register = atm:FindFirstChild("CashRegister");
            local_player.Character:MoveTo(atm:GetPivot().Position);
            task.wait(1);
            hack_remote:InvokeServer();
            task.wait(2);
            for _, v in next, cash_register:GetChildren() do
                if v:IsA("Part") then
                    collect_remote:FireServer(v);
                end
            end
            notification:Notify("Collected Cash");
            task.wait(1);
        else
            local_player.Character:MoveTo(workspace.Part.Position + Vector3.new(0, 5, 0));
        end
        if workspace:FindFirstChild("Airdrop") and workspace:FindFirstChild("Airdrop"):GetAttribute("Grounded") then
            notification:Notify("Collecting Airdrop");
            local_player.Character:MoveTo(workspace.Airdrop:GetPivot().Position + Vector3.new(0, 5, 0));
            task.wait(1);
            replicated_storage:WaitForChild("KnitFolder"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("AirdropService"):WaitForChild("RF"):WaitForChild("Collect"):InvokeServer(workspace:WaitForChild("Airdrop"));
            notification:Notify("Collected Airdrop");
            workspace:WaitForChild("Airdrop"):Destroy();
        end
        task.wait();
    until not farm_atms;
end
