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

local raycast = loadfile('koolaid/libraries/raycast.lua')()

local entity = {
    tool = {}
}

function entity.isAlive(plr)
    local obj
	if plr:IsA('Model') then
		obj = {
			Character = plr
		}
	else
		obj = plr
	end

	return (obj.Character and obj.Character:FindFirstChild('Humanoid') and obj.Character.Humanoid.Health > 0) and true or false
end

function entity:GetClosestPlayer(range, angle, wallcheck)
    local minrnge, entity = range, nil

	for i,v in Players:GetPlayers() do
	    if v ~= lplr and self.isAlive(lplr) and self.isAlive(v) then
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

function entity.tool.getTool(plr)
    return plr.Character and plr.Character:FindFirstChildOfClass('Tool') or nil
end

function entity.tool.hasTool(plr, tool)
    --print(plr)
    --print(tool)

    --print(plr.Character:FindFirstChild(tool))
    return plr.Character and plr.Character:FindFirstChild(tool) or nil
end

function entity.tool.hasToolInv(plr, tool)
    return plr.Backpack and plr.Backpack:FindFirstChild(tool) or nil
end

return entity
