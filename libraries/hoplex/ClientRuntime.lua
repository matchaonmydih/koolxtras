-- Decompiled by your's lovely (stav)
local cloneref = cloneref or function(obj) return obj end
local v_u_1 = cloneref(game:GetService("ReplicatedStorage"))
local Functions = loadfile('koolaid/libraries/functions.lua')()
local v_u_6 = Functions.require(v_u_1.Shared.ClientRuntime.Definitions)

local v_u_7 = {}
for v8, v9 in pairs(v_u_6) do
	v_u_7[v8] = v9
end
local v_u_10 = nil
local v_u_11 = false
local v_u_12 = false
local v_u_13 = false
local v_u_14 = false
local v_u_15 = false
local v_u_16 = {}
local v_u_17 = {
	["ready"] = false,
	["values"] = v_u_6.GetDefaultState(),
	["overrides"] = {},
	["supported"] = v_u_6.GetSupportedMethods()
}
local v_u_18 = {}
local function v_u_24() -- name: getGameruleCache
	-- upvalues: (ref) v_u_10, (ref) v_u_11, (copy) v_u_1
	if v_u_10 then
		return v_u_10
	end
	if v_u_11 then
		return nil
	end
	local v19 = v_u_1:FindFirstChild("Client")
	if not v19 then
		return nil
	end
	local v20 = v19:FindFirstChild("Services")
	if not v20 then
		return nil
	end
	local v21 = v20:FindFirstChild("GameruleCache")
	if not v21 then
		return nil
	end
	local v22, v23 = pcall(require, v21)
	if v22 and v23 then
		v_u_10 = v23
	end
	v_u_11 = true
	return v_u_10
end
local function v_u_30(p25) -- name: getBaseValue
	-- upvalues: (copy) v_u_24, (copy) v_u_6
	local v_u_26 = v_u_24()
	local v_u_27 = v_u_6.GetRuleName(p25)
	if v_u_26 and (v_u_27 and v_u_26.Get) then
		local v28, v29 = pcall(function()
			-- upvalues: (copy) v_u_26, (copy) v_u_27
			return v_u_26:Get(v_u_27)
		end)
		if v28 and type(v29) == "number" then
			return v29
		end
	end
	return v_u_6.GetDefaultValue(p25)
end
local function v_u_36(p31, p_u_32) -- name: setStateValue
	-- upvalues: (copy) v_u_17, (copy) v_u_18
	local v_u_33 = v_u_17.values[p31]
	if v_u_33 == p_u_32 then
		v_u_17.values[p31] = p_u_32
		return
	else
		v_u_17.values[p31] = p_u_32
		local v34 = v_u_18[p31]
		if v34 then
			for _, v_u_35 in ipairs(v34) do
				task.spawn(function()
					-- upvalues: (copy) v_u_35, (copy) p_u_32, (copy) v_u_33
					v_u_35(p_u_32, v_u_33)
				end)
			end
		end
	end
end
local function v_u_38() -- name: refreshBaseValues
	-- upvalues: (copy) v_u_6, (copy) v_u_17, (copy) v_u_36, (copy) v_u_30
	for v37 in pairs(v_u_6.Keys) do
		if v_u_17.overrides[v37] == nil then
			v_u_36(v37, v_u_30(v37))
		end
	end
end
local function v_u_44() -- name: bindGameruleSubscriptions
	-- upvalues: (ref) v_u_12, (copy) v_u_24, (copy) v_u_6, (copy) v_u_17, (copy) v_u_36
	if not v_u_12 then
		local v39 = v_u_24()
		if v39 then
			local v40 = v39.OnChanged
			if type(v40) == "function" then
				for v_u_41 in pairs(v_u_6.Keys) do
					local v42 = v_u_6.GetRuleName(v_u_41)
					if v42 then
						v39:OnChanged(v42, function(p43)
							-- upvalues: (ref) v_u_17, (copy) v_u_41, (ref) v_u_36
							if v_u_17.overrides[v_u_41] == nil then
								if type(p43) == "number" then
									v_u_36(v_u_41, p43)
								end
							end
						end)
					end
				end
				v_u_12 = true
				return
			end
		end
	end
