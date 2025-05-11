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
    ['ui settings'] = window:AddTab('UI Settings')
}

local skin_changer_group = tabs.main:AddLeftGroupbox('Skin Changer Settings')
local tutorial_group = tabs.main:AddRightGroupbox('Tutorial')
local menu_group = tabs['ui settings']:AddLeftGroupbox('Menu')
local credits_group = tabs['ui settings']:AddRightGroupbox('Credits')

local replicated_storage = game:GetService("ReplicatedStorage")
local market = game:GetService("MarketplaceService")
local run_service = game:GetService("RunService")
local info = market:GetProductInfo(game.PlaceId)
local stats = game:GetService("Stats")

local book_skins = {}
local camera_skins = {}
local candle_skins = {}
local crucifix_skins = {}
local emf_skins = {}
local flashlight_skins = {}
local goggles_skins = {}
local lighter_skins = {}
local sensor_skins = {}
local soda_skins = {}
local spirit_box_skins = {}
local thermometer_skins = {}

local book_skin = ""
local camera_skin = ""
local candle_skin = ""
local crucifix_skin = ""
local emf_skin = ""
local flashlight_skin = ""
local goggles_skin = ""
local lighter_skin = ""
local sensor_skin = ""
local soda_skin = ""
local spirit_box_skin = ""
local thermometer_skin = ""

for _, book in pairs(replicated_storage.Assets.Equipment.Book:GetChildren()) do
    if book:IsA("Model") then
        table.insert(book_skins, book.Name)
    end
end

for _, camera in pairs(replicated_storage.Assets.Equipment.Camera:GetChildren()) do
    if camera:IsA("Model") then
        table.insert(camera_skins, camera.Name)
    end
end

for _, candle in pairs(replicated_storage.Assets.Equipment.Candle:GetChildren()) do
    if candle:IsA("Model") then
        table.insert(candle_skins, candle.Name)
    end
end

for _, crucifix in pairs(replicated_storage.Assets.Equipment.Crucifix:GetChildren()) do
    if crucifix:IsA("Model") then
        table.insert(crucifix_skins, crucifix.Name)
    end
end

for _, emf in pairs(replicated_storage.Assets.Equipment["EMF Reader"]:GetChildren()) do
    if emf:IsA("Model") then
        table.insert(emf_skins, emf.Name)
    end
end

for _, flashlight in pairs(replicated_storage.Assets.Equipment.Flashlight:GetChildren()) do
    if flashlight:IsA("Model") then
        table.insert(flashlight_skins, flashlight.Name)
    end
end

for _, goggles in pairs(replicated_storage.Assets.Equipment["Ghost Goggles"]:GetChildren()) do
    if goggles:IsA("Model") then
        table.insert(goggles_skins, goggles.Name)
    end
end

for _, lighter in pairs(replicated_storage.Assets.Equipment.Lighter:GetChildren()) do
    if lighter:IsA("Model") then
        table.insert(lighter_skins, lighter.Name)
    end
end

for _, sensor in pairs(replicated_storage.Assets.Equipment["Motion Sensor"]:GetChildren()) do
    if sensor:IsA("Model") then
        table.insert(sensor_skins, sensor.Name)
    end
end

for _, soda in pairs(replicated_storage.Assets.Equipment["Sanity Soda"]:GetChildren()) do
    if soda:IsA("Model") then
        table.insert(soda_skins, soda.Name)
    end
end

for _, spirit_box in pairs(replicated_storage.Assets.Equipment["Spirit Box"]:GetChildren()) do
    if spirit_box:IsA("Model") then
        table.insert(spirit_box_skins, spirit_box.Name)
    end
end

for _, theremometer in pairs(replicated_storage.Assets.Equipment.Thermometer:GetChildren()) do
    if theremometer:IsA("Model") then
        table.insert(thermometer_skins, theremometer.Name)
    end
end

tutorial_group:AddLabel("How It Works: You select a skin from the dropdown and equip it by clicking the button everyone can see it so have fun trolling lol", true)

skin_changer_group:AddDropdown('book_skins', {
    Values = book_skins,
    Default = "",
    Multi = false,
    Text = 'Select Book Skin',
    Tooltip = 'Select a book skin to equip.',
    Callback = function(Value)
        book_skin = Value
    end
})

skin_changer_group:AddButton({
    Text = 'Equip Book Skin',
    Func = function()
        if book_skin then
            replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("Preview"):InvokeServer("Book", book_skin)
            library:Notify("Equipped Book Skin: " .. book_skin)
        end
    end,
    DoubleClick = false,
    Tooltip = 'Equips the selected book skin'
})

