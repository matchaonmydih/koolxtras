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
   	local res = workspace:Raycast(lplr.Character.HumanoidRootPart.Position, target.Position - lplr.Character.HumanoidRootPart.Position, rayParams)
	
    return (res and res.Instance and not target:IsAncestorOf(res.Instance)) and false or true
end

return raycast
