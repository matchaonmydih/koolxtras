-- Decompiled by your's lovely (stav)
local v_u_1 = game:GetService("CollectionService")
local v_u_2 = game:GetService("Workspace")
local v_u_3 = {
	["Tag"] = "Hitbox",
	["LegacyName"] = "Hitbox",
	["Attributes"] = {
		["IsHitbox"] = "CombatHitbox",
		["RuntimeName"] = "CombatHitboxRuntimeName",
		["ExpectedSize"] = "ExpectedHitboxSize",
		["AuthorizedUntil"] = "CombatHitboxAuthorizedUntil",
		["AuthorizedReason"] = "CombatHitboxAuthorizedReason",
		["TransitionUntil"] = "CombatHitboxTransitionUntil",
		["Type"] = "HitboxType",
		["OwnerUserId"] = "CombatHitboxOwnerUserId"
	}
}
local v_u_4 = {
	["Player"] = "HBP",
	["Entity"] = "HBE",
	["Projectile"] = "HBR",
	["DroppedItem"] = "HBD",
	["default"] = "HBX"
}
table.freeze(v_u_3.Attributes)
table.freeze(v_u_4)
local function v_u_9(p5) -- name: randomToken
	local v6 = table.create(p5)
	for v7 = 1, p5 do
		local v8 = math.random(1, 57)
		v6[v7] = string.sub("ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789", v8, v8)
	end
	return table.concat(v6)
end
function v_u_3.BuildRuntimeName(p10) -- name: BuildRuntimeName
	-- upvalues: (copy) v_u_4, (copy) v_u_9
	local v11 = v_u_4[tostring(p10)] or v_u_4.default
	return string.format("%s_%s%s", v11, v_u_9(4), v_u_9(6))
end
function v_u_3.IsCombatHitbox(p12) -- name: IsCombatHitbox
	-- upvalues: (copy) v_u_3, (copy) v_u_1
	if p12 and p12:IsA("BasePart") then
		return p12:GetAttribute(v_u_3.Attributes.IsHitbox) == true and true or v_u_1:HasTag(p12, v_u_3.Tag)
	else
		return false
	end
end
function v_u_3.GetRuntimeName(p13) -- name: GetRuntimeName
	-- upvalues: (copy) v_u_3
	if not (p13 and p13:IsA("BasePart")) then
		return nil
	end
	local v14 = p13:GetAttribute(v_u_3.Attributes.RuntimeName)
	if type(v14) == "string" and v14 ~= "" then
		return v14
	end
	local v15 = v_u_3.BuildRuntimeName(p13:GetAttribute(v_u_3.Attributes.Type))
	p13:SetAttribute(v_u_3.Attributes.RuntimeName, v15)
	return v15
end
function v_u_3.MarkHitbox(p16) -- name: MarkHitbox
	-- upvalues: (copy) v_u_3, (copy) v_u_1
	if not (p16 and p16:IsA("BasePart")) then
		return nil
	end
	p16:SetAttribute(v_u_3.Attributes.IsHitbox, true)
	if not v_u_1:HasTag(p16, v_u_3.Tag) then
		v_u_1:AddTag(p16, v_u_3.Tag)
	end
	local v17 = v_u_3.GetRuntimeName(p16)
	if v17 then
		p16.Name = v17
	end
	return v17
end
function v_u_3.SetExpectedSize(p18, p19) -- name: SetExpectedSize
	-- upvalues: (copy) v_u_3
	if not p18 or (not p18:IsA("BasePart") or typeof(p19) ~= "Vector3") then
		return false
	end
	p18:SetAttribute(v_u_3.Attributes.ExpectedSize, p19)
	return true
end
function v_u_3.GetExpectedSize(p20, p21) -- name: GetExpectedSize
	-- upvalues: (copy) v_u_3
	local v22
	if p20 then
		v22 = p20:GetAttribute(v_u_3.Attributes.ExpectedSize)
	else
		v22 = p20
	end
	if typeof(v22) == "Vector3" then
		return v22
	elseif typeof(p21) == "Vector3" then
		return p21
	elseif p20 and p20:IsA("BasePart") then
		return p20.Size
	else
		return nil
	end
