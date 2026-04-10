-- Decompiled by your's lovely (stav)
local v_u_1 = {
	["RootName"] = "ClientRuntime",
	["SurfaceFolderName"] = "CombatAssist",
	["RemoteNames"] = {
		["Handshake"] = "Handshake",
		["Configure"] = "Configure",
		["Execute"] = "Execute",
		["Pulse"] = "Pulse",
		["Sync"] = "Sync"
	},
	["ActionNames"] = {
		["Attack"] = "attack",
		["PlaceBlock"] = "placeBlock",
		["BreakBlock"] = "breakBlock"
	},
	["StudsPerBlock"] = 3
}
local v_u_2 = {
	["combatReach"] = {
		["default"] = 3,
		["min"] = 1,
		["max"] = 10,
		["rule"] = "combatReach",
		["aliases"] = {
			"reach",
			"combat",
			"combatreach",
			"meleereach"
		}
	},
	["blockReach"] = {
		["default"] = 5,
		["min"] = 1,
		["max"] = 10,
		["rule"] = "blockReach",
		["aliases"] = {
			"blockreach",
			"buildreach",
			"placereach",
			"minereach"
		}
	}
}
v_u_1.Keys = {}
local v_u_3 = {
	["attack"] = v_u_1.ActionNames.Attack,
	["place"] = v_u_1.ActionNames.PlaceBlock,
	["placeblock"] = v_u_1.ActionNames.PlaceBlock,
	["build"] = v_u_1.ActionNames.PlaceBlock,
	["break"] = v_u_1.ActionNames.BreakBlock,
	["breakblock"] = v_u_1.ActionNames.BreakBlock,
	["mine"] = v_u_1.ActionNames.BreakBlock,
	["mineblock"] = v_u_1.ActionNames.BreakBlock
}
local v_u_4 = {}
local v_u_5 = { "reach", "combatReach", "blockReach" }
for v6, v7 in pairs(v_u_2) do
	v_u_1.Keys[v6] = true
	local v8
	if type(v6) == "string" and v6 ~= "" then
		v8 = string.lower((string.gsub(v6, "[^%w]", "")))
	else
		v8 = nil
	end
	v_u_4[v8] = v6
	for _, v9 in ipairs(v7.aliases or {}) do
		local v10
		if type(v9) == "string" and v9 ~= "" then
			v10 = string.lower((string.gsub(v9, "[^%w]", "")))
		else
			v10 = nil
		end
		v_u_4[v10] = v6
	end
end
function v_u_1.CloneTable(p11) -- name: CloneTable
	local v12 = {}
	if type(p11) ~= "table" then
		return v12
	end
	for v13, v14 in pairs(p11) do
		v12[v13] = v14
	end
	return v12
end
function v_u_1.GetDefinition(p15) -- name: GetDefinition
	-- upvalues: (copy) v_u_2
	return v_u_2[p15]
end
function v_u_1.GetSupportedMethods() -- name: GetSupportedMethods
	-- upvalues: (copy) v_u_5
	return table.clone(v_u_5)
end
function v_u_1.GetDefaultValue(p16) -- name: GetDefaultValue
	-- upvalues: (copy) v_u_2
	local v17 = v_u_2[p16]
	return v17 and v17.default or nil
end
function v_u_1.GetRuleName(p18) -- name: GetRuleName
	-- upvalues: (copy) v_u_2
	local v19 = v_u_2[p18]
	return v19 and v19.rule or nil
end
function v_u_1.GetDefaultState() -- name: GetDefaultState
	-- upvalues: (copy) v_u_2
	local v20 = {}
	for v21, v22 in pairs(v_u_2) do
		v20[v21] = v22.default
	end
	return v20
end
function v_u_1.NormalizeMethod(p23) -- name: NormalizeMethod
	-- upvalues: (copy) v_u_4
	local v24 = v_u_4
	local v25
	if type(p23) == "string" and p23 ~= "" then
		v25 = string.lower((string.gsub(p23, "[^%w]", "")))
	else
		v25 = nil
	end
	return v24[v25]
end
function v_u_1.NormalizeAction(p26) -- name: NormalizeAction
	-- upvalues: (copy) v_u_3
	local v27 = v_u_3
	local v28
	if type(p26) == "string" and p26 ~= "" then
		v28 = string.lower((string.gsub(p26, "[^%w]", "")))
	else
		v28 = nil
	end
	return v27[v28]
end
function v_u_1.BuildAttackPayload(p29) -- name: BuildAttackPayload
	-- upvalues: (copy) v_u_1
	local v30 = {
		["action"] = v_u_1.ActionNames.Attack
	}
	if typeof(p29) == "Instance" then
		if p29:IsA("Player") then
			v30.target = p29
			v30.targetName = p29.Name
			v30.targetUserId = p29.UserId
			v30.targetType = "player"
			return v30
		end
		if p29:IsA("Model") then
			v30.target = p29
			v30.targetName = p29.Name
			v30.targetType = "model"
			return v30
		end
		if p29:IsA("BasePart") then
			v30.target = p29
			v30.targetName = p29.Name
			v30.targetType = "part"
			return v30
		end
	end
	if type(p29) ~= "string" or p29 == "" then
		return v30
	end
	v30.targetName = p29
	v30.targetType = "name"
	return v30
