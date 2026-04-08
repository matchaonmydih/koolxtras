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
	bridgeduel = {139566161526375}
}

local function downloadFile(file)
    url = file:gsub('koolaid/', '')
    if not isfile(file) then
        writefile(file, game:HttpGet('https://raw.githubusercontent.com/sstvskids/koolxtras/'..readfile('koolaid/commit.txt')..'/'..url))
    end

    repeat task.wait() until isfile(file)
    return readfile(file)
end

if identifyexecutor then
	if string.find(string.lower(({identifyexecutor()})[1]), 'jjsploit') or string.find(string.lower(({identifyexecutor()})[1]), 'bytebreaker') then
		getgenv().identifyexecutor = function()
			return 'Xeno'
		end
	end

	if table.find({'Xeno', '5.0'}, ({identifyexecutor()})[1]) or not (debug.getupvalue or debug.getupvalues or debug.getproto or debug.getconstants or hookfunction or hookmetamethod or getconnections or require) then
		shared.badexecs = true
	end

	if require then
    	local suc = pcall(function() return require(lplr.PlayerScripts.PlayerModule).controls end)

    	if not suc then
    		shared.badexecs = true
    	end
    end
end

for i,v in ids do
    if table.find(v, game.PlaceId) then
        local suc, res = pcall(downloadFile, 'koolaid/games/'..i..'.lua')

        if not suc then
            return error('Failed to download file: '..debug.traceback(res))
        elseif res then
			shared.place = i

			loadstring(downloadFile('koolaid/interface/library.lua'))()
            return loadstring(res)()
        end
    end
end
