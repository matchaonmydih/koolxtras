local cloneref = cloneref or function(obj)
	return obj
end

local Services = setmetatable({}, {
	__index = function(self, obj)
		return cloneref(game:GetService(obj))
	end
})

local ReplicatedStorage = Services.ReplicatedStorage
local Players = Services.Players
local lplr = Players.LocalPlayer

local Entity = {
    FindByPlayer = function(plr)
        for _, v in ReplicatedStorage.Modules.Knit.Services.EntityService.RF.GetEntities:InvokeServer() do
            if v.Player == plr then
                return v
            end
        end
        
        return nil
    end,
    FindByCharacter = function(char)
        for _, v in ReplicatedStorage.Modules.Knit.Services.EntityService.RF.GetEntities:InvokeServer() do
            if v.Character == char then
                return v
            end
        end
        
        return nil
    end
}

Entity.LocalEntity = Entity.FindByPlayer(lplr)
return Entity
