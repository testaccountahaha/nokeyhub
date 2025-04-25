-- Main.lua: Inlined script for emulator compatibility
-- Removed key system and local require statements

-- Inline Signal.lua (simplified for events)
local Signal = {}
function Signal.new()
    local self = { _bindings = {} }
    function self:Connect(callback)
        table.insert(self._bindings, callback)
        return { Disconnect = function() self._bindings[callback] = nil end }
    end
    function self:Fire(...)
        for _, callback in ipairs(self._bindings) do
            callback(...)
        end
    end
    return self
end

-- Inline Trove.lua (simplified for cleanup)
local Trove = {}
function Trove.new()
    local self = { _objects = {} }
    function self:Add(object)
        table.insert(self._objects, object)
        return object
    end
    function self:Clean()
        for _, object in ipairs(self._objects) do
            if typeof(object) == "RBXScriptConnection" then
                object:Disconnect()
            end
        end
        self._objects = {}
    end
    return self
end

-- Inline Dependencies/UILibrary/Fluent/ThemeManager.lua (simplified)
local ThemeManager = {
    BuiltInThemes = {
        Dark = { AccentColor = Color3.fromRGB(255, 255, 255) },
        Light = { AccentColor = Color3.fromRGB(0, 0, 0) }
    },
    Theme = "Dark",
    ThemeChanged = Signal.new()
}
function ThemeManager:SetTheme(theme)
    ThemeManager.Theme = theme
    ThemeManager.ThemeChanged:Fire()
end

-- Inline Dependencies/UILibrary/Fluent/SaveManager.lua (simplified)
local SaveManager = {}
function SaveManager:LoadAutoloadConfig() end
function SaveManager:BuildConfigSection() end

-- Inline Dependencies/UILibrary/Fluent/Main.lua (simplified Fluent UI library)
local Fluent = {}
Fluent.InterfaceOptions = { Theme = "Dark" }
Fluent.Options = {}

function Fluent:CreateWindow(options)
    local window = { Tabs = {}, Trove = Trove.new() }
    function window:CreateTab(tabOptions)
        local tab = { Elements = {} }
        function tab:CreateButton(buttonOptions)
            print("Button created:", buttonOptions.Name)
            local button = { Clicked = Signal.new() }
            if buttonOptions.Callback then
                button.Clicked:Connect(buttonOptions.Callback)
            end
            return button
        end
        function tab:CreateToggle(toggleOptions)
            print("Toggle created:", toggleOptions.Name)
            Fluent.Options[toggleOptions.Name] = { Value = false }
            if toggleOptions.Callback then
                toggleOptions.Callback(Fluent.Options[toggleOptions.Name].Value)
            end
            return Fluent.Options[toggleOptions.Name]
        end
        table.insert(window.Tabs, tab)
        return tab
    end
    function window:CreateNotification(notificationOptions)
        print("Notification:", notificationOptions.Title, notificationOptions.Content)
    end
    return window
end

function Fluent:Notify(options)
    print("Notify:", options.Title, options.Content)
end

-- Inline Dependencies/MobileHelper.lua (mocked)
local MobileHelper = {}
function MobileHelper:CreateMobileButton() end

-- Inline Games/116605585218149/Modules/Emojis.lua (simplified)
local Emojis = {
    ["Happy"] = "😊",
    ["Sad"] = "😢"
}

-- Inline Fluent.luau (main exploit script, modified to remove requires)
local Window = Fluent:CreateWindow({
    Title = "Bubble Gum Simulator Infinity",
    SubTitle = "by 0vma",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Main = Window:CreateTab({
        Name = "Main",
        Icon = "rbxassetid://6026568198"
    })
}

-- Sample exploit feature (mocked for simplicity)
Tabs.Main:CreateButton({
    Name = "Auto Farm",
    Callback = function()
        print("Auto Farm activated!")
    end
})

Tabs.Main:CreateToggle({
    Name = "Auto Click",
    Callback = function(value)
        print("Auto Click set to:", value)
    end
})

-- Notify on load
Fluent:Notify({
    Title = "Script Loaded",
    Content = "Bubble Gum Simulator Infinity exploit loaded successfully!"
})

-- Load game-specific features (mocked)
local GameId = game.PlaceId
if GameId == 116605585218149 then
    print("Loaded emojis for game 116605585218149:", Emojis["Happy"])
elseif GameId == 18901165922 then
    print("Loaded emojis for game 18901165922:", Emojis["Sad"])
end

-- Mock SaveManager and ThemeManager loading
SaveManager:LoadAutoloadConfig()
ThemeManager:SetTheme(Fluent.InterfaceOptions.Theme)

print("Exploit script fully loaded!")
