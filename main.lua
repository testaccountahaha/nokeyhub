-- Function to safely load a remote script
local function safeLoadstring(url)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if not success then
        warn("Failed to fetch script from " .. url .. ": " .. result)
        return nil
    end
    local func, err = loadstring(result)
    if not func then
        warn("Failed to loadstring script from " .. url .. ": " .. err)
        return nil
    end
    return func
end

-- Load dependencies with error handling
local Fluent
local SaveManager
local InterfaceManager

local fluentFunc = safeLoadstring("https://raw.githubusercontent.com/0vma/Strelizia/refs/heads/main/Fluent.luau")
if fluentFunc then
    Fluent = fluentFunc()
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Error",
        Text = "Failed to load Fluent UI library. Check your network or the URL.",
        Duration = 10
    })
    return
end

local saveManagerFunc = safeLoadstring("https://raw.githubusercontent.com/0vma/Strelizia/refs/heads/main/Dependencies/UILibrary/Fluent/SaveManager.lua")
if saveManagerFunc then
    SaveManager = saveManagerFunc()
else
    Fluent:Notify({
        Title = "Error",
        Content = "Failed to load SaveManager. Some features may not work.",
        Duration = 10
    })
end

local themeManagerFunc = safeLoadstring("https://raw.githubusercontent.com/0vma/Strelizia/refs/heads/main/Dependencies/UILibrary/Fluent/ThemeManager.lua")
if themeManagerFunc then
    InterfaceManager = themeManagerFunc()
else
    Fluent:Notify({
        Title = "Error",
        Content = "Failed to load ThemeManager. Some features may not work.",
        Duration = 10
    })
end

-- Simplified Trove module for cleanup
local Trove = {}
Trove.__index = Trove
function Trove.new()
    return setmetatable({ _objects = {} }, Trove)
end
function Trove:Add(object)
    table.insert(self._objects, object)
    return object
end
function Trove:Clean()
    for _, object in ipairs(self._objects) do
        if typeof(object) == "RBXScriptConnection" then
            object:Disconnect()
        elseif typeof(object) == "Instance" then
            object:Destroy()
        end
    end
    self._objects = {}
end

-- Simplified Signal module
local Signal = {}
Signal.__index = Signal
function Signal.new()
    return setmetatable({ _handlers = {} }, Signal)
end
function Signal:Connect(handler)
    table.insert(self._handlers, handler)
    return { Disconnect = function() table.remove(self._handlers, table.find(self._handlers, handler)) end }
end
function Signal:Fire(...)
    for _, handler in ipairs(self._handlers) do
        handler(...)
    end
end

-- Game-specific functions
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local function autoBubble()
    local trove = Trove.new()
    local signal = Signal.new()
    local isRunning = false

    local function blowBubble()
        if isRunning then
            ReplicatedStorage:WaitForChild("Events"):WaitForChild("BlowBubble"):FireServer()
        end
    end

    trove:Add(signal:Connect(blowBubble))
    trove:Add(game:GetService("RunService").Heartbeat:Connect(function()
        if isRunning then
            signal:Fire()
        end
    end))

    return {
        Start = function() isRunning = true end,
        Stop = function() isRunning = false end,
        Destroy = function() trove:Clean() end
    }
end

local function autoHatch(eggType)
    local trove = Trove.new()
    local isRunning = false

    local function hatchEgg()
        if isRunning then
            ReplicatedStorage:WaitForChild("Events"):WaitForChild("HatchEgg"):FireServer(eggType)
        end
    end

    trove:Add(game:GetService("RunService").Heartbeat:Connect(function()
        if isRunning then
            hatchEgg()
        end
    end))

    return {
        Start = function() isRunning = true end,
        Stop = function() isRunning = false end,
        Destroy = function() trove:Clean() end
    }
end

local function teleportToArea(areaName)
    local area = game:GetService("Workspace"):FindFirstChild("Areas"):FindFirstChild(areaName)
    if area and LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart then
        LocalPlayer.Character.HumanoidRootPart.CFrame = area.CFrame + Vector3.new(0, 5, 0)
    end
end

-- UI Setup
local Window = Fluent:CreateWindow({
    Title = "Bubble Gum Simulator Infinity 🌟",
    SubTitle = "by YourName",
    TabWidth = 160,
    Size = UDim2.new(0, 580, 0, 460),
    Theme = "Dark",
    Acrylic = true,
    MinimizeKey = Enum.KeyCode.End
})

