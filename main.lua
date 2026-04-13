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

local ids = {
    blindshot = {118614517739521, 111176938448555},
	bridgeduel = {139566161526375},
	hoplex = {109668355806967}
	--bedfight = {71480482338212}
}

local queue_on_teleport = queue_on_teleport or (syn and syn.queue_on_teleport) or queueonteleport

local function downloadFile(file)
    url = file:gsub('koolaid/', '')
    if not isfile(file) then
        writefile(file, game:HttpGet('https://raw.githubusercontent.com/sstvskids/koolxtras/'..readfile('koolaid/commit.txt')..'/'..url))
    end

    repeat task.wait() until isfile(file)
    return readfile(file)
end

for i,v in ids do
    if table.find(v, game.PlaceId) then
        local suc, res = pcall(downloadFile, 'koolaid/games/'..i..'.lua')

        if not suc then
            return error('Failed to download file: '..debug.traceback(res))
        elseif res then
			shared.place = i
			loadstring(downloadFile('koolaid/interface/library.lua'))()

			repeat task.wait() until shared.Library
			shared.Library.Signal:newconn(lplr.OnTeleport, function()
				local teleportScript = [[
					return loadstring(game:HttpGet('https://raw.githubusercontent.com/sstvskids/koolxtras/'..readfile('koolaid/commit.txt')..'/main.lua'))()
				]]

				shared.Library.configSys:Save()
				queue_on_teleport(teleportScript)
			end)
            return loadstring(res)()
        end
    end
end
