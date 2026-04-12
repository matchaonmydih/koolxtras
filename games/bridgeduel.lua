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

local Library = shared.Library

local Functions = loadstring(downloadFile('koolaid/libraries/functions.lua'))()
local Raycast = loadstring(downloadFile('koolaid/libraries/raycast.lua'))()
local Entity = loadstring(downloadFile('koolaid/libraries/entity.lua'))()

local Dependencies = {
    Blink = Functions.require(ReplicatedStorage.Blink.Client),
    Modules = {
        Helper = Functions.requirejank.helper:Fetch('Dumper'),
        Entity = Functions.require(ReplicatedStorage.Modules.Entity),
        ServerData = Functions.require(ReplicatedStorage.Modules.ServerData)
    },
    Controllers = {
        Viewmodel = Functions.require(ReplicatedStorage.Client.Controllers.All.ViewmodelController),
		Block = Functions.require(ReplicatedStorage.Client.Controllers.All.BlockPlacementController)
    },
    Constants = {
		Melee = Functions.require(ReplicatedStorage.Constants.Melee),
        Ranks = Functions.require(ReplicatedStorage.Constants.Ranks)
    },
	Paths = {
		Knockback = ReplicatedStorage.Modules.Knit.Services.CombatService.RE.KnockBackApplied,
		Sword = ReplicatedStorage.Client.Components.All.Tools.SwordClient,
		SendReport = ReplicatedStorage.Modules.Knit.Services.NetworkService.RF.SendReport
	},
}

--[[
	Combat
]]

do
	Dependencies.Constants.Extra = Dependencies.Modules.Helper.dump((Dependencies.Modules.Helper.decompile(Dependencies.Paths.Sword)))
end

