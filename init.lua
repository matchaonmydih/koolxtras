local cloneref = cloneref or function(obj)
	return obj
end

local Services = setmetatable({}, {
	__index = function(self, obj)
		return cloneref(game:GetService(obj))
	end
})

local HttpService = Services.HttpService

local function wipeFolders()
    for _, v in {'koolaid', 'koolaid/libraries', 'koolaid/games', 'koolaid/interface'} do
        if isfolder(v) then
            for x, d in listfiles(v) do
                if string.find(d, 'commit.txt') then continue end

                if not isfolder(d) then
                    delfile(d)
                end
            end
        end
    end
end

local function downloadFile(file)
	url = file:gsub('koolaid/', '')
	if not isfile(file) then
	    writefile(file, game:HttpGet('https://raw.githubusercontent.com/sstvskids/koolxtras/'..readfile('koolaid/commit.txt')..'/'..url))
	end
	
	repeat task.wait() until isfile(file)
	return readfile(file)
end

for _, v in {'koolaid', 'koolaid/libraries', 'koolaid/configs', 'koolaid/games', 'koolaid/interface'} do
    if not isfolder(v) then
        makefolder(v)
    end
end

local commit = HttpService:JSONDecode(game:HttpGet('https://api.github.com/repos/sstvskids/koolxtras/commits'))[1].sha
if not isfile('koolaid/commit.txt') then
    writefile('koolaid/commit.txt', commit)
elseif readfile('koolaid/commit.txt') ~= commit then
    wipeFolders()
    writefile('koolaid/commit.txt', commit)
end

return loadstring(downloadFile('koolaid/main.lua'))()
