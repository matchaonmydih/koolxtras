-- Decompiled by your's lovely (stav)
local v_u_1 = game:GetService("Players")
local v_u_2 = game:GetService("ReplicatedStorage")
local v_u_3 = game:GetService("RunService")
local v_u_4 = {}
local v_u_5 = {
	["combat"] = "canAttack",
	["place"] = "canPlaceBlocks",
	["mine"] = "canBreakBlocks"
}
local v_u_6 = {
	[0] = {
		["canAttack"] = true,
		["canPlaceBlocks"] = true,
		["canBreakBlocks"] = true
	},
	[1] = {
		["canAttack"] = true,
		["canPlaceBlocks"] = true,
		["canBreakBlocks"] = true
	},
	[2] = {
		["canAttack"] = false,
		["canPlaceBlocks"] = false,
		["canBreakBlocks"] = false
	},
	[3] = {
		["canAttack"] = false,
		["canPlaceBlocks"] = false,
		["canBreakBlocks"] = false
	}
}
local v_u_7 = {
	["combat"] = {
		["capability"] = "combat",
		["enforceLobbyRestriction"] = true
	},
	["place"] = {
		["capability"] = "place",
		["enforceLobbyRestriction"] = true,
		["enforceMaxBuildHeight"] = true,
		["enforceBuildHeightZones"] = true,
		["enforceNoBlockZones"] = true
	},
	["mine"] = {
		["capability"] = "mine",
		["disallowIndestructible"] = true
	}
}
local v_u_8 = {
	["buildHeight"] = {
		["BuildHeight"] = true,
		["BUILD_HEIGHT"] = true,
		["build_height"] = true
	},
	["noBlocks"] = {
		["NoBlockZone"] = true,
		["NO_BLOCKS"] = true,
		["no_blocks"] = true,
		["NoBlocks"] = true
	}
}
local v_u_9 = {}
local v_u_10 = {}
local v_u_11 = {}
local v_u_12 = nil
local v_u_13 = false
local v_u_14 = false
local v_u_15 = false
local v_u_16 = nil
local v_u_17 = nil
local v_u_18 = nil
local v_u_19 = nil
local function v_u_25() -- name: getGameruleCache
	return nil
end
local function v_u_28(p26) -- name: isLobbyCombatZonePart
	if not (p26 and p26:IsA("BasePart")) then
		return false
	end
	local v27 = workspace:FindFirstChild("Lobby")
	if v27 then
		v27 = v27:FindFirstChild("Areas")
	end
	if not v27 then
		return false
	end
	while true do
		if not p26 or p26 == workspace then
			p26 = nil
			break
		end
		if p26.Name == "COMBAT_ALLOWED" then
			break
		end
		p26 = p26.Parent
	end
	if p26 then
		return p26:IsDescendantOf(v27)
	else
		return false
	end
end
local function v_u_38(p29) -- name: isInLobbyCombatZone
	-- upvalues: (ref) v_u_19, (copy) v_u_11
	if typeof(p29) ~= "Vector3" then
		return false
	end
	v_u_19()
	for v30 in pairs(v_u_11) do
		if v30 and v30.Parent then
			local v31 = v30.CFrame:PointToObjectSpace(p29)
			local v32 = v30.Size * 0.5
			local v33 = v32.Y + 8
			local v34 = v31.X
			local v35
			if math.abs(v34) <= v32.X then
				local v36 = v31.Y
				if math.abs(v36) <= v33 then
					local v37 = v31.Z
					v35 = math.abs(v37) <= v32.Z
				else
					v35 = false
				end
			else
				v35 = false
			end
			if v35 then
				return true
			end
		end
	end
	return false
end
local function v_u_43(p39) -- name: getPlayerActionPosition
	if p39 then
		local v40 = p39.Character
		if v40 then
			local v41 = v40:FindFirstChildOfClass("Humanoid")
			if v41 and v41.RootPart then
				return v41.RootPart.Position
			elseif v40.PrimaryPart then
				return v40.PrimaryPart.Position
			else
				local v42 = v40:FindFirstChild("HumanoidRootPart")
				if v42 and v42:IsA("BasePart") then
					return v42.Position
				else
					return nil
				end
			end
		else
			return nil
		end
	else
		return nil
	end
end
local function v_u_47(p44) -- name: getCharacterActionPosition
	if p44 then
		local v45 = p44:FindFirstChildOfClass("Humanoid")
		if v45 and v45.RootPart then
			return v45.RootPart.Position
		elseif p44.PrimaryPart then
			return p44.PrimaryPart.Position
		else
			local v46 = p44:FindFirstChild("HumanoidRootPart")
			if v46 and v46:IsA("BasePart") then
				return v46.Position
			else
				return nil
			end
		end
	else
		return nil
	end
