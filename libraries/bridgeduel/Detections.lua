local cloneref = cloneref or function(obj)
	return obj
end

local Services = setmetatable({}, {
	__index = function(self, obj)
		return cloneref(game:GetService(obj))
	end
})

local MarketplaceService = Services.MarketplaceService
local ReplicatedStorage = Services.ReplicatedStorage

local function downloadFile(file)
    url = file:gsub('koolaid/', '')
    if not isfile(file) then
        writefile(file, game:HttpGet('https://raw.githubusercontent.com/sstvskids/koolxtras/'..readfile('koolaid/commit.txt')..'/'..url))
    end

    repeat task.wait() until isfile(file)
    return readfile(file)
end

local Crypt = loadstring(downloadFile('koolaid/libraries/Crypt.lua'))()

local Detections = {
    Paths = {
        SendReport = ReplicatedStorage.Modules.Knit.Services.NetworkService.RF.SendReport,
        Client = {
            Sword = ReplicatedStorage.Client.Components.All.Tools.SwordClient,
            Block = ReplicatedStorage.Client.Controllers.All.BlockPlacementController
        }
    },
    Hashes = {
        Sword = '3A02ACDE20E4CAD9918CBD4206D510B59C438ABBFB682AB1EC8606FD984D30EC5D1D0430E988E812F71BCAA0004C8458',
        Block = 'DA04A5C02AF37ED9D2C6485CCFADEE2C1CDE6E035E2E3BCB2DD2F527886768F18EF3E5CF52A342924DBADEBFD1A9117E'
    },
	Logs = {
    	Game = {
    	    Name = MarketplaceService:GetProductInfo(game.PlaceId).Name,
    		GameId = game.GameId,
    		PlaceId = game.PlaceId
    	}
	},
    Count = 0
}

local function getscripthash(path: Instance)
	if not path then return nil end
	if not getscriptbytecode then return nil end

	local bytecode = getscriptbytecode(path)
	if not bytecode then return nil end

	return Crypt.sha384(bytecode):upper()
end

function Detections:test(typee)
	if typee == 'hash' and getscripthash then
		if getscripthash(Detections.Paths.Client.Sword) ~= Detections.Hashes.Sword then
	        Detections.Count += 1
			Detections.Logs.SwordH = {
			    Reason = 'SwordClient hash was not the same (Dev\'s potentially changed hash -- report to kool aid devs)',
				Hash = getscripthash(Detections.Paths.Client.Sword),
				OriginalHash = Detections.Hashes.Sword
			}
	    end

		if getscripthash(Detections.Paths.Client.Block) ~= Detections.Hashes.Block then
	        Detections.Count += 1
			Detections.Logs.BlockH = {
			    Reason = 'BlockPlacementController Hash was not the same (Dev\'s potentially changed hash -- report to kool aid devs)',
				Hash = getscripthash(Detections.Paths.Client.Block),
				OriginalHash = Detections.Hashes.Block
			}
	    end
	end
end

return Detections