skin_changer_group:AddDivider()

skin_changer_group:AddDropdown('camera_skins', {
    Values = camera_skins,
    Default = "",
    Multi = false,
    Text = 'Select Camera Skin',
    Tooltip = 'Select a camera skin to equip.',
    Callback = function(Value)
        camera_skin = Value
    end
})

skin_changer_group:AddButton({
    Text = 'Equip Camera Skin',
    Func = function()
        if camera_skin then
            replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("Preview"):InvokeServer("Camera", camera_skin)
            library:Notify("Equipped Camera Skin: " .. camera_skin)
        end
    end,
    DoubleClick = false,
    Tooltip = 'Equips the selected camera skin'
})

skin_changer_group:AddDivider()

skin_changer_group:AddDropdown('candle_skins', {
    Values = candle_skins,
    Default = "",
    Multi = false,
    Text = 'Select Candle Skin',
    Tooltip = 'Select a candle skin to equip.',
    Callback = function(Value)
        candle_skin = Value
    end
})

skin_changer_group:AddButton({
    Text = 'Equip Candle Skin',
    Func = function()
        if candle_skin then
            replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("Preview"):InvokeServer("Candle", candle_skin)
            library:Notify("Equipped Candle Skin: " .. candle_skin)
        end
    end,
    DoubleClick = false,
    Tooltip = 'Equips the selected candle skin'
})

skin_changer_group:AddDivider()

skin_changer_group:AddDropdown('crucifix_skins', {
    Values = crucifix_skins,
    Default = "",
    Multi = false,
    Text = 'Select Crucifix Skin',
    Tooltip = 'Select a crucifix skin to equip.',
    Callback = function(Value)
        crucifix_skin = Value
    end
})

skin_changer_group:AddButton({
    Text = 'Equip Crucifix Skin',
    Func = function()
        if crucifix_skin then
            replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("Preview"):InvokeServer("Crucifix", crucifix_skin)
            library:Notify("Equipped Crucifix Skin: " .. crucifix_skin)
        end
    end,
    DoubleClick = false,
    Tooltip = 'Equips the selected crucifix skin'
})

skin_changer_group:AddDivider()

skin_changer_group:AddDropdown('emf_skins', {
    Values = emf_skins,
    Default = "",
    Multi = false,
    Text = 'Select EMF Skin',
    Tooltip = 'Select an EMF skin to equip.',
    Callback = function(Value)
        emf_skin = Value
    end
})

skin_changer_group:AddButton({
    Text = 'Equip EMF Skin',
    Func = function()
        if emf_skin then
            replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("Preview"):InvokeServer("EMF Reader", emf_skin)
            library:Notify("Equipped EMF Skin: " .. emf_skin)
        end
    end,
    DoubleClick = false,
    Tooltip = 'Equips the selected EMF skin'
})

skin_changer_group:AddDivider()

skin_changer_group:AddDropdown('flashlight_skins', {
    Values = flashlight_skins,
    Default = "",
    Multi = false,
    Text = 'Select Flashlight Skin',
    Tooltip = 'Select a flashlight skin to equip.',
    Callback = function(Value)
        flashlight_skin = Value
    end
})

skin_changer_group:AddButton({
    Text = 'Equip Flashlight Skin',
    Func = function()
        if flashlight_skin then
            replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("Preview"):InvokeServer("Flashlight", flashlight_skin)
            library:Notify("Equipped Flashlight Skin: " .. flashlight_skin)
        end
    end,
    DoubleClick = false,
    Tooltip = 'Equips the selected flashlight skin'
})

skin_changer_group:AddDivider()

skin_changer_group:AddDropdown('goggles_skins', {
    Values = goggles_skins,
    Default = "",
    Multi = false,
    Text = 'Select a Ghost Goggles Skin',
    Tooltip = 'Select a Ghost Goggles skin to equip.',
    Callback = function(Value)
        goggles_skin = Value
    end
})

skin_changer_group:AddButton({
    Text = 'Equip Ghost Goggles Skin',
    Func = function()
        if goggles_skin then
            replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("Preview"):InvokeServer("Ghost Goggles", goggles_skin)
            library:Notify("Equipped Ghost Goggles Skin: " .. goggles_skin)
        end
    end,
    DoubleClick = false,
    Tooltip = 'Equips the selected Ghost Goggles skin'
})