end
local function v_u_51(p48) -- name: hasLobbyCombatPrivilege
	if not p48 then
		return false
	end
	if p48:GetAttribute("LobbyMode") == true then
		return true
	end
	if p48:GetAttribute("OP") == true or p48:GetAttribute("IsOP") == true then
		return true
	end
	local v49 = p48:GetAttribute("Rank")
	local v50
	if type(v49) == "number" then
		v50 = v49 <= 2
	else
		v50 = false
	end
	return v50
end
local function v_u_55(p52, p53, p54) -- name: canUseLobbyCombatBypass
	-- upvalues: (copy) v_u_51, (copy) v_u_43, (copy) v_u_38, (copy) v_u_47
	if workspace:GetAttribute("IsMatch") == true then
		return false
	elseif v_u_51(p52) then
		return true
	elseif v_u_38((v_u_43(p52))) then
		return v_u_38(v_u_43(p54) or v_u_47(p53))
	else
		return false
	end
end
local function v_u_60(p56) -- name: normalizeTeamKey
	if p56 == nil then
		return nil
	else
		local v57 = typeof(p56)
		if v57 == "string" then
			local v58 = string.lower(string.match(p56, "^%s*(.-)%s*$") or "")
			if v58 == "" then
				return nil
			else
				return "string:" .. v58
			end
		else
			if v57 == "number" then
				return "number:" .. tostring(p56)
			end
			if v57 == "Instance" and p56:IsA("Team") then
				return "team:" .. string.lower(p56.Name)
			end
			if v57 ~= "BrickColor" then
				return nil
			end
			local v59 = p56.Number
			return "brick:" .. tostring(v59)
		end
	end
end
local function v_u_69(p61, p62) -- name: resolveTeamKeyForCharacter
	-- upvalues: (copy) v_u_60
	local v63 = v_u_60(p61 and p61:GetAttribute("Team") or nil)
	if v63 then
		return v63
	end
	local v64 = v_u_60
	local v65
	if p62 then
		v65 = p62:GetAttribute("Team") or nil
	else
		v65 = nil
	end
	local v66 = v64(v65)
	if v66 then
		return v66
	end
	local v67 = v_u_60
	local v68
	if p62 then
		v68 = p62.Team or nil
	else
		v68 = nil
	end
	return v67(v68) or (v_u_60(p62 and p62.TeamColor or nil) or nil)
end
local function v_u_72(p70) -- name: trackZonePart
	-- upvalues: (copy) v_u_8, (copy) v_u_9, (ref) v_u_12, (copy) v_u_10, (copy) v_u_28, (copy) v_u_11
	if p70 and p70:IsA("BasePart") then
		if v_u_8.buildHeight[p70.Name] then
			v_u_9[p70] = true
			local v71 = p70.Position.Y + p70.Size.Y * 0.5
			if v_u_12 == nil or v71 < v_u_12 then
				v_u_12 = v71
			end
		end
		if v_u_8.noBlocks[p70.Name] then
			v_u_10[p70] = true
		end
		if v_u_28(p70) then
			v_u_11[p70] = true
		end
	end
end
local function v_u_76(p73) -- name: untrackZonePart
	-- upvalues: (copy) v_u_9, (ref) v_u_12, (copy) v_u_10, (copy) v_u_11
	if v_u_9[p73] then
		v_u_9[p73] = nil
		v_u_12 = nil
		for v74 in pairs(v_u_9) do
			if v74 and v74.Parent then
				local v75 = v74.Position.Y + v74.Size.Y * 0.5
				if v_u_12 == nil or v75 < v_u_12 then
					v_u_12 = v75
				end
			end
		end
	end
	v_u_10[p73] = nil
	v_u_11[p73] = nil
end
local function v_u_84(p77) -- name: scanZonesFromRoot
	-- upvalues: (copy) v_u_72
	local v78 = 1
	local v79 = { p77 }
	while v78 > 0 do
		local v80 = v79[v78]
		v79[v78] = nil
		v78 = v78 - 1
		local v81 = v80:GetChildren()
		for v82 = 1, #v81 do
			local v83 = v81[v82]
			v_u_72(v83)
			v78 = v78 + 1
			v79[v78] = v83
		end
	end
