-- Keyless auto-loader for Strelizia (test version)
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/0vma/Strelizia/main/Fluent.luau"))()
local ScriptStates = loadstring(game:HttpGet("https://raw.githubusercontent.com/0vma/Strelizia/main/Dependencies/ScriptStates.lua"))()

local DependenciesURL = "https://raw.githubusercontent.com/0vma/Strelizia/main/Dependencies/"
local PlaceId = game.PlaceId

-- COMMENT THIS FOR UNIVERSAL TESTING
-- if not ScriptStates[PlaceId] then return end

Fluent:Notify({
    Title = "Strelizia No Key",
    Content = "Script started successfully",
    Duration = 5
})

local success, result = pcall(function()
    return loadstring(game:HttpGet(DependenciesURL .. "Functions.lua"))()
end)

if success then
    print("✅ Functions loaded successfully")
else
    warn("❌ Failed to load Functions:", result)
end
