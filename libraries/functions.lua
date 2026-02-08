--[[
    Credits to the @renderintents team over on github for making the hook functionality work in luau

    https://github.com/renderintents
    https://github.com/renderintents/Render/blob/main/libraries/utils.luau
]]

local module = {
	requirejank = {
		properRequire = false,
		helper = {}
	},
	game = ''
}

local cloneref = cloneref or function(obj: Instance): Instance
	return obj
end

local Services = setmetatable({}, {
	__index = function(self, obj: Instance): Instance
		return cloneref(game:GetService(obj))
	end
})

local Players = Services.Players
local lplr = Players.LocalPlayer

module.isfile = isfile or function(file: string): string
	local suc, ret = pcall(function()
		return readfile(file)
	end)

	return suc and true or false
end

module.loadstring = load or loadstring or function(...)
	if not writefile or not loadfile or readfile then
		return function()
			return 'Failed to load str'
		end
	end

	writefile('tuogheihouegrtehrtoug', ...)
	repeat task.wait() until isfile('tuogheihouegrtehrtoug')

	return loadfile('tuogheihouegrtehrtoug')
end
module.load = module.loadstring

module.hook = hookfunction or hookfunc or hook_function or function(old, new)
    pcall(function()
        getfenv()[debug.info(old, 'n')] = new
    end)
end

module.restorefunc = restorefunction or restorefunc or restore_function or function(func)
    module.hook(func, func)
end

-- Require
function module.requirejank:Test()
	if not require then return false end

	local suc, res = pcall(function()
		return require(lplr.PlayerScripts.PlayerModule).controls
	end)

	if ({identifyexecutor()})[1] == 'Xeno' then
		self.properRequire = false
		return false
	end

	self.properRequire = suc and true or false
	return suc and true or false
end

function module.requirejank.helper:Fetch(file: string): string
	return load(game:HttpGet('https://raw.githubusercontent.com/sstvskids/koolxtras/refs/heads/main/libraries/'..module.game..'/'..file..'.lua'))()
end

module.require = function(moduleScript: Instance): Instance
	return module.requirejank.properRequire and require(moduleScript) or module.requirejank.helper:Fetch(moduleScript.Parent.Name == 'Blink' and 'Blink' or moduleScript.Name)
end

module.requirejank:Test()

return module
