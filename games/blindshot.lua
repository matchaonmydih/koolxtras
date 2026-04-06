local cloneref = cloneref or function(obj)
	return obj
end

local Services = setmetatable({}, {
	__index = function(self, obj)
		return cloneref(game:GetService(obj))
	end
})

local RunService = Services.RunService
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
local Raycast = loadstring(downloadFile('koolaid/libraries/raycast.lua'))()
local Entity = loadstring(downloadFile('koolaid/libraries/entity.lua'))()

-- Combat
do
    local AntiHit, HitConn
    AntiHit = Library.Tabs.Combat:CreateModule({
        Title = 'Anti Hit',
        Desc = 'Prevents you from getting hit by enemies',
        Callback = function(value)
            if value then
                Library.Signal:newconn(RunService.BindToRenderStep, function()
                    lplr.Character.Humanoid.HipHeight = -2
                end)
            else
                if HitConn then
                    HitConn:Disconnect()
                end
                lplr.Character.Humanoid.HipHeight = 1
            end
        end
    })
end

do
    local Velocity
    Velocity = Library.Tabs.Combat:CreateModule({
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
end

-- Movement
do
    local Speed, SpeedSlider
    local SpeedVal = 16
    Speed = Library.Tabs.Movement:Toggle({
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
            Max = 200,
            Default = 16
        },
        Callback = function(val)
            SpeedVal = val
        end
    })
end

do
    local AutoCash
    AutoCash = Library.Tabs.World:Toggle({
        Title = 'Auto Cash',
        Desc = 'Automatically gives you cash within an interval of 20 seconds',
        Callback = function(value)
            if value then
                if not firetouchinterest then
                    return AutoCash:Toggle(false)
                end

                repeat
                    if firetouchinterest and Entity.isAlive(lplr) then
                        firetouchinterest(workspace._THINGS.Obby.Trophy, lplr.Character.HumanoidRootPart, 0)
                        firetouchinterest(workspace._THINGS.Obby.Trophy, lplr.Character.HumanoidRootPart, 1)
                    end

                    task.wait(20)
                until not AutoCash.Value
            end
        end
    })
end
