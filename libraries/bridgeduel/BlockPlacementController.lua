local cloneref = cloneref or function(obj)
    return obj
end

local Services = setmetatable({}, {
    __index = function(self, obj)
        return cloneref(game:GetService(obj))
    end
})

local ReplicatedStorage = Services.ReplicatedStorage
return {
    PlaceBlock = function(self, position, blocktype)
        local fake = ReplicatedStorage.Assets.Blocks[blocktype]:Clone()
        fake.Name = 'TempBlock'
        fake.Position = position
        fake:AddTag('TempBlock')
        fake:AddTag('Block')

        ReplicatedStorage.Modules.Knit.Services.ToolService.RF.PlaceBlock:InvokeServer(position)
        fake:Destroy()
    end
}