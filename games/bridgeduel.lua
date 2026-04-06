local cloneref = cloneref or function(obj)
	return obj
end

local Services = setmetatable({}, {
	__index = function(self, obj)
		return cloneref(game:GetService(obj))
	end
})

local ReplicatedStorage = Services.ReplicatedStorage
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
    Blink = Functions.require(ReplicatedStorage.Blink.Client)
}

do
	local AutoClicker
	AutoClicker = Library.Tabs.Combat:CreateModule({
		Name = 'AutoClicker',
		Function = function(callback)
			if callback then
				repeat
					local tool = getTool()
					if tool and inputService:IsMouseButtonPressed(0) then
						tool:Activate()
					end
					task.wait()
				until not AutoClicker.Enabled
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

print(Dependencies.Blink)