end
local function v_u_53(p45) -- name: applySnapshot
	-- upvalues: (copy) v_u_6, (copy) v_u_30, (copy) v_u_17, (copy) v_u_36
	if type(p45) == "table" then
		local v46 = v_u_6.CloneTable(p45.overrides or {})
		local v47 = v_u_6.CloneTable(p45.values)
		for v48 in pairs(v_u_6.Keys) do
			if v47[v48] == nil then
				if v46[v48] == nil then
					v47[v48] = v_u_30(v48)
				else
					v47[v48] = v46[v48]
				end
			end
		end
		v_u_17.ready = p45.ready == true and true or v_u_17.ready
		local v49 = v_u_17
		local v50 = p45.supported
		local v51
		if type(v50) == "table" then
			v51 = table.clone(p45.supported)
		else
			v51 = v_u_17.supported
		end
		v49.supported = v51
		v_u_17.overrides = v46
		for v52 in pairs(v_u_6.Keys) do
			v_u_36(v52, v47[v52])
		end
	end
end
local function v_u_57() -- name: resolveRemotes
	-- upvalues: (ref) v_u_14, (copy) v_u_16, (copy) v_u_1, (copy) v_u_6, (ref) v_u_15, (copy) v_u_53
	if v_u_14 then
		return v_u_16
	end
	local v54 = v_u_1:FindFirstChild(v_u_6.RootName)
	if not v54 then
		return nil
	end
	local v55 = v54:FindFirstChild(v_u_6.SurfaceFolderName)
	if not v55 then
		return nil
	end
	v_u_16.folder = v55
	v_u_16.Handshake = v55:FindFirstChild(v_u_6.RemoteNames.Handshake)
	v_u_16.Configure = v55:FindFirstChild(v_u_6.RemoteNames.Configure)
	v_u_16.Execute = v55:FindFirstChild(v_u_6.RemoteNames.Execute)
	v_u_16.Pulse = v55:FindFirstChild(v_u_6.RemoteNames.Pulse)
	v_u_16.Sync = v55:FindFirstChild(v_u_6.RemoteNames.Sync)
	if not (v_u_16.Handshake and (v_u_16.Configure and (v_u_16.Execute and (v_u_16.Pulse and v_u_16.Sync)))) then
		return nil
	end
	v_u_14 = true
	if not v_u_15 and (v_u_16.Sync and v_u_16.Sync:IsA("RemoteEvent")) then
		v_u_15 = true
		v_u_16.Sync.OnClientEvent:Connect(function(p56)
			-- upvalues: (ref) v_u_53
			v_u_53(p56)
		end)
	end
	return v_u_16
end
local function v_u_60(p58) -- name: ensureTransport
	-- upvalues: (ref) v_u_14, (copy) v_u_57, (copy) v_u_44, (copy) v_u_38, (copy) v_u_17
	if not v_u_14 then
		if p58 == true then
			local v59 = tick() + 10
			while tick() <= v59 and not v_u_14 do
				v_u_57()
				if v_u_14 then
					break
				end
				task.wait(0.1)
			end
		else
			v_u_57()
		end
	end
	v_u_44()
	v_u_38()
	if v_u_14 then
		v_u_17.ready = true
	end
end
function v_u_7.Init() -- name: Init
	-- upvalues: (ref) v_u_13, (ref) v_u_14, (copy) v_u_57, (copy) v_u_44, (copy) v_u_38, (copy) v_u_17
	if v_u_13 then
		if not v_u_14 then
			v_u_57()
		end
		v_u_44()
		v_u_38()
		if v_u_14 then
			v_u_17.ready = true
		end
		return v_u_14
	end
	v_u_13 = true
	if not v_u_14 then
		v_u_57()
	end
	v_u_44()
	v_u_38()
	if v_u_14 then
		v_u_17.ready = true
	end
	return v_u_14
end
function v_u_7.IsReady() -- name: IsReady
	-- upvalues: (copy) v_u_7, (copy) v_u_17
	v_u_7.Init()
	return v_u_17.ready == true
end
function v_u_7.Get(p61, p62) -- name: Get
	-- upvalues: (copy) v_u_7, (copy) v_u_6, (copy) v_u_17, (copy) v_u_30
	v_u_7.Init()
	if p61 ~= v_u_7 then
		p62 = p61
	end
	local v63 = v_u_6.NormalizeMethod(p62) or p62
	if type(v63) == "string" then
		if v_u_17.values[v63] == nil then
			if v_u_17.overrides[v63] == nil then
				return v_u_30(v63)
			else
				return v_u_17.overrides[v63]
			end
		else
			return v_u_17.values[v63]
		end
	else
		return nil
	end
end
function v_u_7.GetAll() -- name: GetAll
	-- upvalues: (copy) v_u_7, (copy) v_u_6, (copy) v_u_17
	v_u_7.Init()
	return v_u_6.CloneTable(v_u_17.values)
end
function v_u_7.GetOverrides() -- name: GetOverrides
	-- upvalues: (copy) v_u_7, (copy) v_u_6, (copy) v_u_17
	v_u_7.Init()
	return v_u_6.CloneTable(v_u_17.overrides)
