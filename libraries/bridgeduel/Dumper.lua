--[[

    Decompile API/function provided by the Quartz developers
    Shout out to the Quartz developers :heart:

    Credits to @_vezt/hamza for the arguments dumper
]]

local cloneref = cloneref or function(obj)
	return obj
end

local Services = setmetatable({}, {
	__index = function(self, obj)
		return cloneref(game:GetService(obj))
	end
})

local HttpService = Services.HttpService
local Helper = {}

Helper.decompile = function(scriptPath: ModuleScript | LocalScript): string
    local okBytecode: boolean, bytecode: string = pcall(getscriptbytecode, scriptPath)

    if not okBytecode then
        return `-- Failed to get script bytecode, error:\n\n--[[\n{bytecode}\n--]]`
    end

    local okRequest: boolean, httpResult = pcall(request, {
        Url = "https://x2125.xyz/decompile",
        Method = "POST",
        Body = HttpService:JSONEncode({
            script = crypt.base64encode(bytecode),
            options = {
                renamingType = "INFER", -- "RAW" | "SEQUENTIAL" | "INFER"
                upvalueComment = true,
                lineDefinedComment = true
            },
        }),
        Headers = {
            ["Content-Type"] = "application/json"
        },
    })

    if not okRequest then
        return `-- Failed to decompile, error:\n\n--[[\n{httpResult}\n--]]`
    end

    if httpResult.StatusCode ~= 200 then
        return `-- Error occurred while requesting the API, error:\n\n--[[\n{httpResult.Body}\n--]]`
    end

    local JSON = HttpService:JSONDecode(httpResult.Body)
    return string.gsub(JSON.data, string.char(0x00CD), " ")
end

Helper.dump = function(source, sandboxEnv)
    sandboxEnv = sandboxEnv or {}
    local results, pattern = {}, source:match('%[%s*"extra"%s*%]%s*=%s*(%b{})')
    if not pattern then return nil end

    local function eval(str)
        local chunk, err = loadstring('return '..str)
        if not chunk then return nil end

        setfenv(chunk, setmetatable(sandboxEnv, {__index = getfenv()}))
        local suc, res = pcall(chunk)
        
        if suc then
            return res
        end
        
        return nil
    end

    local function isQuotedString(s)
        return s:match('^".*"$') or s:match("^'.*'$")
    end

    for key, value in pattern:gmatch('%["(.-)"%]%s*=%s*(.-)[,%}]') do
        value = value:match("^%s*(.-)%s*$")
        
        if isQuotedString(value) then
            results[key] = value:sub(2, -2)
        else
            results[key] = eval(value)
        end
    end

    return results
end

return Helper