end
function v_u_3.AuthorizeSize(p23, p24, p25, p26) -- name: AuthorizeSize
	-- upvalues: (copy) v_u_3, (copy) v_u_2
	if not (p23 and p23:IsA("BasePart")) then
		return false
	end
	if typeof(p24) == "Vector3" then
		v_u_3.SetExpectedSize(p23, p24)
	end
	local v27 = v_u_3.Attributes.AuthorizedUntil
	local v28, v29 = pcall(function()
		-- upvalues: (ref) v_u_2
		return v_u_2:GetServerTimeNow()
	end)
	if not v28 or type(v29) ~= "number" then
		v29 = tick()
	end
	local v30 = tonumber(p25) or 0
	p23:SetAttribute(v27, v29 + math.max(0, v30))
	if type(p26) == "string" and p26 ~= "" then
		p23:SetAttribute(v_u_3.Attributes.AuthorizedReason, p26)
	end
	return true
end
function v_u_3.IsAuthorized(p31) -- name: IsAuthorized
	-- upvalues: (copy) v_u_3, (copy) v_u_2
	if not (p31 and p31:IsA("BasePart")) then
		return false
	end
	local v32 = p31:GetAttribute(v_u_3.Attributes.AuthorizedUntil)
	local v33
	if type(v32) == "number" then
		local v34, v35 = pcall(function()
			-- upvalues: (ref) v_u_2
			return v_u_2:GetServerTimeNow()
		end)
		if not v34 or type(v35) ~= "number" then
			v35 = tick()
		end
		v33 = v35 <= v32
	else
		v33 = false
	end
	return v33
end
function v_u_3.AuthorizeTransition(p36, p37) -- name: AuthorizeTransition
	-- upvalues: (copy) v_u_3, (copy) v_u_2
	if not p36 or typeof(p36) ~= "Instance" then
		return false
	end
	local v38 = v_u_3.Attributes.TransitionUntil
	local v39, v40 = pcall(function()
		-- upvalues: (ref) v_u_2
		return v_u_2:GetServerTimeNow()
	end)
	if not v39 or type(v40) ~= "number" then
		v40 = tick()
	end
	local v41 = tonumber(p37) or 0
	p36:SetAttribute(v38, v40 + math.max(0, v41))
	return true
end
function v_u_3.IsTransitionAuthorized(p42) -- name: IsTransitionAuthorized
	-- upvalues: (copy) v_u_3, (copy) v_u_2
	if not p42 or typeof(p42) ~= "Instance" then
		return false
	end
	local v43 = p42:GetAttribute(v_u_3.Attributes.TransitionUntil)
	local v44
	if type(v43) == "number" then
		local v45, v46 = pcall(function()
			-- upvalues: (ref) v_u_2
			return v_u_2:GetServerTimeNow()
		end)
		if not v45 or type(v46) ~= "number" then
			v46 = tick()
		end
		v44 = v46 <= v43
	else
		v44 = false
	end
	return v44
end
function v_u_3.FindHitbox(p47) -- name: FindHitbox
	-- upvalues: (copy) v_u_3
	if p47 then
		for _, v48 in ipairs(p47:GetChildren()) do
			if v_u_3.IsCombatHitbox(v48) then
				return v48
			end
		end
		local v49 = p47:FindFirstChild(v_u_3.LegacyName)
		if v49 and v49:IsA("BasePart") then
			return v49
		else
			return nil
		end
	else
		return nil
	end
end
function v_u_3.IsReportedHitboxName(p50, p51) -- name: IsReportedHitboxName
	-- upvalues: (copy) v_u_3
	local v52 = v_u_3.IsCombatHitbox(p50)
	if v52 then
		if type(p51) == "string" and p51 ~= "" then
			v52 = p50.Name == p51
		else
			v52 = false
		end
	end
	return v52
end
function v_u_3.FindReportedHitbox(p53, p54) -- name: FindReportedHitbox
	-- upvalues: (copy) v_u_3
	local v55 = v_u_3.FindHitbox(p53)
	if v_u_3.IsReportedHitboxName(v55, p54) then
		return v55
	else
		return nil
	end
end
return v_u_3
