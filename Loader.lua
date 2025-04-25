-- Keyless Loader.lua
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/0vma/Strelizia/main/Fluent.luau"))()
local ScriptStates = loadstring(game:HttpGet("https://raw.githubusercontent.com/0vma/Strelizia/main/Dependencies/ScriptStates.lua"))()

local DependenciesURL = "https://raw.githubusercontent.com/0vma/Strelizia/main/Dependencies/"
local PlaceId = game.PlaceId

if not ScriptStates[PlaceId] then
    return
end

-- Skip key system
loadstring(game:HttpGet(DependenciesURL .. "Functions.lua"))()
