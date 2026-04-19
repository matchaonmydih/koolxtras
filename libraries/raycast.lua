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

local raycast = {}
function raycast:CanSee(target, filter)
    local rayParams, res = RaycastParams.new(), nil
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = filter or {lplr.Character}
   	res = workspace:Raycast(lplr.Character.HumanoidRootPart.Position, target.Position - lplr.Character.HumanoidRootPart.Position, rayParams)
	
    if res and res.Instance and not target:IsAncestorOf(res.Instance) then
		return false
	end

	return true
end

function raycast:IfBlockUnderneath()
	local rayParams, res = RaycastParams.new(), nil
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {lplr.Character}
	res = workspace:Raycast(Vector3.new(lplr.Character.HumanoidRootPart.Position.X + lplr.Character.Humanoid.MoveDirection.X * (1 * 3), lplr.Character.HumanoidRootPart.Position.Y, lplr.Character.HumanoidRootPart.Position.Z + lplr.Character.Humanoid.MoveDirection.Z * (1 * 3)), Vector3.new(0, -6, 0), rayParams)

	if not res then
		return false
	end
	
	return true
end

return raycast
