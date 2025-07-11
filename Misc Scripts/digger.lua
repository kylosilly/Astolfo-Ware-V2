-- offsets might not always be correct
local attribute_to_value_offset = 0x30
local frame_position_x_offset = 0x3B8

local local_player = globals.localplayer()
local workspace = globals.workspace()

local root_part = local_player:ModelInstance():FindChild("HumanoidRootPart")
local player_gui = local_player:FindChild("PlayerGui")
local backpack = local_player:FindChild("Backpack")

local active = workspace:FindChild("Active")
if not active then
    return print("Active Folder Not Found!")
end

local pizza_customer = active:FindChild("PizzaCustomers")
if not pizza_customer then
    return print("Pizza Customers Folder Not Found!")
end

local world = workspace:FindChild("World")
if not world then
    return print("World Folder Not Found!")
end

local npcs = world:FindChild("NPCs")
if not npcs then
    return print("NPCs Not Found!")
end

local interactive = world:FindChild("Interactive")
if not interactive then
    return print("Interactive Folder Not Found!")
end

local purchaseable = interactive:FindChild("Purchaseable")
if not purchaseable then
    return print("Purchaseable Folder Not Found!")
end

local enchanting = interactive:FindChild("Enchanting")
if not enchanting then
    return print("Enchanting Folder Not Found!")
end

local last_click_time = 0

ui.label("Any crashes by tp are caused by assembly")
ui.label("Tp probably detected use at own risk :3")
ui.label("")
ui.label("Dig Settings")
local dig_minigame = ui.new_checkbox("Auto Dig Minigame")
local dig_minigame_method = ui.new_combo("Select Dig Minigame Option", "Legit,Blatant")
ui.label("")
ui.label("Pizza Delivery Settings")
local pizza_penguin_teleport = ui.button("Teleport To Pizza Penguin")
local customer_teleport = ui.button("Teleport To Customer")
ui.label("")
ui.label("Misc Teleport Settings")
local enchantment_table_teleport = ui.button("Teleport To Enchantment Table")
local merchant_teleport = ui.button("Teleport To Merchant")
local meteor_teleport = ui.button("Teleport To Meteor")

cheat.set_callback("paint", function()
    if dig_minigame:get() then
        if player_gui:FindChild("Dig") then
            local current_time = globals.curtime()
            local strong_hit = player_gui:FindChild("Dig"):FindChild("Safezone"):FindChild("Holder"):FindChild("Area_Strong")
            local player_bar = player_gui:FindChild("Dig"):FindChild("Safezone"):FindChild("Holder"):FindChild("PlayerBar")
            if globals.is_focused() then
                local clicked_time = globals.curtime()
                if dig_minigame_method:get() == 1 then
                    utils.write_memory("float", player_bar:Address() + frame_position_x_offset, utils.read_memory("float", strong_hit:Address() + frame_position_x_offset))
                    if clicked_time - last_click_time >= 0.2 then
                        input.click()
                        last_click_time = clicked_time
                    end
                elseif dig_minigame_method:get() == 0 then
                    local distance = utils.read_memory("float", player_bar:Address() + frame_position_x_offset) - utils.read_memory("float", strong_hit:Address() + frame_position_x_offset)
                    if distance < 0.02 and clicked_time - last_click_time >= 0.8 then
                        input.click()
                        last_click_time = clicked_time
                    end
                end
            end
        end
    end

    if pizza_penguin_teleport:get() then
        root_part:Primitive():SetPartPosition(npcs:FindChild("Pizza Penguin"):FindChild("HumanoidRootPart"):Primitive():GetPartPosition())
    end

    if customer_teleport:get() then
        root_part:Primitive():SetPartPosition(pizza_customer:FindChildByClass("Model"):FindChild("HumanoidRootPart"):Primitive():GetPartPosition())
    end

    if meteor_teleport:get() then
        if active:FindChild("Meteor") then
            root_part:Primitive():SetPartPosition(active:FindChild("Meteor"):Primitive():GetPartPosition())
        else
            print("Meteor Not Found!")
        end
    end

    if merchant_teleport:get() then
        if npcs:FindChild("Merchant Cart") then
            root_part:Primitive():SetPartPosition(npcs:FindChild("Merchant Cart"):FindChild("DO NOT DELETE!!!"):Primitive():GetPartPosition())
        end
    end

    if enchantment_table_teleport:get() then
        root_part:Primitive():SetPartPosition(enchanting:FindChild("EnchantmentAltar"):FindChild("EnchantPart"):Primitive():GetPartPosition())
    end
end)

print("Loaded script made by @kylosilly on discord")
