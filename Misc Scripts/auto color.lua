local local_player = game:GetService("Players").LocalPlayer
local workspace = game:GetService("Workspace")
local base = nil

for _, v in next, workspace:WaitForChild("Bases"):GetDescendants() do
    if v.Name == "OwnerText" and v.Text == local_player.Name then
        base = v.Parent.Parent.Parent.Parent -- so many parents!!!!!!!!!!!!!!!
    end
end

if not base then
    print("Player base not found!")
    return
end

if auto_paint then
    repeat
        for _, v in next, base:WaitForChild("Blocks"):GetChildren() do
            if v:GetAttribute("colorId") == local_player:GetAttribute("CurrentColor") and v:FindFirstChildOfClass("Texture").Transparency == 0 then
                local_player.Character:MoveTo(v.Position)
                task.wait(.05)
            end
        end
        task.wait()
    until not auto_paint
end