skin_changer_group:AddDivider()

skin_changer_group:AddDropdown('lighter_skins', {
    Values = lighter_skins,
    Default = "",
    Multi = false,
    Text = 'Select a Lighter Skin',
    Tooltip = 'Select a Lighter skin to equip.',
    Callback = function(Value)
        lighter_skin = Value
    end
})

skin_changer_group:AddButton({
    Text = 'Equip Lighter Skin',
    Func = function()
        if lighter_skin then
            replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("Preview"):InvokeServer("Lighter", lighter_skin)
            library:Notify("Equipped Lighter Skin: " .. lighter_skin)
        end
    end,
    DoubleClick = false,
    Tooltip = 'Equips the selected Lighter skin'
})

skin_changer_group:AddDivider()

skin_changer_group:AddDropdown('sensor_skins', {
    Values = sensor_skins,
    Default = "",
    Multi = false,
    Text = 'Select a Sensor Skin',
    Tooltip = 'Select a Sensor skin to equip.',
    Callback = function(Value)
        sensor_skin = Value
    end
})

skin_changer_group:AddButton({
    Text = 'Equip Sensor Skin',
    Func = function()
        if sensor_skin then
            replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("Preview"):InvokeServer("Motion Sensor", sensor_skin)
            library:Notify("Equipped Sensor Skin: " .. sensor_skin)
        end
    end,
    DoubleClick = false,
    Tooltip = 'Equips the selected Sensor skin'
})

skin_changer_group:AddDivider()

skin_changer_group:AddDropdown('soda_skins', {
    Values = soda_skins,
    Default = "",
    Multi = false,
    Text = 'Select a Sanity Soda Skin',
    Tooltip = 'Select a Sanity Soda skin to equip.',
    Callback = function(Value)
        soda_skin = Value
    end
})

skin_changer_group:AddButton({
    Text = 'Equip Sanity Soda Skin',
    Func = function()
        if soda_skin then
            replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("Preview"):InvokeServer("Sanity Soda", soda_skin)
            library:Notify("Equipped Sanity Soda Skin: " .. soda_skin)
        end
    end,
    DoubleClick = false,
    Tooltip = 'Equips the selected Sanity Soda skin'
})

skin_changer_group:AddDivider()

skin_changer_group:AddDropdown('spirit_box_skins', {
    Values = spirit_box_skins,
    Default = "",
    Multi = false,
    Text = 'Select a Spirit Box Skin',
    Tooltip = 'Select a Spirit Box skin to equip.',
    Callback = function(Value)
        spirit_box_skin = Value
    end
})

skin_changer_group:AddButton({
    Text = 'Equip Spirit Box Skin',
    Func = function()
        if spirit_box_skin then
            replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("Preview"):InvokeServer("Spirit Box", spirit_box_skin)
            library:Notify("Equipped Spirit Box Skin: " .. spirit_box_skin)
        end
    end,
    DoubleClick = false,
    Tooltip = 'Equips the selected Spirit Box skin'
})

skin_changer_group:AddDivider()

skin_changer_group:AddDropdown('thermometer_skins', {
    Values = thermometer_skins,
    Default = "",
    Multi = false,
    Text = 'Select a Thermometer Skin',
    Tooltip = 'Select a Thermometer skin to equip.',
    Callback = function(Value)
        thermometer_skin = Value
    end
})

skin_changer_group:AddButton({
    Text = 'Equip Thermometer Skin',
    Func = function()
        if thermometer_skin then
            replicated_storage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RF"):WaitForChild("Preview"):InvokeServer("Thermometer", thermometer_skin)
            library:Notify("Equipped Thermometer Skin: " .. thermometer_skin)
        end
    end,
    DoubleClick = false,
    Tooltip = 'Equips the selected Thermometer skin'
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
    watermark_connection:Disconnect()
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

menu_group:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
library.ToggleKeybind = Options.MenuKeybind
theme_manager:SetLibrary(library)
save_manager:SetLibrary(library)
save_manager:IgnoreThemeSettings()
save_manager:SetIgnoreIndexes({ 'MenuKeybind' })
theme_manager:SetFolder('Astolfo Ware')
save_manager:SetFolder('Astolfo Ware/Specter Trading')
save_manager:BuildConfigSection(tabs['ui settings'])
theme_manager:ApplyToTab(tabs['ui settings'])
save_manager:LoadAutoloadConfig()