print(Dependencies.Constants.Extra)

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
	local Reach
	local Value = {Value = 16}
	Reach = Library.Tabs.Combat:CreateModule({
		Name = 'Reach',
		Function = function(callback)
			if callback then
				repeat
					if Entity.isAlive(lplr) then
						if Dependencies.Constants.Melee.fetchedCE then
							Dependencies.Constants.Melee.REACH_IN_STUDS.Value = Value.Value
						else
							Dependencies.Constants.Melee.REACH_IN_STUDS = Value.Value
						end
						
						Dependencies.Modules.Entity.LocalEntity.Reach = Value.Value
					end

					task.wait()
				until not Reach.Enabled
			end
		end
	})
	Value = Reach:CreateSlider({
        Name = 'Value',
		Min = 1,
		Max = 18,
		Default = 16
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

								local plr, bdplr
								if suc and res then
									plr = res
									bdplr = Dependencies.Modules.Entity.FindByCharacter(plr.Character)
								end

								if plr and bdplr and Entity.isAlive(plr) then
									if bdplr.IsInPvpArena and Dependencies.Modules.Entity.LocalEntity.IsInPvpArena then
										EntityCFrame = CFrame.lookAt(lplr.Character.PrimaryPart.Position, Vector3.new(plr.Character.PrimaryPart.Position.X, lplr.Character.PrimaryPart.Position.Y, plr.Character.PrimaryPart.Position.Z))
										pcall(Library.CreateTargetHUD, Library, TargetHUD.Enabled, plr.Name, plr.Character:FindFirstChildOfClass('Humanoid'), Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size48x48))
										ReplicatedStorage.Modules.Knit.Services.ToolService.RF.ToggleBlockSword:InvokeServer(AutoBlock.Enabled, tool)

										if Swing.Enabled and SwingDelay < tick() then
											SwingDelay = tick() + 0.25
											lplr.Character.Humanoid.Animator:LoadAnimation(tool:WaitForChild('Animations'):WaitForChild('Swing')):Play()

											if setthreadidentity then
												setthreadidentity(2)
											end
											pcall(Dependencies.Controllers.Viewmodel.PlayAnimation, Dependencies.Controllers.Viewmodel, tool.Name)
											if setthreadidentity then
												setthreadidentity(8)
											end
										end

										if bdplr.Id and Dependencies.Constants.Extra then -- (not Dependencies.Modules.Detections.Logs.SwordH)
											task.spawn(Dependencies.Blink.item_action.attack_entity.fire, {
												target_entity_id = bdplr.Id,
												is_crit = (AuraCrits and true) or lplr.Character.HumanoidRootPart.AssemblyLinearVelocity.Y < 0,
												weapon_name = tool.Name,
												extra = Dependencies.Constants.Extra
											})
										end
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
					if not original then
						original = hookmetamethod(game, '__newindex', function(self, key, val)
							if self == lplr.Character.PrimaryPart and key == 'CFrame' then
								if not Flight.Enabled then
									if Killaura.Enabled and EntityCFrame then
										return original(self, key, CFrame.new(val.Position) * CFrame.Angles(0, math.atan2(-EntityCFrame.LookVector.X, -EntityCFrame.LookVector.Z), 0))
									end
								end
							end

							return original(self, key, val)
						end)
					end
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
        Function = function(callback)
            if callback then
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

do
	-- Credits to my pooks nothm for the getPosition, isAtPos and GetPosition calculations
	local Scaffold, PlacePos
	local ItemCheck = {Enabled = false}
	local Expand = {Value = 3}

	local function getPosition(pos)
		return Vector3.new(math.floor((pos.X / 3) + 0.5) * 3, math.floor((pos.Y / 3) + 0.5) * 3, math.floor((pos.Z / 3) + 0.5) * 3)
	end

	local function isAtPos(pos)
		for i,v in workspace.Map:GetDescendants() do
			if v:IsA("BasePart") and v.Name == "Block" then
				if getPosition(v.Position) == pos then
					return true
				end
			end
		end

		return false
	end

	local function getBlock()
		local tool = Entity.tool.getTool(lplr)
		if tool and tool:HasTag('Blocks') then
			return tool
		end

		if ItemCheck.Enabled then return nil end
		for i, v in lplr.Backpack:GetChildren() do
			if v:HasTag('Blocks') then
				return v
			end
		end

		return nil
	end

	Scaffold = Library.Tabs.Movement:CreateModule({
		Name = 'Scaffold',
		Function = function(callback)
			if callback then
				repeat
					if Entity.isAlive(lplr) then
						task.spawn(function()
							for i = 1, Expand.Value do
								local tool = getBlock()

								if tool then
									local btype = tool.Name == 'Blocks' and 'Clay' or tool.Name:sub(1, -6)
									local offset = Dependencies.Modules.Entity.LocalEntity.IsSneaking and 4.5 or 1.5

									if lplr.Character.Humanoid.FloorMaterial ~= Enum.Material.Air and (UserInputService:IsKeyDown(Enum.KeyCode.Space) and not UserInputService:GetFocusedTextBox()) then
										lplr.Character.PrimaryPart.Velocity = Vector3.new(lplr.Character.PrimaryPart.Velocity.X, 28, lplr.Character.PrimaryPart.Velocity.Z)
									end

									PlacePos = getPosition(lplr.Character.PrimaryPart.Position + lplr.Character.Humanoid.MoveDirection * (i * 3.5) - Vector3.yAxis * ((lplr.Character.PrimaryPart.Size.Y / 2) + lplr.Character.Humanoid.HipHeight + offset))
									if not isAtPos(PlacePos) and not Raycast:IfBlockUnderneath(i) then
										if setthreadidentity then
											setthreadidentity(2)
										end
										task.spawn(Dependencies.Controllers.Block.PlaceBlock, Dependencies.Controllers.Block, PlacePos, btype)
										if setthreadidentity then
											setthreadidentity(8)
										end
									end
								end
							end
						end)
					end

					task.wait()
				until not Scaffold.Enabled
			end
		end
	})
	ItemCheck = Scaffold:CreateToggle({
		Name = 'Item Check',
		Enabled = true
	})
	Expand = Scaffold:CreateSlider({
        Name = 'Expand',
		Min = 1,
		Max = 6,
		Default = 1
    })
end

--[[
	World
]]

do
    local AntiStaff, StaffConn
    local Method = {Value = 'Kick'}
    AntiStaff = Library.Tabs.World:CreateModule({
        Name = 'AntiStaff',
        Function = function(callback)
            if callback then
                for _, v in Players:GetPlayers() do
                    if table.find(Dependencies.Constants.Ranks[1].Users, v.UserId) then
                        if Method.Value == 'Notify' then
                            Library:Notify('A staff member is in your game: '..v.Name, 6)
                        elseif Method.Value == 'Uninject' then
                            Library:Uninject()
                        elseif Method.Value == 'Kick' then
                            lplr:Kick('A staff member is in your game: '..v.Name)
                        end
                    end
                end

                StaffConn = Players.PlayerAdded:Connect(function(plr)
                    if table.find(Dependencies.Constants.Ranks[1].Users, plr.UserId) then
                        if Method.Value == 'Notify' then
                            Library:Notify('A staff member is in your game: '..plr.Name, 6)
                        elseif Method.Value == 'Uninject' then
                            Library:Uninject()
                        elseif Method.Value == 'Kick' then
                            lplr:Kick('A staff member is in your game: '..plr.Name)
                        end
                    end
                end)
            else
                if StaffConn then
                    StaffConn:Disconnect()
                    StaffConn = nil
                end
            end
        end
    })
    Method = AntiStaff:CreateDropdown({
        Name = 'Method',
        Options = {'Notify', 'Uninject', 'Kick'},
        Default = 'Notify'
    })
end

do
	local AutoQueue
	AutoQueue = Library.Tabs.World:CreateModule({
		Name = 'AutoQueue',
		Function = function(callback)
			if callback then
				repeat
					if Dependencies.Modules.ServerData.Submode ~= 'Playground' and lplr.PlayerGui.Hotbar.MainFrame.GameEndFrame.Visible == true and lplr.PlayerGui.Hotbar.MainFrame.MatchmakingFrame.Visible == false then
						ReplicatedStorage.Modules.Knit.Services.MatchService.RF.EnterQueue:InvokeServer(Dependencies.Modules.ServerData.Submode)
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
				Dependencies.Paths.SendReport.Parent = nil
			else
				Dependencies.Paths.SendReport.Parent = ReplicatedStorage.Modules.Knit.Services.NetworkService.RF
			end
		end
	})
end

Library:Notify('Loaded successfully! Press INSERT to open kool aid.', 6)