end
function v_u_7.Handshake(p64, p_u_65) -- name: Handshake
	-- upvalues: (copy) v_u_7, (copy) v_u_60, (copy) v_u_57, (copy) v_u_53
	v_u_7.Init()
	if p64 ~= v_u_7 then
		p_u_65 = p64
	end
	v_u_60(true)
	local v_u_66 = v_u_57()
	if not (v_u_66 and (v_u_66.Handshake and v_u_66.Handshake:IsA("RemoteFunction"))) then
		return false, "unavailable"
	end
	local v67, v68 = pcall(function()
		-- upvalues: (copy) v_u_66, (copy) p_u_65
		return v_u_66.Handshake:InvokeServer(p_u_65 or {})
	end)
	if not v67 then
		return false, v68
	end
	if type(v68) == "table" then
		local v69 = v68.state
		if type(v69) == "table" then
			v_u_53(v68.state)
		else
			v_u_53(v68)
		end
	end
	local v70
	if v68 then
		v70 = v68.ok ~= false
	else
		v70 = v68
	end
	return v70, v68
end
function v_u_7.Configure(p71, p_u_72) -- name: Configure
	-- upvalues: (copy) v_u_7, (copy) v_u_60, (copy) v_u_57, (copy) v_u_53
	v_u_7.Init()
	if p71 ~= v_u_7 then
		p_u_72 = p71
	end
	v_u_60(true)
	local v_u_73 = v_u_57()
	if not (v_u_73 and (v_u_73.Configure and v_u_73.Configure:IsA("RemoteFunction"))) then
		return false, "unavailable"
	end
	local v74, v75 = pcall(function()
		-- upvalues: (copy) v_u_73, (copy) p_u_72
		return v_u_73.Configure:InvokeServer(p_u_72)
	end)
	if not v74 then
		return false, v75
	end
	if type(v75) == "table" then
		local v76 = v75.state
		if type(v76) == "table" then
			v_u_53(v75.state)
		else
			v_u_53(v75)
		end
	end
	local v77
	if v75 then
		v77 = v75.ok ~= false
	else
		v77 = v75
	end
	return v77, v75
end
function v_u_7.Execute(p_u_78, p79) -- name: Execute
	-- upvalues: (copy) v_u_7, (copy) v_u_6, (copy) v_u_60, (copy) v_u_57
	v_u_7.Init()
	if p_u_78 == v_u_7 then
		p_u_78 = p79
		p79 = nil
	end
	if type(p_u_78) == "string" and p79 ~= nil then
		local v80 = v_u_6.NormalizeAction(p_u_78) or p_u_78
		if type(p79) == "table" then
			p_u_78 = v_u_6.CloneTable(p79)
			if p_u_78.action == nil and (p_u_78.method == nil and (p_u_78.type == nil and (p_u_78.name == nil and p_u_78.signal == nil))) then
				p_u_78.action = v80
			end
		else
			p_u_78 = {
				["action"] = v80,
				["arg"] = p79
			}
		end
	end
	v_u_60(true)
	local v_u_81 = v_u_57()
	if v_u_81 and (v_u_81.Execute and v_u_81.Execute:IsA("RemoteEvent")) then
		local v82, v83 = pcall(function()
			-- upvalues: (copy) v_u_81, (ref) p_u_78
			v_u_81.Execute:FireServer(p_u_78)
		end)
		if v82 then
			return true
		else
			return false, v83
		end
	else
		return false, "unavailable"
	end
end
function v_u_7.Attack(p84, p85) -- name: Attack
	-- upvalues: (copy) v_u_7, (copy) v_u_6
	if p84 ~= v_u_7 then
		p85 = p84
	end
	return v_u_7.Execute(v_u_6.BuildAttackPayload(p85))
end
function v_u_7.PlaceBlock(p86, p87) -- name: PlaceBlock
	-- upvalues: (copy) v_u_7, (copy) v_u_6
	if p86 ~= v_u_7 then
		p87 = p86
	end
	return v_u_7.Execute(v_u_6.BuildPlaceBlockPayload(p87))
end
function v_u_7.Place(p88, p89) -- name: Place
	-- upvalues: (copy) v_u_7
	if p88 ~= v_u_7 then
		p89 = p88
	end
	return v_u_7.PlaceBlock(p89)
end
function v_u_7.BreakBlock(p90, p91) -- name: BreakBlock
	-- upvalues: (copy) v_u_7, (copy) v_u_6
	if p90 ~= v_u_7 then
		p91 = p90
	end
	return v_u_7.Execute(v_u_6.BuildBreakBlockPayload(p91))
