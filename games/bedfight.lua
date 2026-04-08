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
    Modules = {
        ItemData = Functions.require(ReplicatedStorage.Modules.DataModules.ItemsData),
        VeloUtils = ReplicatedStorage.Modules.VelocityUtils
    },
    Classes = {
        Melee = {},
        Ranged = {},
        Mining = {},
        Blocks = {}
    }
}

--[[

    For future stav: Aura is going to be set out by the names of items in the table of classes
    Melee = {
        Wooden Sword, etc.
    }

    Get the items in those classes, see if the player has the item on them, attack using the names of the classes

]]

function Entity:GetClosestPlayer(range, angle, wallcheck)
    local minrnge, entity = range, nil

	for i,v in Players:GetPlayers() do
	    if v ~= lplr and self.isAlive(lplr) and self.isAlive(v) then
			if lplr:GetAttribute('PVP') == false or v:GetAttribute('PVP') == false then continue end
	        if wallcheck and not raycast:CanSee(v.Character.PrimaryPart, {lplr.Character}) then continue end
	        if v.Team and lplr.Team and v.Team == lplr.Team then continue end

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
