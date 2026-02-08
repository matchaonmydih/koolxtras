--!native
--!optimize 2
--!strict

local module = {
	unc = {
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

function module.unc:Test()
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

local isfile = isfile or function(file)
	local suc, ret = pcall(function()
		return readfile(file)
	end)

	return suc and true or false
end

local load = load or loadstring or function(...)
	if not writefile or not loadfile or readfile then
		return function()
			return 'Failed to load str'
		end
	end

	writefile('tuogheihouegrtehrtoug', ...)
	repeat task.wait() until isfile('tuogheihouegrtehrtoug')

	return loadfile('tuogheihouegrtehrtoug')
end

function module.unc.helper:Fetch(file: string): string
	return load(game:HttpGet('https://raw.githubusercontent.com/sstvskids/koolxtras/refs/heads/main/libraries/'..module.game..'/'..file..'.lua'))()
end

module.unc.require = function(moduleScript: Instance): Instance
	return module.unc.properRequire and require(moduleScript) or module.unc.helper:Fetch(moduleScript.Parent.Name == 'Blink' and 'Blink' or moduleScript.Name)
end

return module