end
function v_u_7.Break(p92, p93) -- name: Break
	-- upvalues: (copy) v_u_7
	if p92 ~= v_u_7 then
		p93 = p92
	end
	return v_u_7.BreakBlock(p93)
end
function v_u_7.Pulse(p94, p_u_95) -- name: Pulse
	-- upvalues: (copy) v_u_7, (copy) v_u_60, (copy) v_u_57
	v_u_7.Init()
	if p94 ~= v_u_7 then
		p_u_95 = p94
	end
	v_u_60(true)
	local v_u_96 = v_u_57()
	if v_u_96 and (v_u_96.Pulse and v_u_96.Pulse:IsA("RemoteEvent")) then
		local v97, v98 = pcall(function()
			-- upvalues: (copy) v_u_96, (copy) p_u_95
			v_u_96.Pulse:FireServer(p_u_95 or {})
		end)
		if v97 then
			return true
		else
			return false, v98
		end
	else
		return false, "unavailable"
	end
end
function v_u_7.Set(p99, p100, p101) -- name: Set
	-- upvalues: (copy) v_u_7
	if p99 ~= v_u_7 then
		p101 = p100
		p100 = p99
	end
	return v_u_7.Configure({
		["method"] = p100,
		["value"] = p101
	})
end
function v_u_7.Reset(p102, p103) -- name: Reset
	-- upvalues: (copy) v_u_7
	if p102 ~= v_u_7 then
		p103 = p102
	end
	return v_u_7.Configure({
		["method"] = p103,
		["reset"] = true
	})
end
function v_u_7.GetCombatReach() -- name: GetCombatReach
	-- upvalues: (copy) v_u_7, (copy) v_u_6
	return v_u_7.Get("combatReach") or v_u_6.GetDefaultValue("combatReach")
end
function v_u_7.SetCombatReach(p104, p105) -- name: SetCombatReach
	-- upvalues: (copy) v_u_7
	if p104 ~= v_u_7 then
		p105 = p104
	end
	return v_u_7.Set("combatReach", p105)
end
function v_u_7.ResetCombatReach() -- name: ResetCombatReach
	-- upvalues: (copy) v_u_7
	return v_u_7.Reset("combatReach")
end
function v_u_7.GetReach() -- name: GetReach
	-- upvalues: (copy) v_u_7
	return v_u_7.GetCombatReach()
end
function v_u_7.SetReach(p106, p107) -- name: SetReach
	-- upvalues: (copy) v_u_7
	if p106 ~= v_u_7 then
		p107 = p106
	end
	return v_u_7.SetCombatReach(p107)
end
function v_u_7.ResetReach() -- name: ResetReach
	-- upvalues: (copy) v_u_7
	return v_u_7.ResetCombatReach()
end
function v_u_7.GetBlockReach() -- name: GetBlockReach
	-- upvalues: (copy) v_u_7, (copy) v_u_6
	return v_u_7.Get("blockReach") or v_u_6.GetDefaultValue("blockReach")
end
function v_u_7.SetBlockReach(p108, p109) -- name: SetBlockReach
	-- upvalues: (copy) v_u_7
	if p108 ~= v_u_7 then
		p109 = p108
	end
	return v_u_7.Set("blockReach", p109)
end
function v_u_7.ResetBlockReach() -- name: ResetBlockReach
	-- upvalues: (copy) v_u_7
	return v_u_7.Reset("blockReach")
end
function v_u_7.OnChanged(p110, p111, p112) -- name: OnChanged
	-- upvalues: (copy) v_u_7, (copy) v_u_6, (copy) v_u_18
	v_u_7.Init()
	if p110 ~= v_u_7 then
		p112 = p111
		p111 = p110
	end
	local v_u_113 = v_u_6.NormalizeMethod(p111) or p111
	if type(v_u_113) ~= "string" or type(p112) ~= "function" then
		return function() end
	end
	if not v_u_18[v_u_113] then
		v_u_18[v_u_113] = {}
	end
	local v114 = v_u_18[v_u_113]
	table.insert(v114, p112)
	local v_u_115 = #v_u_18[v_u_113]
	return function()
		-- upvalues: (ref) v_u_18, (copy) v_u_113, (copy) v_u_115
		if v_u_18[v_u_113] then
			table.remove(v_u_18[v_u_113], v_u_115)
		end
	end
end
function v_u_7.IsBridgeAvailable() -- name: IsBridgeAvailable
	-- upvalues: (copy) v_u_7, (copy) v_u_57, (ref) v_u_14
	v_u_7.Init()
	local v116 = v_u_57() ~= nil
	if v_u_14 then
		return v116, nil
	else
		return v116, "bridge_unavailable"
	end
end
return v_u_7
