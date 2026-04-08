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

function Entity:GetClosestPlayer(range, angle, wallcheck)
    local minrnge, entity = range, nil

	for i,v in Players:GetPlayers() do
	    if v ~= lplr and self.isAlive(lplr) and self.isAlive(v) then
			if not lplr:GetAttribute('PVP') or v:GetAttribute('PVP') then continue end
	        if wallcheck and not Raycast:CanSee(v.Character.PrimaryPart, {lplr.Character}) then continue end
	        if (v.Team and lplr.Team) and v.Team ~= 'Spectators' and v.Team == lplr.Team then continue end

		    local plrdir = math.deg(lplr.Character.HumanoidRootPart.CFrame.LookVector:Angle((v.Character.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Unit))
		    if angle <= plrdir / 2 then continue end

			local dist = lplr:DistanceFromCharacter(v.Character.PrimaryPart.Position)
			if dist < minrnge then
			    minrnge = dist
			    entity = v
			end
	    end
	end

    return entity
end

local Dependencies = {
    Modules = {
        ItemData = Functions.require(ReplicatedStorage.Modules.DataModules.ItemsData),
        VeloUtils = ReplicatedStorage.Modules.VelocityUtils
    },
    Controllers = {
        Viewmodel = Functions.requirejank.helper:Fetch('ViewmodelController')
    },
    Handlers = {
        Tools = ReplicatedStorage.ToolHandlers
    },
    Remotes = {
        EquipTool = ReplicatedStorage.Remotes.ItemsRemotes.EquipTool,
        AttackPlayer = ReplicatedStorage.Remotes.ItemsRemotes.SwordHit
    },
    Classes = {
        Melee = {},
        Ranged = {},
        Mining = {},
        Blocks = {}
    }
}

local classGroups = {
    Swords = 'Melee', Mace = 'Melee', Katanas = 'Melee', Daggers = 'Melee', ['Battle Axes'] = 'Melee', Spears = 'Melee',
    Axes = 'Mining', Pickaxes = 'Mining',
    Ranged = 'Ranged',
    Blocks = 'Blocks'
}

for i,v in Dependencies.Modules.ItemData do
    if classGroups[v.Class] then
        table.insert(Dependencies.Classes[classGroups[v.Class]], i)
        continue
    end
end

local AutoTool = {Enabled = false}
local function getTool(class)
    for i,v in Dependencies.Classes[class] do
        local tool = tostring(v)
        if Entity.tool.hasTool(lplr, tool) ~= nil then
            return Entity.tool.hasTool(lplr, tool)
        end

        if AutoTool.Enabled and Entity.tool.hasToolInv(lplr, tool) ~= nil then
            Dependencies.Remotes.EquipTool:FireServer(tool)
            return Entity.tool.hasToolInv(lplr, tool)
        end

        continue
    end

    return nil
end

do
    AutoTool = Library.Tabs.Combat:CreateModule({
        Name = 'AutoTool'
    })
end

do
    local AntiKB, AntiKBConn
    AntiKB = Library.Tabs.Combat:CreateModule({
        Name = 'AntiKB',
        Function = function(callback)
            if callback then
                for i,v in Dependencies.Modules.VeloUtils:GetChildren() do
                    if v.ClassName == 'LinearVelocity' then
                        v.Enabled = false
                    end

                    continue
                end

                AntiKBConn = Dependencies.Modules.VeloUtils.ChildAdded:Connect(function(obj)
                    if obj.ClassName == 'LinearVelocity' then
                        obj.Enabled = false
                    end
                end)
            else
                if AntiKBConn then
                    AntiKBConn:Disconnect()
                    AntiKBConn = nil
                end

                for i,v in Dependencies.Modules.VeloUtils:GetChildren() do
                    if v.ClassName == 'LinearVelocity' then
                        v.Enabled = true
                    end

                    continue
                end
            end
        end
    })
end

local EntityCFrame
local Killaura, Flight = {Enabled = false}, {Enabled = false}
do
    local Aura
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
						task.spawn(function()
							local suc, res = pcall(function()
								return Entity:GetClosestPlayer(Range.Value, Angle.Value, Wallcheck.Enabled)
							end)

							local plr
							if suc and res then
								plr = res
							end

							if plr and Entity.isAlive(plr) then
			                    local tool = getTool('Melee')

								if tool then
									EntityCFrame = CFrame.lookAt(lplr.Character.PrimaryPart.Position, Vector3.new(plr.Character.PrimaryPart.Position.X, lplr.Character.PrimaryPart.Position.Y, plr.Character.PrimaryPart.Position.Z))
									pcall(Library.CreateTargetHUD, Library, TargetHUD.Enabled, plr.Name, plr.Character:FindFirstChildOfClass('Humanoid'), Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size48x48))

									if Swing.Enabled and SwingDelay < tick() then
									    SwingDelay = tick() + 0.2

										pcall(Dependencies.Controllers.Viewmodel.PlayAnimation, Dependencies.Controllers.Viewmodel, 'Melee', 'Swing')
										if not lplr.Character.Humanoid:FindFirstChild('Swing1') then
										    Dependencies.Handlers.Tools.Sword.Sounds.Default.Swing1:Clone().Parent = lplr.Character.Humanoid
										end

										lplr.Character.Humanoid:WaitForChild('Swing1'):Play()
									end

									task.spawn(Dependencies.Remotes.AttackPlayer.FireServer, Dependencies.Remotes.AttackPlayer, tool.Name, plr.Character)
								else
								    Library:CreateTargetHUD(false)
								end
							end
						end)
					end
				until not Killaura.Enabled
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
