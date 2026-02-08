local cloneref = cloneref or function(obj)
	return obj
end

local Services = setmetatable({}, {
	__index = function(self, obj)
		return cloneref(game:GetService(obj))
	end
})

local Players = Services.Players
local lplr = Players.LocalPlayer

local WindUI = loadstring(game:HttpGet('https://github.com/Footagesus/WindUI/releases/latest/download/main.lua'))()
local Window = WindUI:CreateWindow({
    Title = 'kool aid | Disaster Run',
    Icon = 'solar:folder-2-bold-duotone',
    Author = 'by ._stav',
    Folder = 'kool.aid',

    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(900, 560),
    Transparent = true,
    Theme = 'Dark',
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    ScrollBarEnabled = true,
	IconSize = 24
})

Window:SetToggleKey(Enum.KeyCode.RightShift)

do
    Window:Tag({
        Title = 'v1.0.0',
        Icon = 'github',
		Color = Color3.fromHex("#1c1c1c"),
        Border = true,
    })

	Window:Tag({
        Title = 'beta',
		Color = Color3.fromHex("#1c1c1c"),
        Border = true,
    })
end

local Tabs = {
	Sections = {
		Main = Window:Section({
			Title = 'Main',
		}),
		Settings = Window:Section({
			Title = 'Settings',
		})
	},
}

Tabs.Combat = Tabs.Sections.Main:Tab({
	Title = 'Combat',
	Icon = 'sword',
	IconColor = Purple,
	IconShape = nil,
	Border = true,
})

Tabs.Player = Tabs.Sections.Main:Tab({
	Title = 'Player',
	Icon = 'person-standing',
	IconColor = Purple,
	IconShape = nil,
	Border = true,
})

Tabs.Themes = Tabs.Sections.Settings:Tab({
    Title = 'Themes',
    Icon = 'paintbrush',
    IconColor = Purple,
    IconShape = nil,
    Border = true,
})

Tabs.Config = Tabs.Sections.Settings:Tab({
	Title = 'Configs',
	Icon = 'solar:folder-with-files-bold',
	IconColor = Purple,
	IconShape = nil,
	Border = true,
})

local function downloadFile(file)
    url = file:gsub('koolaid/', '')
    if not isfile(file) then
        writefile(file, game:HttpGet('https://raw.githubusercontent.com/sstvskids/koolxtras/'..readfile('koolaid/commit.txt')..'/'..url))
    end

    repeat task.wait() until isfile(file)
    return readfile(file)
end

local Functions = loadstring(downloadFile('koolaid/libraries/functions.lua'))()
local Raycast = loadstring(downloadFile('koolaid/libraries/raycast.lua'))()
local Entity = loadstring(downloadFile('koolaid/libraries/entity.lua'))()

Functions.game = 'disasterrun'

-- Combat
--[[do
    local Velocity
    Velocity = Tabs.Combat:Toggle({
        Title = 'Velocity',
        Desc = 'Prevents you from taking knockback',
        Callback = function(value)
            if value then
                repeat
                    if Entity.isAlive(lplr) then
                        if lplr.Character.Humanoid.PlatformStand then
                            lplr.Character.Humanoid.Velocity = Vector3.new(lplr.Character.Humanoid.Velocity.X, 0, lplr.Character.Humanoid.Velocity.Z)
                        end
                    end

                    task.wait()
                until not Velocity.Value
            end
        end
    })
end]]

-- Player
do
    local Speed, SpeedSlider
    local SpeedVal = 16
    Speed = Tabs.Player:Toggle({
        Title = 'Speed',
        Desc = 'Automatically adjusts how fast the player goes',
        Callback = function(value)
            if value then
                repeat
                    if Entity.isAlive(lplr) then
                        local moveDir = lplr.Character.Humanoid.MoveDirection
                        lplr.Character.HumanoidRootPart.Velocity = Vector3.new(moveDir.X * SpeedVal, lplr.Character.HumanoidRootPart.Velocity.Y, moveDir.Z * SpeedVal)
                    end

                    task.wait()
                until not Speed.Value
            end
        end
    })
    SpeedSlider = Tabs.Player:Slider({
        Title = 'Speed',
        Value = {
            Min = 1,
            Max = 26,
            Default = 16
        },
        Callback = function(val)
            SpeedVal = val
        end
    })
end

do
    local ThemePicker
	local Themes = {}

	for i,v in WindUI:GetThemes() do
		table.insert(Themes, i)
	end

    ThemePicker = Tabs.Themes:Dropdown({
        Title = 'Theme',
        Desc = 'Select a theme for the Wind Interface',
        Values = Themes,
		Value = 'Dark',
        Callback = function(value)
            WindUI:SetTheme(value)
        end
    })
end

do
    local ConfigManager = Window.ConfigManager
    local ConfigName = 'default'
	local ConfigNameInput, AutoLoadToggle, AllConfigsDropDown,

    ConfigNameInput = Tabs.Config:Input({
        Title = 'Config Name',
        --Icon = 'file-cog',
        Callback = function(value)
            ConfigName = value
        end
    })

    Tabs.Config:Space()

    AutoLoadToggle = Tabs.Config:Toggle({
        Title = 'Enable Auto Load to Selected Config',
    	Value = false,
    	Callback = function(v)
        	Window.CurrentConfig:SetAutoLoad(v)
        end
    })

    Tabs.Config:Space()

    local AllConfigs = ConfigManager:AllConfigs()
    local DefaultValue = table.find(AllConfigs, ConfigName) and ConfigName or nil

    AllConfigsDropdown = Tabs.Config:Dropdown({
        Title = 'All Configs',
        Desc = 'Select existing configs',
        Values = AllConfigs,
        Value = DefaultValue,
        Callback = function(value)
            ConfigName = value
            ConfigNameInput:Set(value)

            AutoLoadToggle:Set(ConfigManager:GetConfig(ConfigName).AutoLoad or false)
        end
    })

    Tabs.Config:Space()

    Tabs.Config:Button({
        Title = 'Save Config',
        Justify = 'Center',
        Callback = function()
            Window.CurrentConfig = ConfigManager:Config(ConfigName)
            if Window.CurrentConfig:Save() then
                WindUI:Notify({
                    Title = 'Config Saved',
                    Desc = 'Config '/'..ConfigName..'/'saved',
                    Icon = 'check',
                })
            end

            AllConfigsDropdown:Refresh(ConfigManager:AllConfigs())
        end
    })

    Tabs.Config:Space()

    Tabs.Config:Button({
        Title = 'Load Config',
        Icon = '',
        Justify = 'Center',
        Callback = function()
            Window.CurrentConfig = ConfigManager:CreateConfig(ConfigName)
            if Window.CurrentConfig:Load() then
                WindUI:Notify({
                    Title = 'Config Loaded',
                    Desc = 'Config '/'..ConfigName..'/' loaded',
                    Icon = 'refresh-cw',
                })
            end
        end
    })
end
