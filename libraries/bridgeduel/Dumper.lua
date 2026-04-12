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
        Url = "https://luadec.metaworm.site/",
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
            ["Content-Type"] = "text/plain"
        },
    })

    HttpService:JSONEncode({
        script = crypt.base64encode(bytecode),
        options = {
            renamingType = "INFER", -- "RAW" | "SEQUENTIAL" | "INFER"
            upvalueComment = true,
            lineDefinedComment = true
        },
    })

    if not okRequest then
        return `-- Failed to decompile, error:\n\n--[[\n{httpResult}\n--]]`
    end

    if httpResult.StatusCode ~= 200 then
        return `-- Error occurred while requesting the API, error:\n\n--[[\n{httpResult.Body}\n--]]`
    end

    return string.gsub(httpResult.Body, string.char(0x00CD), " ")
end

Helper.dump = function(source)
    print(source)
    local results, pattern = {}, string.format('%%["%s"%%]%%s*=%%s*(%%b{})', 'extra')

    local raw = source:match(pattern)
    if not raw then return results end

    local function sandboxEnv(expr)
        local chunk = loadstring('return '..expr)
        if not chunk then return nil end

        setfenv(chunk, {workspace = workspace})
        local suc, res = pcall(chunk)
        
        if suc and res ~= nil then
            return res
        end
        
        return nil
    end

    local function isQuotedString(s)
        return s:match('^".*"$') or s:match("^'.*'$")
    end

    for key, value in raw:gmatch('%["(.-)"%]%s*=%s*(.-)[,%}]') do
        value = value:match("^%s*(.-)%s*$")
        if isQuotedString(value) then
            results[key] = value:sub(2, -2)
        else
            results[key] = sandboxEnv(value)
        end
    end

    return results
end

return Helper