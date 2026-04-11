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
local Workspace = Services.Workspace
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
    Client = Functions.require(ReplicatedStorage.Shared.ClientRuntime), -- Attack, Block Placement, BreakBlock
    Modules = {
        Combat = Functions.require(ReplicatedStorage.Shared.Utilities.CombatHitbox),
        ActionPermissions = Functions.require(ReplicatedStorage.Shared.Utilities.ActionPermissions),
		Definitions = Functions.require(ReplicatedStorage.Shared.ClientRuntime.Definitions)
    },
    Constants = {
        Tool = {
            Types = Functions.require(ReplicatedStorage.Shared.Constants.ToolTypes)
        }
    },
    Controllers = {
        Viewmodel = Functions.requirejank.helper:Fetch('ViewmodelController')
    }
}

do
	local Reach
	local Value, old = {Value = 22}, Dependencies.Modules.Definitions.GetDefaultValue('combatReach') or 3
	Reach = Library.Tabs.Combat:CreateModule({
		Name = 'Reach',
		Function = function(callback)
			if callback then
				Dependencies.Client.SetCombatReach(Value.Value)
			else
				Dependencies.Client.SetCombatReach(Dependencies.Modules.Definitions.GetDefaultValue('combatReach') or 3)
			end
		end
	})
end

local Killaura, Flight = {Enabled = false}, {Enabled = false}
do
    local Angle = {Value = 360}
	local Range = {Value = 22}
	local TargetHUD = {Enabled = false}
	local Wallcheck = {Enabled = false}
	local Swing, SwingDelay = {Enabled = true}, tick()
    local Rotations, EntityCFrame = {Enabled = false}, nil
	Killaura = Library.Tabs.Combat:CreateModule({
		Name = 'Killaura',
		Function = function(callback)
			if callback then
				repeat
					task.wait(0.1)

					if Entity.isAlive(lplr) and Dependencies.Modules.ActionPermissions.CanCombat(lplr) then
						local suc, res = pcall(function()
							return Entity:GetClosestPlayer(Range.Value, Angle.Value, Wallcheck.Enabled)
						end)

						local plr
						if suc and res then
							plr = res
						end

						if plr and Entity.isAlive(plr) and Dependencies.Modules.ActionPermissions.CanCombat(plr) then
                            local tool = Entity.tool.getTool(lplr)

                            task.spawn(function()
    							if tool and Dependencies.Constants.Tool.Types.IsCombatTool(tool) then
    								pcall(Library.CreateTargetHUD, Library, TargetHUD.Enabled, plr.Name, plr.Character:FindFirstChildOfClass('Humanoid'), Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size48x48))

    								if Swing.Enabled and SwingDelay < tick() then
                                        SwingDelay = tick() + 0.1
    									pcall(Dependencies.Controllers.Viewmodel.PlayAnimation, Dependencies.Controllers.Viewmodel)
    								end

                                    if Rotations.Enabled then
                                        EntityCFrame = CFrame.lookAt(lplr.Character.PrimaryPart.Position, Vector3.new(plr.Character.PrimaryPart.Position.X, lplr.Character.PrimaryPart.Position.Y, plr.Character.PrimaryPart.Position.Z))
                                        lplr.Character.PrimaryPart.CFrame = CFrame.new(lplr.Character.PrimaryPart.Position) * CFrame.Angles(0, math.atan2(-EntityCFrame.LookVector.X, -EntityCFrame.LookVector.Z), 0)

                                        if Entity.isFirstPerson() then
                                            Workspace.CurrentCamera.CFrame = CFrame.new(lplr.Character.PrimaryPart.Position) * CFrame.Angles(0, math.atan2(-EntityCFrame.LookVector.X, -EntityCFrame.LookVector.Z), 0)
                                        end
                                    end

    								task.spawn(Dependencies.Client.Attack, plr.Character)
    							else
                                    EntityCFrame = nil
    								Library:CreateTargetHUD(false)
    							end
                            end)
						else
                            EntityCFrame = nil
						    Library:CreateTargetHUD(false)
						end
					end
				until not Killaura.Enabled
			else
                EntityCFrame = nil
			    Library:CreateTargetHUD(false)
			end
		end
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
		Max = 22,
		Default = 22
	})
    Rotations = Killaura:CreateToggle({
		Name = 'Rotations'
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
		Max = 100,
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

Library:Notify('Loaded successfully! Press INSERT to open kool aid.', 6)
