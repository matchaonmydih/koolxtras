local cloneref = cloneref or function(obj)
	return obj
end

local Services = setmetatable({}, {
	__index = function(self, obj)
		return cloneref(game:GetService(obj))
	end
})

local ReplicatedStorage = Services.ReplicatedStorage
local Workspace = Services.Workspace

-- Viewmodel: Workspace.CurrentCamera:WaitForChild('ViewModel').ViewModelHumanoid.Animator
local Viewmodel = {
    Animation = ReplicatedStorage.Assets.Animations.HitAnimation
}

return Viewmodel
