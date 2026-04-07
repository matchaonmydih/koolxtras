local cloneref = cloneref or function(obj)
	return obj
end

local Services = setmetatable({}, {
	__index = function(self, obj)
		return cloneref(game:GetService(obj))
	end
})

local ReplicatedStorage = Services.ReplicatedStorage
local HttpService = Services.HttpService

return {
  Submode = HttpService:JSONDecode(ReplicatedStorage.Modules.ServerData.Cache.Value)
}
