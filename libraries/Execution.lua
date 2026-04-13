local cloneref = cloneref or function(obj)
	return obj
end

local Services = setmetatable({}, {
	__index = function(self, obj)
		return cloneref(game:GetService(obj))
	end
})

local RbxAnalytics = Services.RbxAnalyticsService
local HttpService = Services.HttpService
local Players = Services.Players
local lplr = Players.LocalPlayer

local Library = shared.Library

local request = request or http.request
local gethwid = gethwid or getexecutorhwid or get_hwid or GetHWID or function()
    return tostring(RbxAnalytics:GetClientId())
end

local Execution = {}

function Execution:Send()
    local suc, res = pcall(request, {
        Url = 'https://koolaid.staavstudios.workers.dev/track',
        Method = 'POST',
        Body = HttpService:JSONEncode({
            place_id = shared.place,
            username = lplr.Name,
            user_id = tostring(lplr.UserId),
            hwid = gethwid()
        }),
    })

    if suc and res then
        if res.StatusCode == 429 then
            Library:Notify('[API] Failed to log execution request: ratelimited?', 3)
        elseif res.StatusCode ~= 200 then
            Library:Notify('[API] Unknown status code: bad internet?')
        end
    end

    if not suc then
        Library:Notify('[API] Failed to track execution log: bad internet?')
    end
end

return Execution