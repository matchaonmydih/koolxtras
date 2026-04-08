local cloneref = cloneref or function(obj)
	return obj
end

local Services = setmetatable({}, {
	__index = function(self, obj)
		return cloneref(game:GetService(obj))
	end
})

local ReplicatedStorage = Services.ReplicatedStorage

local Detections = {
    Paths = {
        SendReport = ReplicatedStorage.Modules.Knit.Services.NetworkService.RF.SendReport,
        Client = {
            Sword = ReplicatedStorage.Client.Components.All.Tools.SwordClient,
            Block = ReplicatedStorage.Client.Controllers.All.BlockPlacementController
        }
    },
	Logs = {},
    Count = 0
}

function Detections:test(typee)
	if typee == 'hash' and getscripthash then
		if getscripthash(Detections.Paths.Client.Sword) ~= '16D1A471E2AF4F32DA974993CF13D7ACA4EB8BB15B3C7C31E494F02DB0D323A3' then
	        Detections.Count += 1
			Detections.Logs.SwordH = 'SwordClient hash was not the same (Dev\'s changed the hash -- report this to kool aid devs)'
	    end

		if getscripthash(Detections.Paths.Client.Block) ~= '0A18604C086353174AC08ED5922985BC5CB111675EE654B8A67D77EA9700B8E6' then
	        Detections.Count += 1
			Detections.Logs.BlockH = 'BlockPlacementController Hash was not the same (Dev\'s changed the hash -- report this to kool aid devs)'
	    end
	end
end

return Detections