end
function v_u_1.BuildPlaceBlockPayload(p31) -- name: BuildPlaceBlockPayload
	-- upvalues: (copy) v_u_1
	local v32 = {
		["action"] = v_u_1.ActionNames.PlaceBlock
	}
	if type(p31) == "string" and p31 ~= "" then
		v32.blockType = p31
		return v32
	end
	if type(p31) == "boolean" then
		v32.forceOffhand = p31
		return v32
	end
	if type(p31) ~= "table" then
		return v32
	end
	if p31.forceOffhand == true or p31.offhand == true then
		v32.forceOffhand = true
	end
	local v33 = p31.hand
	if type(v33) == "string" and v33 ~= "" then
		v32.hand = v33
	end
	local v34 = p31.blockType or (p31.blockName or p31.itemName)
	if type(v34) == "string" and v34 ~= "" then
		v32.blockType = v34
	end
	return v32
end
function v_u_1.BuildBreakBlockPayload(_) -- name: BuildBreakBlockPayload
	-- upvalues: (copy) v_u_1
	return {
		["action"] = v_u_1.ActionNames.BreakBlock
	}
end
function v_u_1.ResolveExecutePayload(p35) -- name: ResolveExecutePayload
	-- upvalues: (copy) v_u_1
	local v36 = nil
	local v37 = nil
	local v38 = nil
	local v39 = nil
	local v40 = nil
	local v41 = nil
	local v42 = nil
	if type(p35) == "string" then
		v36 = v_u_1.NormalizeAction(p35)
	elseif type(p35) == "table" then
		v36 = v_u_1.NormalizeAction(p35.action or (p35.method or p35.type or (p35.name or p35.signal)))
		v40 = (p35.forceOffhand == true or p35.offhand == true) and true or v40
		local v43 = p35.hand
		if type(v43) == "string" and p35.hand ~= "" then
			v41 = p35.hand
		end
		local v44 = p35.blockType
		if type(v44) == "string" and p35.blockType ~= "" then
			v42 = p35.blockType
		else
			local v45 = p35.blockName
			if type(v45) == "string" and p35.blockName ~= "" then
				v42 = p35.blockName
			else
				local v46 = p35.itemName
				if type(v46) == "string" and p35.itemName ~= "" then
					v42 = p35.itemName
				end
			end
		end
		local v47 = p35.target or (p35.player or p35.targetPlayer or (p35.victim or p35.arg))
		if typeof(v47) == "Instance" then
			if v47:IsA("Player") then
				v37 = v47.Name
				v38 = v47.UserId
				v39 = "player"
			elseif v47:IsA("Model") then
				v37 = v47.Name
				v39 = "model"
			elseif v47:IsA("BasePart") then
				v37 = v47.Name
				v39 = "part"
			end
		elseif type(v47) == "string" and v47 ~= "" then
			v37 = v47
			v39 = "name"
		else
			local v48 = p35.targetName
			if type(v48) == "string" and p35.targetName ~= "" then
				v37 = p35.targetName
				local v49 = p35.targetType
				v39 = type(v49) == "string" and (p35.targetType or "name") or "name"
			end
			local v50 = p35.targetUserId
			if type(v50) == "number" then
				v38 = p35.targetUserId
			end
		end
	end
	return v36, {
		["targetName"] = v37,
		["targetUserId"] = v38,
		["targetType"] = v39,
		["forceOffhand"] = v40,
		["hand"] = v41,
		["blockType"] = v42
	}
end
function v_u_1.NormalizeValue(p51, p52) -- name: NormalizeValue
	-- upvalues: (copy) v_u_2
	local v53 = v_u_2[p51]
	if not v53 then
		return nil, "unknown_method"
	end
	if p52 == nil then
		return nil, nil
	end
	local v54 = tonumber(p52)
	if not v54 then
		return nil, "invalid_value"
	end
	local v55 = v53.min
	local v56 = v53.max
	return math.clamp(v54, v55, v56), nil
end
function v_u_1.ResolvePayload(p57) -- name: ResolvePayload
	-- upvalues: (copy) v_u_1
	local v58 = nil
	local v59 = nil
	local v60 = false
	if type(p57) == "number" then
		v59 = p57
		v58 = "combatReach"
	elseif type(p57) == "string" then
		v58 = v_u_1.NormalizeMethod(p57)
		v60 = v58 ~= nil
	elseif type(p57) == "table" then
		local v61 = v_u_1.NormalizeMethod(p57.method or (p57.key or p57.name or (p57.setting or p57.type)))
		v58 = v61 or (p57.combatReach ~= nil and "combatReach" or (p57.blockReach ~= nil and "blockReach" or (p57.reach ~= nil and "combatReach" or v61)))
		v59 = p57.value
		if v59 == nil then
			if v58 == "combatReach" and p57.combatReach ~= nil then
				v59 = p57.combatReach
			elseif v58 == "blockReach" and p57.blockReach ~= nil then
				v59 = p57.blockReach
			else
				v59 = p57.blocks or p57.distance or (p57.reach or p57.amount)
			end
		end
		v60 = (p57.reset == true or p57.clear == true) and true or p57.enabled == false
		if v59 == nil and (not v60 and v58 ~= nil) then
			v60 = true
		end
	end
	if v58 then
		if v60 then
			return v58, nil, true, nil
		else
			local v62, v63 = v_u_1.NormalizeValue(v58, v59)
			if v63 then
				return nil, nil, false, v63
			else
				return v58, v62, false, nil
			end
		end
	else
		return nil, nil, false, "unknown_method"
	end
end
function v_u_1.BuildSnapshot(p64, p65) -- name: BuildSnapshot
	-- upvalues: (copy) v_u_1
	local v66 = {
		["ready"] = true,
		["supported"] = v_u_1.GetSupportedMethods()
	}
	local v67 = {}
	if type(p64) == "table" then
		for v68, v69 in pairs(p64) do
			v67[v68] = v69
		end
	end
	v66.values = v67
	local v70 = {}
	if type(p65) == "table" then
		for v71, v72 in pairs(p65) do
			v70[v71] = v72
		end
	end
	v66.overrides = v70
	return v66
end
return v_u_1
