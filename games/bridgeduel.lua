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

--[[
	Combat
]]

do
	Dependencies.Detections:test('hash')

	if Dependencies.Detections.Logs.SwordH or Dependencies.Detections.Logs.BlockH then -- For future Stav: add thing blocking SwordHit, Webhook send also
		writefile('koolaid/logs.json', HttpService:JSONEncode(Dependencies.Detections.Logs))
		Library:Notify('A detection has been tripped [HASH], use script with caution.', 5)
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

local AuraCrits
do
	local Criticals, original
	Criticals = Library.Tabs.Combat:CreateModule({
		Name = 'Criticals',
		Function = function(callback)
			if callback then
				if not Functions.requirejank.properRequire then
					AuraCrits = true
					return
				end

				original = Functions.hook(Dependencies.Blink.item_action.attack_entity.fire, function(...)
					local args = ...
					if type(args) == 'table' then 
						rawset(args, 'is_crit', true)
					end
										
					return original(...)
				end)
			else
				if not hookfunction or not Functions.requirejank.properRequire then
					AuraCrits = false
					return
				end

				Functions.hook(Dependencies.Blink.item_action.attack_entity.fire, original)
				original = nil
			end
		end
	})
end

do
	local Killaura
	local AutoBlock = {Enabled = true}
	local Angle = {Value = 360}
	local Range = {Value = 16}
	local TargetHUD = {Enabled = false}
	local Wallcheck = {Enabled = false}
	local Swing = {Enabled = true}
	Killaura = Library.Tabs.Combat:CreateModule({
		Name = 'Killaura',
		Function = function(callback)
			if callback then
				repeat
					if Entity.isAlive(lplr) then
						local tool = Entity.tool.getTool(lplr)
	
						if tool and tool:HasTag('Sword') then
							local plr = Entity:GetClosestPlayer(Range.Value, Angle.Value, Wallcheck.Enabled)
							if plr and Entity.isAlive(plr) then
								Library:CreateTargetHUD(TargetHUD.Enabled, plr.Name, Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size48x48), plr.Character:FindFirstChildOfClass('Humanoid'))
								ReplicatedStorage.Modules.Knit.Services.ToolService.RF.ToggleBlockSword:InvokeServer(AutoBlock.Enabled, tool)

								local bdplr = Dependencies.Entity.FindByCharacter(plr.Character)
								if bdplr and bdplr.Id then
									Dependencies.Blink.item_action.attack_entity.fire({
										target_entity_id = bdplr.Id,
										is_crit = (AuraCrits and true) or lplr.Character.HumanoidRootPart.AssemblyLinearVelocity.Y < 0,
										weapon_name = tool.Name,
										extra = {
											rizz = 'Bro.',
											owo = 'What\'s this? OwO ',
											those = workspace.Name == 'Ok'
										}
									})
								end
							else
								Library:CreateTargetHUD(false, plr.Name, Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size48x48), plr.Character:FindFirstChildOfClass('Humanoid'))
								ReplicatedStorage.Modules.Knit.Services.ToolService.RF.ToggleBlockSword:InvokeServer(false, tool)
							end
						end
					end
							
					task.wait(.1)
				until not Killaura.Enabled
			end
		end
	})
	AutoBlock = Killaura:CreateToggle({
		Name = 'AutoBlock',
		Enabled = true
	})
	Angle = Killaura:CreateSlider({
		Name = 'Max Angle',
		Min = 1,
		Max = 360,
		Default = 360
	})
	Range = Killaura:CreateSlider({
		Name = 'Range',
		Min = 1,
		Max = 18,
		Default = 16
	})
	TargetHUD = Killaura:CreateToggle({
		Name = 'HUD'
	})
	Wallcheck = Killaura:CreateToggle({
		Name = 'Wallcheck'
	})
	Swing = Killaura:CreateToggle({
		Name = 'Swing',
		Enabled = true
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

do
	local Disabler
	Disabler = Library.Tabs.Misc:CreateModule({
		Name = 'Disabler',
		Function = function(callback)
			if callback then
				Dependencies.Detections.Paths.SendReport.Parent = nil
			else
				Dependencies.Detections.Paths.SendReport.Parent = ReplicatedStorage.Modules.Knit.Services.NetworkService.RF
			end
		end
	})
end

Library:Notify('Loaded successfully! Press RShift to close the GUI', 6)
