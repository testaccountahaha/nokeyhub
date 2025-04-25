-- Modified Fluent.luau to fetch dependencies remotely
local FluentLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/testaccountahaha/nokeyhub/main/Dependencies/UILibrary/Fluent/Main.lua"))()
local Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/testaccountahaha/nokeyhub/main/Dependencies/Functions.lua"))()
local MobileHelper = loadstring(game:HttpGet("https://raw.githubusercontent.com/testaccountahaha/nokeyhub/main/Dependencies/MobileHelper.lua"))()

-- Game-specific modules
local GameId = game.PlaceId
local Emojis
if GameId == 116605585218149 then
    Emojis = loadstring(game:HttpGet("https://raw.githubusercontent.com/testaccountahaha/nokeyhub/main/Games/116605585218149/Modules/Emojis.lua"))()
elseif GameId == 18901165922 then
    Emojis = loadstring(game:HttpGet("https://raw.githubusercontent.com/testaccountahaha/nokeyhub/main/Games/18901165922/Modules/Emojis.lua"))()
else
    Emojis = {}
end

local Fluent = FluentLibrary
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
    }),
    Visuals = Window:CreateTab({
        Name = "Visuals",
        Icon = "rbxassetid://6031280882"
    }),
    Settings = Window:CreateTab({
        Name = "Settings",
        Icon = "rbxassetid://7059346373"
    })
}

-- Main Tab: Add exploit functions
Tabs.Main:CreateSection({ Name = "Farming" })
Tabs.Main:CreateToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(Value)
        Functions:AutoFarm(game.Players.LocalPlayer, Value)
    end
})

Tabs.Main:CreateToggle({
    Name = "Auto Click",
    Default = false,
    Callback = function(Value)
        Functions:AutoClick(game.Players.LocalPlayer, Value)
    end
})

Tabs.Main:CreateSection({ Name = "Teleport" })
Tabs.Main:CreateButton({
    Name = "Teleport to Spawn",
    Callback = function()
        Functions:TeleportTo(game.Players.LocalPlayer, Vector3.new(0, 5, 0))
    end
})

Tabs.Main:CreateDropdown({
    Name = "Teleport to Player",
    Options = (function()
        local players = {}
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                table.insert(players, player.Name)
            end
        end
        return players
    end)(),
    Callback = function(Value)
        local target = game.Players:FindFirstChild(Value)
        if target then
            Functions:TeleportToPlayer(game.Players.LocalPlayer, target)
        end
    end
})

-- Visuals Tab: Add ESP or other visual features (mocked for now)
Tabs.Visuals:CreateSection({ Name = "ESP" })
Tabs.Visuals:CreateToggle({
    Name = "Enable ESP",
    Default = false,
    Callback = function(Value)
        print("ESP Enabled:", Value)
    end
})

-- Settings Tab: Add configuration options
Tabs.Settings:CreateSection({ Name = "Configuration" })
Tabs.Settings:CreateKeybind({
    Name = "Toggle UI",
    Default = "RightControl",
    Callback = function()
        Window:Toggle()
    end
})

-- Notify on load
Fluent:Notify({
    Title = "Script Loaded",
    Content = "Bubble Gum Simulator Infinity exploit loaded successfully!",
    Duration = 5
})

-- Load game-specific features
if Emojis["Happy"] then
    print("Loaded emojis:", Emojis["Happy"])
end

-- Mobile support
MobileHelper:CreateMobileButton()

local Fluent = {}
function Fluent:Load()
    -- Already loaded via script execution
end

return Fluent
