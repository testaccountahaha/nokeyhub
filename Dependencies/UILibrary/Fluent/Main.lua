-- Modified Fluent/Main.lua to fetch dependencies remotely
local Signal = loadstring(game:HttpGet("https://raw.githubusercontent.com/testaccountahaha/nokeyhub/main/Dependencies/Modules/Signal.lua"))()
local Trove = loadstring(game:HttpGet("https://raw.githubusercontent.com/testaccountahaha/nokeyhub/main/Dependencies/Modules/Trove.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/testaccountahaha/nokeyhub/main/Dependencies/UILibrary/Fluent/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/testaccountahaha/nokeyhub/main/Dependencies/UILibrary/Fluent/SaveManager.lua"))()

-- Rest of the original Fluent/Main.lua code (simplified for brevity)
local Fluent = { Options = {} }

function Fluent:CreateWindow(options)
    local window = { Tabs = {}, Trove = Trove.new() }
    window.Title = options.Title
    function window:CreateTab(tabOptions)
        local tab = { Elements = {} }
        function tab:CreateSection(sectionOptions)
            print("Section created:", sectionOptions.Name)
        end
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
            Fluent.Options[toggleOptions.Name] = { Value = toggleOptions.Default or false }
            if toggleOptions.Callback then
                toggleOptions.Callback(Fluent.Options[toggleOptions.Name].Value)
            end
            return Fluent.Options[toggleOptions.Name]
        end
        function tab:CreateDropdown(dropdownOptions)
            print("Dropdown created:", dropdownOptions.Name)
            if dropdownOptions.Callback then
                dropdownOptions.Callback(dropdownOptions.Options[1])
            end
        end
        function tab:CreateKeybind(keybindOptions)
            print("Keybind created:", keybindOptions.Name)
            if keybindOptions.Callback then
                keybindOptions.Callback()
            end
        end
        table.insert(window.Tabs, tab)
        return tab
    end
    function window:CreateNotification(notificationOptions)
        print("Notification:", notificationOptions.Title, notificationOptions.Content)
    end
    function window:Toggle()
        print("Window toggled")
    end
    ThemeManager:SetTheme(options.Theme or "Dark")
    SaveManager:LoadAutoloadConfig()
    return/window
end

function Fluent:Notify(options)
    print("Notify:", options.Title, options.Content)
end

return Fluent
