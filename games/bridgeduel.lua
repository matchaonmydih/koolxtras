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
	Entity = Functions.require(ReplicatedStorage.Modules.Entity),
	ServerData = Functions.require(ReplicatedStorage.Modules.ServerData),
	Viewmodel = Functions.require(ReplicatedStorage.Client.Controllers.All.ViewmodelController),
	Paths = {
		Knockback = ReplicatedStorage.Modules.Knit.Services.CombatService.RE.KnockBackApplied
	},
	Detections = Functions.requirejank.helper:Fetch('Detections'),
}

--[[
	Combat
]]

do
	Dependencies.Detections:test('hash')

	if Dependencies.Detections.Logs.SwordH or Dependencies.Detections.Logs.BlockH then -- For future Stav: add thing blocking SwordHit, Webhook send also
		writefile('koolaid/logs.json', HttpService:JSONEncode(Dependencies.Detections.Logs))
		Library:Notify('A detection has been tripped [HASH]. Some script features have been disabled for your safety', 5)
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

local EntityCFrame
local Killaura, Flight = {Enabled = false}, {Enabled = false}
do
	local AutoBlock = {Enabled = true}
	local Angle = {Value = 360}
	local Range = {Value = 16}
	local TargetHUD = {Enabled = false}
	local Wallcheck = {Enabled = false}
	local Swing, SwingDelay = {Enabled = true}, tick()
	Killaura = Library.Tabs.Combat:CreateModule({
		Name = 'Killaura',
		Function = function(callback)
			if callback then
				repeat
					task.wait(0.1)
										
					if Entity.isAlive(lplr) then
						local tool = Entity.tool.getTool(lplr)
	
						if tool and tool:HasTag('Sword') then
							task.spawn(function()
								local suc, res = pcall(function()
									return Entity:GetClosestPlayer(Range.Value, Angle.Value, Wallcheck.Enabled)
								end)
	
								local plr
								if suc and res then
									plr = res
								end
													
								if plr and Entity.isAlive(plr) then
									EntityCFrame = CFrame.lookAt(lplr.Character.PrimaryPart.Position, Vector3.new(plr.Character.PrimaryPart.Position.X, lplr.Character.PrimaryPart.Position.Y, plr.Character.PrimaryPart.Position.Z))
									pcall(Library.CreateTargetHUD, Library, TargetHUD.Enabled, plr.Name, plr.Character:FindFirstChildOfClass('Humanoid'), Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size48x48))
									ReplicatedStorage.Modules.Knit.Services.ToolService.RF.ToggleBlockSword:InvokeServer(AutoBlock.Enabled, tool)
	
									if Swing.Enabled and SwingDelay < tick() then
										SwingDelay = tick() + 0.25
										lplr.Character.Humanoid.Animator:LoadAnimation(tool.Animations.Swing):Play()
	
										if setthreadidentity then
											setthreadidentity(2)
										end
										pcall(Dependencies.Viewmodel.PlayAnimation, Dependencies.Viewmodel, tool.Name)
										if setthreadidentity then
											setthreadidentity(8)
										end
									end
	
									local bdplr = Dependencies.Entity.FindByCharacter(plr.Character)
									if bdplr and bdplr.Id then -- (not Dependencies.Detections.Logs.SwordH)
										task.spawn(Dependencies.Blink.item_action.attack_entity.fire, {
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
									EntityCFrame = nil
									Library:CreateTargetHUD(false)
	
									if Entity.isAlive(lplr) then
										local tool = Entity.tool.getTool(lplr)
										if tool and tool:HasTag('Sword') then
											ReplicatedStorage.Modules.Knit.Services.ToolService.RF.ToggleBlockSword:InvokeServer(false, tool)
										end
									end
								end
							end)
						end
					end
				until not Killaura.Enabled
			else
				EntityCFrame = nil
				Library:CreateTargetHUD(false)
		
				if Entity.isAlive(lplr) then
					local tool = Entity.tool.getTool(lplr)
					if tool and tool:HasTag('Sword') then
						ReplicatedStorage.Modules.Knit.Services.ToolService.RF.ToggleBlockSword:InvokeServer(false, tool)
					end
				end
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

if hookmetamethod then -- Credits to my pooks nothm for this function
	do
		local Rotations, original
		Rotations = Library.Tabs.Combat:CreateModule({
			Name = 'Rotations',
			Function = function(callback)
				if callback then
					original = hookmetamethod(game, '__newindex', function(self, key, val)
						if self == lplr.Character.PrimaryPart and key == 'CFrame' then
							if not Flight.Enabled then
								if Killaura.Enabled and EntityCFrame then
									return original(self, key, EntityCFrame)
								end
							end
						end
	
						return original(self, key, val)
					end)
				else
					if original then
						hookmetamethod(game, '__newindex', original)
						original = nil
					end
				end
			end
		})
	end
end

--[[
	Movement
]]

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
	local OldY, NewY
	Flight = Library.Tabs.Movement:CreateModule({
		Name = 'Flight',
		Function = function(callback)
			if callback then
				NewY = 0
				OldY = lplr.Character.PrimaryPart.Position.Y

				repeat
					if Entity.isAlive(lplr) then
                        lplr.Character.PrimaryPart.CFrame = CFrame.new(lplr.Character.PrimaryPart.Position.X, OldY + NewY, lplr.Character.PrimaryPart.Position.Z) * lplr.Character.PrimaryPart.CFrame.Rotation

						if UserInputService:IsKeyDown('Space') and not UserInputService:GetFocusedTextBox() then
                            NewY += 0.8
                        elseif UserInputService:IsKeyDown('LeftShift') and not UserInputService:GetFocusedTextBox() then
                            NewY -= 0.8
                        end
					end

					task.wait()
				until not Flight.Enabled
			else
				NewY = 0
				if Entity.isAlive(lplr) then
					OldY = lplr.Character.PrimaryPart.Position.Y
				end
			end
		end
	})
end

--[[
	World
]]

do
	local AutoQueue
	AutoQueue = Library.Tabs.World:CreateModule({
		Name = 'AutoQueue',
		Function = function(callback)
			if callback then
				repeat
					if Dependencies.ServerData.Submode ~= 'Playground' and lplr.PlayerGui.Hotbar.MainFrame.GameEndFrame.Visible and not lplr.PlayerGui.Hotbar.MainFrame.MatchmakingFrame.Visible then
						ReplicatedStorage.Modules.Knit.Services.MatchService.RF.EnterQueue:InvokeServer(Dependencies.ServerData.Submode)
					end
														
					task.wait()
				until not AutoQueue.Enabled
			end
		end
	})
end

--[[
	Misc
]]

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
