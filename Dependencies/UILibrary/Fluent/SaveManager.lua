-- Modified SaveManager.lua to fetch TableUtil.lua remotely
local TableUtil = loadstring(game:HttpGet("https://raw.githubusercontent.com/testaccountahaha/nokeyhub/main/Dependencies/Modules/TableUtil.lua"))()

local SaveManager = {}

function SaveManager:LoadAutoloadConfig()
    print("Loaded autoload config (mocked)")
end

function SaveManager:BuildConfigSection()
    print("Built config section (mocked)")
end

return SaveManager