end
v_u_19 = function() -- name: ensureZoneTracking
	-- upvalues: (ref) v_u_13, (ref) v_u_17, (ref) v_u_18, (copy) v_u_72, (copy) v_u_76, (copy) v_u_3, (copy) v_u_84, (ref) v_u_15, (ref) v_u_14
	if v_u_13 then
		return
	else
		v_u_13 = true
		if v_u_17 then
			v_u_17:Disconnect()
			v_u_17 = nil
		end
		if v_u_18 then
			v_u_18:Disconnect()
			v_u_18 = nil
		end
		v_u_17 = workspace.DescendantAdded:Connect(v_u_72)
		v_u_18 = workspace.DescendantRemoving:Connect(v_u_76)
		if v_u_3:IsServer() then
			v_u_84(workspace)
			v_u_15 = true
			v_u_14 = false
		else
			local v_u_85 = workspace
			if not v_u_14 then
				if v_u_15 then
					return
				end
				v_u_14 = true
				task.spawn(function()
					-- upvalues: (copy) v_u_85, (ref) v_u_72, (ref) v_u_14, (ref) v_u_15
					local v86 = { v_u_85 }
					local v87 = 1
					while v87 > 0 do
						local v88 = os.clock()
						while v87 > 0 and os.clock() - v88 < 0.0015 do
							local v89 = v86[v87]
							v86[v87] = nil
							v87 = v87 - 1
							local v90 = v89:GetChildren()
							for v91 = 1, #v90 do
								local v92 = v90[v91]
								v_u_72(v92)
								v87 = v87 + 1
								v86[v87] = v92
							end
						end
						task.wait()
					end
					v_u_14 = false
					v_u_15 = true
				end)
			end
		end
	end
end
if v_u_3:IsClient() then
	task.defer(v_u_19)
end
function v_u_4.CanPerform(p93, p94, p95) -- name: CanPerform
	-- upvalues: (copy) v_u_1, (copy) v_u_7, (copy) v_u_3, (copy) v_u_5, (copy) v_u_6, (copy) v_u_38, (copy) v_u_43, (copy) v_u_25, (ref) v_u_19, (ref) v_u_12, (copy) v_u_10
	local v96 = p95 or v_u_1.LocalPlayer
	local v97 = v_u_7[p93]
	if not v97 then
		return true
	end
	if v97.capability then
		local v100 = v_u_5[v97.capability]
		local v101
		if v100 then
			local v102 = v_u_6
			local v103
			if v96 then
				local v104 = v96.Character
				if v104 then
					v104 = v104:GetAttribute("Gamemode")
				end
				if typeof(v104) ~= "number" then
					v104 = v96:GetAttribute("Gamemode")
				end
				v103 = typeof(v104) ~= "number" and 0 or v104
			else
				v103 = 0
			end
			v101 = (v102[v103] or v_u_6[0])[v100] == true
		else
			v101 = true
		end
		if not v101 then
			return false, "Gamemode disallows action"
		end
	end
	if v97.enforceLobbyRestriction then
		local v105
		if workspace:GetAttribute("IsMatch") == true or not v96 then
			v105 = false
		else
			local v106 = v96:GetAttribute("Rank") or 6
			local v107 = v96:GetAttribute("LobbyMode") == true
			if v106 > 2 then
				v105 = not v107
			else
				v105 = false
			end
		end
		if v105 then
			local v108
			if p93 == "place" then
				local v109
				if p94 then
					v109 = p94.position
				else
					v109 = p94
				end
				v108 = v_u_38(v109)
			elseif p93 == "combat" then
				v108 = v_u_38(p94 and p94.position or v_u_43(v96))
			else
				v108 = false
			end
			if not v108 then
				return false, "Action disabled in lobby"
			end
		end
	end
	if v97.gamerule then
		local v_u_110 = v97.gamerule.name
		local v111 = v97.gamerule.defaultValue
		local v_u_112 = v_u_25()
		local v113
		if v_u_112 and v_u_112.Get then
			local v114
			v114, v113 = pcall(function()
				-- upvalues: (copy) v_u_112, (copy) v_u_110
				return v_u_112:Get(v_u_110)
			end)
			if not v114 or v113 == nil then
				v113 = v111
			end
		else
			v113 = v111
		end
		if v113 == v97.gamerule.disallowValue then
			return false, v97.gamerule.reason
		end
	end
	if v97.disallowIndestructible and (p94 and (p94.block and p94.block:GetAttribute("Indestructible"))) then
		return false, "Block is indestructible"
	end
	if v97.enforceMaxBuildHeight or (v97.enforceBuildHeightZones or v97.enforceNoBlockZones) then
		local v115 = p94
		if v115 then
			v115 = p94.position
		end
		if typeof(v115) ~= "Vector3" then
			return false, "Invalid position"
		end
		if v97.enforceMaxBuildHeight then
			local v_u_116 = v_u_25()
			local v117
			if v_u_116 and v_u_116.Get then
				local v_u_118 = "maxBuildHeight"
				local v119, v120 = pcall(function()
					-- upvalues: (copy) v_u_116, (copy) v_u_118
					return v_u_116:Get(v_u_118)
				end)
				v117 = (not v119 or v120 == nil) and 1000 or v120
			else
				v117 = 1000
			end
			if typeof(v117) == "number" and v117 < v115.Y then
				return false, "Build height exceeded"
			end
		end
		v_u_19()
		if v97.enforceBuildHeightZones and (v_u_12 and v_u_12 < v115.Y) then
			return false, "Build height exceeded"
		end
		if v97.enforceNoBlockZones then
			for v121 in pairs(v_u_10) do
				if v121 and v121.Parent then
					local v122 = v121.CFrame:PointToObjectSpace(v115)
					local v123 = v121.Size * 0.5
					local v124 = v122.X
					local v125
					if math.abs(v124) <= v123.X then
						local v126 = v122.Y
						if math.abs(v126) <= v123.Y then
							local v127 = v122.Z
							v125 = math.abs(v127) <= v123.Z
						else
							v125 = false
						end
					else
						v125 = false
					end
					if v125 then
						return false, "Cannot build in this area"
					end
				end
			end
		end
	end
	return true
