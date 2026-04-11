--[[

    Credits to @Experience_Member and @SQLanguage on the DevForum for making hookfunction and hookmetamethod possible!
    Experience_Member: https://devforum.roblox.com/u/Experience_Member
    SQLanguage: https://devforum.roblox.com/u/SQLanguage

]]
repeat task.wait() until shared.Library ~= nil

local module = {
	requirejank = {
		properRequire = false,
		helper = {}
	},
	game = shared.place
}

local cloneref = cloneref or function(obj: Instance): Instance
	return obj
end

local Services = setmetatable({}, {
	__index = function(self, obj: Instance): Instance
		return cloneref(game:GetService(obj))
	end
})

local HttpService = Services.HttpService
local Players = Services.Players
local lplr = Players.LocalPlayer

local request = request or http.request

do
	type userdata = {}
	type _function = (...any) -> (...any)
	
	local Metatable = {
		metamethods = {
			__index = function(self, key)
				return self[key]
			end,
			__newindex = function(self, key, value)
				self[key] = value
			end,
			__call = function(self, ...)
				return self(...)
			end,
			__concat = function(self, b)
				return self..b
			end,
			__add = function(self, b)
				return self + b
			end,
			__sub = function(self, b)
				return self - b
			end,
			__mul = function(self, b)
				return self * b
			end,
			__div = function(self, b)
				return self / b
			end,
			__idiv = function(self, b)
				return self // b
			end,
			__mod = function(self, b)
				return self % b
			end,
			__pow = function(self, b)
				return self ^ b
			end,
			__tostring = function(self)
				return tostring(self)
			end,
			__eq = function(self, b)
				return self == b
			end,
			__lt = function(self, b)
				return self < b
			end,
			__le = function(self, b)
				return self <= b
			end,
			__len = function(self)
				return #self
			end,
			__iter = function(self)
				return next, self
			end,
			__namecall = function(self, ...)
				return self:_(...)
			end,
			__metatable = function(self)
				return getmetatable(self)
			end
		}
	}
	
	-- methods
	function Metatable.get_L_closure(metamethod: string, obj: {any} | userdata)
		local hooked
		local metamethod_emulator = Metatable.metamethods[metamethod]
		
		xpcall(function()
			metamethod_emulator(obj)
		end, function()
			hooked = debug.info(2, "f")
		end)
		
		return hooked
	end
	
	function Metatable.get_all_L_closures(obj: {any} | userdata)
		local metamethods = {}
		local innacurate = {}
	
		for method, _ in Metatable.metamethods do
			local metamethod, accurate = Metatable.get_L_closure(method, obj)
			metamethods[method] = metamethod
		end
	
		return metamethods
	end
	
	function Metatable.metahook(t: any, f: _function)
		local metahook = {
			__Metatable = getmetatable(t) or "The metatable is locked"
		}
	
		for metamethod, value in Metatable.metamethods do
			metahook[metamethod] = function(self, ...)
				f(metamethod, ...)
				
				if metamethod == "__tostring" then
					return ""
				elseif metamethod == "__len" then
					return math.random(0, 1024)
				end
				
				return Metatable.metahook({}, f) 
			end
		end
	
		return setmetatable({}, metahook)
	end
	
	local scheduled_tasks = {}
	
	task.spawn(function()
		while task.wait() do
			for i, new_task in scheduled_tasks do
				scheduled_tasks[i] = nil
				
				task.spawn(new_task)
			end
		end
	end)
	
	--// Main
	module.hook = hookfunction or hook_function or hookfunc or function(old, new)
		if debug.info(old, "s") == "[C]" then
			local name = debug.info(old, "n")
			
			return function(...)
				return old(...)
			end
		else
	
			local last_trace
			
			local function execute_hook()
				if new then
					local current_trace = {
						debug.info(3, "l"), debug.info(3, "s"), debug.info(3, "n"), debug.traceback()
					}
					
					local equal = true
					for i, v in last_trace or {} do
						if current_trace[i] ~= v then
							equal = false
						end
					end
					
					if not equal or not last_trace then
						if run_on_seperate_thread then
							table.insert(scheduled_tasks, coroutine.wrap(new))
						else
							new()
						end
					end
					
					return current_trace
				end
			end
			
			local function wrap()
				local hooks = {}
				
				for metamethod in Metatable.metamethods do
					hooks[metamethod] = function(self, ...)
						local f = debug.info(2, "f")
	
						if f == old then
							last_trace = execute_hook()
						end
						
						if metamethod == "__len" then
							return 3
						elseif metamethod == "__tostring" then
							return tostring(getfenv(0))
						end
						
						return wrap()
					end
				end
				
				return setmetatable({}, hooks)
			end
			
			local environment = wrap()
			setfenv(old, environment)
			
			return function(...)
				local return_value = {old(...)}
				
				while not return_value do task.wait() end
				setfenv(old, wrap()) -- insert new hook once old gets executed
				
				return unpack(return_value)
			end
		end
	end
	
	module.hookmetamethod = hookmetamethod or function(obj, metamethod, func)
		local rmt = Metatable.get_all_L_closures(obj)
		local mt = getmetatable(obj)
	
		local old = rmt[metamethod]
		local is_writable = pcall(function()
			mt[random(math.random(128, 512))] = nil 
		end)
	
		if is_writable then
			mt[method] = hook
		else
			local old_environment = getfenv(old)
			local is_hookable = pcall(setfenv, old, old_environment)
	
			if is_hookable then
				return module.hook(old, hook)
			else
				warn("unable to hook a non-hookable metatable")
			end
		end
	
		return old
	end
end

-- Require
local xenoPste
function module.requirejank:Test()
	if not require then return false end

	local suc, res = pcall(function()
		return require(lplr.PlayerScripts.PlayerModule).controls
	end)

	if xenoPste then
		self.properRequire = false
		return false
	end

	self.properRequire = suc and true or false
	return suc and true or false
end

function module.requirejank.helper:Fetch(file: string): string
	shared.Library:Notify('Fetching support file: '..file, 3)
	return loadstring(game:HttpGet('https://raw.githubusercontent.com/sstvskids/koolxtras/'..readfile('koolaid/commit.txt')..'/libraries/'..module.game..'/'..file..'.lua'))()
end

module.require = function(moduleScript: Instance): Instance
	local suc, res = pcall(function()
		return require(moduleScript)
	end)
	
	if suc and res ~= nil then
		return res
	end

	return module.requirejank.helper:Fetch(moduleScript.Parent.Name == 'Blink' and 'Blink' or moduleScript.Name)
end

do
	local res = request({
	    Url = 'https://httpbin.org/get',
	    Method = 'GET',
	    Headers = {
	        ['Content-Type'] = 'application/json'
	    }
	})
	
	if res.Success then
	    local data = HttpService:JSONDecode(res.Body)
	    for i,v in data.headers do
	        if string.find(i, 'Xeno') then
				xenoPste = true
				module.require = function(moduleScript: Instance): Instance
					return module.requirejank.helper:Fetch(moduleScript.Parent.Name == 'Blink' and 'Blink' or moduleScript.Name)
				end
	        end
	    end
	end
end

module.requirejank:Test()
return module
