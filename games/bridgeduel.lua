local cloneref = cloneref or function(obj)
	return obj
end

local Services = setmetatable({}, {
	__index = function(self, obj)
		return cloneref(game:GetService(obj))
	end
})

local ReplicatedStorage = Services.ReplicatedStorage
local UserInputService = Services.UserInputService
local HttpService = Services.HttpService
local Players = Services.Players
local lplr = Players.LocalPlayer

local function downloadFile(file)
    url = file:gsub('koolaid/', '')
    if not isfile(file) then
        writefile(file, game:HttpGet('https://raw.githubusercontent.com/sstvskids/koolxtras/'..readfile('koolaid/commit.txt')..'/'..url))
    end

    repeat task.wait() until isfile(file)
    return readfile(file)
end

local Library = loadstring(downloadFile('koolaid/interface/library.lua'))()

local Functions = loadstring(downloadFile('koolaid/libraries/functions.lua'))()
local Raycast = loadstring(downloadFile('koolaid/libraries/raycast.lua'))()
local Entity = loadstring(downloadFile('koolaid/libraries/entity.lua'))()

local Dependencies = {
    Blink = Functions.require(ReplicatedStorage.Blink.Client),
	Detections = Functions.requirejank.helper:Fetch('Detections'),
	Entity = Functions.require(ReplicatedStorage.Modules.Entity),
	Paths = {
		Knockback = ReplicatedStorage.Modules.Knit.Services.CombatService.RE.KnockBackApplied
	}
}

do
	Detections:test('hash')

	if Detections.Logs['SwordH'] or Detections.Logs['BlockH'] then
		writefile('koolaid/logs.json', HttpService:JSONEncode(Detections.Logs))
		Library:notify('A detection has been tripped [HASH], use script with caution.', 5)
	end
end

do
	local AutoClicker
	local Min, Max = {Value = 8}, {Value = 12}
	AutoClicker = Library.Tabs.Combat:CreateModule({
		Name = 'AutoClicker',
		Function = function(callback)
			if callback then
				repeat
					local tool, random = Entity.tool.getTool(lplr), Random.new()
					if tool and UserInputService:IsMouseButtonPressed(0) then
						tool:Activate()
					end
							
					task.wait(1 / random:NextNumber(Min.Value, Max.Value))
				until not AutoClicker.Enabled
			end
		end
	})
	Min = AutoClicker:CreateSlider({
        Name = 'Min',
		Min = 1,
		Max = 20,
		Default = 8
    })
	Max = AutoClicker:CreateSlider({
        Name = 'Max',
		Min = 1,
		Max = 20,
		Default = 12
    })
end

do
	local AntiKB
	AntiKB = Library.Tabs.Combat:CreateModule({
		Name = 'AntiKB',
		Function = function(callback)
			if callback then
				Dependencies.Paths.Knockback.Parent = nil
			else
				Dependencies.Paths.Knockback.Parent = ReplicatedStorage.Modules.Knit.Services.CombatService.RE
			end
		end
	})
end

do
    local Speed
	local SpeedSlider = {Value = 16}
    Speed = Library.Tabs.Movement:CreateModule({
        Name = 'Speed',
        Function = function(value)
            if value then
                repeat
                    if Entity.isAlive(lplr) then
                        local moveDir = lplr.Character.Humanoid.MoveDirection
                        lplr.Character.HumanoidRootPart.Velocity = Vector3.new(moveDir.X * SpeedSlider.Value, lplr.Character.HumanoidRootPart.Velocity.Y, moveDir.Z * SpeedSlider.Value)
                    end

                    task.wait()
                until not Speed.Enabled
            end
        end
    })
    SpeedSlider = Speed:CreateSlider({
        Name = 'Speed',
		Min = 1,
		Max = 28,
		Default = 16
    })
end

Library:notify('Loaded successfully! Press RShift to close the GUI', 6)