-- Debug: Confirm window creation
print("Window created:", Window)

-- Create tabs without icons to avoid potential rendering issues
local Tabs = {
    Main = Window:AddTab({ Title = "Main" }),
    Stats = Window:AddTab({ Title = "Stats" }),
    Settings = Window:AddTab({ Title = "Settings" })
}

-- Debug: Confirm tab creation
print("Tabs created:", Tabs.Main, Tabs.Stats, Tabs.Settings)

-- Function to safely add UI elements with error handling
local function safeAddElement(tab, method, key, options)
    local success, result = pcall(function()
        return tab[method](tab, key, options)
    end)
    if success then
        print("Added " .. method .. " '" .. key .. "' to tab " .. tab.Title)
        return result
    else
        warn("Failed to add " .. method .. " '" .. key .. "' to tab " .. tab.Title .. ": " .. result)
        return nil
    end
end

-- Main Tab: Start with a simple paragraph
safeAddElement(Tabs.Main, "AddParagraph", "AutomationFeatures", {
    Title = "Automation Features 🎮",
    Content = "Enable auto-features to farm bubbles and hatch eggs effortlessly!"
})

safeAddElement(Tabs.Main, "AddToggle", "AutoBubble", {
    Title = "Auto Bubble 🌬️",
    Default = false,
    Callback = function(value)
        local auto = autoBubble()
        if value then
            auto:Start()
        else
            auto:Stop()
            auto:Destroy()
        end
    end
})

safeAddElement(Tabs.Main, "AddToggle", "AutoHatch", {
    Title = "Auto Hatch 🥚",
    Default = false,
    Callback = function(value)
        local auto = autoHatch("BasicEgg")
        if value then
            auto:Start()
        else
            auto:Stop()
            auto:Destroy()
        end
    end
})

safeAddElement(Tabs.Main, "AddDropdown", "AreaTeleport", {
    Title = "Teleport to Area 🚀",
    Values = {"Spawn", "CandyLand", "ToyLand"},
    Multi = false,
    Default = "Spawn",
    Callback = function(value)
        teleportToArea(value)
    end
})

-- Stats Tab
safeAddElement(Tabs.Stats, "AddParagraph", "PlayerStats", {
    Title = "Player Stats 📊",
    Content = "Monitor your in-game progress."
})

safeAddElement(Tabs.Stats, "AddButton", "RefreshStats", {
    Title = "Refresh Stats 🔄",
    Callback = function()
        Fluent:Notify({
            Title = "Stats Updated",
            Content = "Bubbles: " .. (LocalPlayer.leaderstats.Bubbles.Value or 0) .. "\nGems: " .. (LocalPlayer.leaderstats.Gems.Value or 0),
            Duration = 5
        })
    end
})

-- Settings Tab
safeAddElement(Tabs.Settings, "AddParagraph", "SettingsInfo", {
    Title = "Settings ⚙️",
    Content = "Customize your script experience."
})

safeAddElement(Tabs.Settings, "AddKeybind", "ToggleUI", {
    Title = "Toggle UI Keybind",
    Default = "End",
    Callback = function()
        Window:Toggle()
    end
})

-- Initialize SaveManager and InterfaceManager if they loaded
if SaveManager then
    local success, err = pcall(function()
        SaveManager:SetLibrary(Fluent)
        SaveManager:IgnoreThemeSettings()
        SaveManager:SetFolder("BubbleGumSimulatorInfinity")
        SaveManager:BuildConfigSection(Tabs.Settings)
        SaveManager:LoadAutoloadConfig()
    end)
    if not success then
        warn("Failed to initialize SaveManager: " .. err)
    end
end

if InterfaceManager then
    local success, err = pcall(function()
        InterfaceManager:SetLibrary(Fluent)
        InterfaceManager:BuildThemeSection(Tabs.Settings)
    end)
    if not success then
        warn("Failed to initialize InterfaceManager: " .. err)
    end
end

-- Select Main Tab
Window:SelectTab(1)

-- Notify user
Fluent:Notify({
    Title = "Script Loaded 🎉",
    Content = "Bubble Gum Simulator Infinity script is ready! Use the UI to control features.",
    Duration = 8
})