end
function v_u_4.CanCombat(p128) -- name: CanCombat
	-- upvalues: (copy) v_u_4
	return v_u_4.CanPerform("combat", nil, p128)
end
function v_u_4.IsPositionInLobbyCombatZone(p129) -- name: IsPositionInLobbyCombatZone
	-- upvalues: (copy) v_u_38
	return v_u_38(p129)
end
function v_u_4.IsPlayerInLobbyCombatZone(p130) -- name: IsPlayerInLobbyCombatZone
	-- upvalues: (copy) v_u_1, (copy) v_u_43, (copy) v_u_38
	local v131 = p130 or v_u_1.LocalPlayer
	if v131 then
		return v_u_38((v_u_43(v131)))
	else
		return false
	end
end
function v_u_4.IsPvpEnabled() -- name: IsPvpEnabled
	-- upvalues: (copy) v_u_25
	local v_u_132 = v_u_25()
	local v133
	if v_u_132 and v_u_132.Get then
		local v_u_134 = "pvpEnabled"
		local v135, v136 = pcall(function()
			-- upvalues: (copy) v_u_132, (copy) v_u_134
			return v_u_132:Get(v_u_134)
		end)
		v133 = (not v135 or v136 == nil) and true or v136
	else
		v133 = true
	end
	return v133 == true
end
function v_u_4.CanDamageTarget(p137) -- name: CanDamageTarget
	-- upvalues: (copy) v_u_1, (copy) v_u_55, (copy) v_u_69, (copy) v_u_4
	if p137 and typeof(p137) == "Instance" then
		local v138 = v_u_1.LocalPlayer
		local v139
		if v138 then
			v139 = v138.Character or nil
		else
			v139 = nil
		end
		if v139 and p137 == v139 then
			return false, "Invalid target"
		else
			local v140 = v_u_1:GetPlayerFromCharacter(p137)
			if v140 then
				if v138 and v140 == v138 then
					return false, "Invalid target"
				else
					local v141 = v_u_55(v138, p137, v140)
					if not v141 then
						local v142
						if v138 and v140 then
							if v138 == v140 then
								v142 = true
							else
								local v143 = v_u_69(v139, v138)
								local v144 = v_u_69(p137, v140)
								if v143 and v144 then
									v142 = v143 == v144
								else
									v142 = false
								end
							end
						else
							v142 = false
						end
						if v142 then
							return false, "Cannot damage teammates"
						end
					end
					if v_u_4.IsPvpEnabled() or v141 then
						return true
					else
						return false, "PvP disabled"
					end
				end
			else
				return true
			end
		end
	else
		return true
	end
end
function v_u_4.CanPlaceBlockAt(p145, p146) -- name: CanPlaceBlockAt
	-- upvalues: (copy) v_u_4
	return v_u_4.CanPerform("place", {
		["position"] = p145
	}, p146)
end
function v_u_4.CanMineBlock(p147, p148, p149) -- name: CanMineBlock
	-- upvalues: (copy) v_u_4
	return v_u_4.CanPerform("mine", {
		["block"] = p147,
		["position"] = p148
	}, p149)
end
return v_u_4
