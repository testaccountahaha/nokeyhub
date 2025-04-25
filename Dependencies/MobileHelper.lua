-- Modified MobileHelper.lua to fetch Utility.lua remotely
local Utility = loadstring(game:HttpGet("https://raw.githubusercontent.com/testaccountahaha/nokeyhub/main/Dependencies/Modules/Utility.lua"))()

local MobileHelper = {}

function MobileHelper:CreateMobileButton()
    print("Mobile button created")
end

return MobileHelper
