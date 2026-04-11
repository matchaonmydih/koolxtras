-- Decompiled by your's lovely (stav)
local v_u_1 = {}
local cloneref = cloneref or function(obj) return obj end
local v_u_2 = cloneref(game:GetService("ReplicatedStorage"))
local v_u_3 = nil
local Functions = loadfile('koolaid/libraries/functions.lua')()
pcall(function()
  v_u_3 = Functions.require(v_u_2.Shared.Constants.PotionDefinitions)
end)
v_u_1.SWORD = "sword"
v_u_1.MACE = "mace"
v_u_1.PICKAXE = "pickaxe"
v_u_1.AXE = "axe"
v_u_1.SHOVEL = "shovel"
v_u_1.HOE = "hoe"
v_u_1.BLOCK = "block"
v_u_1.THROWABLE = "throwable"
v_u_1.WINDCHARGE = "windcharge"
v_u_1.FIRECHARGE = "firecharge"
v_u_1.CONSUMABLE = "consumable"
v_u_1.BOW = "bow"
v_u_1.BUCKET = "bucket"
v_u_1.SPLASH_POTION = "splash_potion"
v_u_1.TNT = "tnt"
v_u_1.END_CRYSTAL = "end_crystal"
v_u_1.TOTEM = "totem"
local v_u_5 = {
	"EnderPearl",
	"Snowball",
	"Egg",
	"Trident"
}
local v_u_6 = { "WindCharge" }
local v_u_7 = { "FireCharge" }
local v_u_8 = {
	"DiamondSword",
	"IronSword",
	"GoldSword",
	"StoneSword",
	"WoodSword"
}
local v_u_9 = {
	"DiamondPickaxe",
	"IronPickaxe",
	"GoldPickaxe",
	"StonePickaxe",
	"WoodPickaxe"
}
local v_u_10 = {
	"DiamondAxe",
	"IronAxe",
	"GoldAxe",
	"StoneAxe",
	"WoodAxe"
}
local v_u_11 = {
	"DiamondShovel",
	"IronShovel",
	"GoldShovel",
	"StoneShovel",
	"WoodShovel"
}
local v_u_12 = {
	"DiamondHoe",
	"IronHoe",
	"GoldHoe",
	"StoneHoe",
	"WoodHoe"
}
local v_u_13 = { "Mace" }
local v_u_14 = { "Bow" }
local v_u_15 = { "Bucket", "WaterBucket", "LavaBucket" }
local v_u_16 = { "TNT" }
local v_u_17 = { "EndCrystal", "Crystal" }
local v_u_18 = { "TotemOfUndying", "TotemofUndying", "Totem" }
local v_u_29 = (function() -- name: buildSplashPotionNames
	-- upvalues: (ref) v_u_3
	if v_u_3 and v_u_3.GetAllSplashPotionToolNames then
		local v19 = v_u_3.GetAllSplashPotionToolNames(true)
		if type(v19) == "table" and #v19 > 0 then
			return v19
		end
	end
	local v20 = { "SplashPotion" }
	if v_u_3 and (v_u_3.GetPotionTypes and v_u_3.GetRomanNumeral) then
		for _, v21 in ipairs(v_u_3.GetPotionTypes()) do
			local v22 = "SplashPotion" .. v21
			table.insert(v20, v22)
			for v23 = 1, 5 do
				local v24 = "SplashPotion" .. v21 .. v_u_3.GetRomanNumeral(v23)
				table.insert(v20, v24)
			end
		end
		return v20
	else
		for _, v25 in ipairs({
			"Healing",
			"InstantHealth",
			"InstantHarm",
			"Strength",
			"Resistance",
			"Regeneration",
			"Swiftness",
			"FireResistance",
			"Poison",
			"Slowness",
			"Blindness",
			"JumpBoost",
			"Levitation"
		}) do
			local v26 = "SplashPotion" .. v25
			table.insert(v20, v26)
			for _, v27 in ipairs({
				"I",
				"II",
				"III",
				"IV",
				"V"
			}) do
				local v28 = "SplashPotion" .. v25 .. v27
				table.insert(v20, v28)
			end
		end
		return v20
	end
end)()
local function v_u_34(p30, ...) -- name: matchesNormalizedToolName
	local v31 = type(p30) ~= "string" and "" or string.lower(p30):gsub("[%s_%-]", "")
	if v31 == "" then
		return false
	end
	for v32 = 1, select("#", ...) do
		local v33 = select(v32, ...)
		if v31 == (type(v33) ~= "string" and "" or string.lower(v33):gsub("[%s_%-]", "")) then
			return true
		end
	end
	return false
end
function v_u_1.GetType(p35) -- name: GetType
	-- upvalues: (copy) v_u_1, (copy) v_u_8, (copy) v_u_13, (copy) v_u_9, (copy) v_u_10, (copy) v_u_11, (copy) v_u_12, (copy) v_u_5, (copy) v_u_6, (copy) v_u_7, (copy) v_u_14, (copy) v_u_15, (copy) v_u_16, (copy) v_u_17, (copy) v_u_34, (copy) v_u_18, (copy) v_u_29, (copy) v_u_2
	if p35 then
		local v36
		if typeof(p35) == "Instance" then
			v36 = p35:IsA("Tool")
		elseif type(p35) == "table" then
			local v37 = p35.Name
			v36 = type(v37) == "string"
		else
			v36 = false
		end
		if v36 then
			local v38 = p35.Name
			local v39
			if typeof(p35) == "Instance" then
				v39 = p35:GetAttribute("ToolType")
			elseif type(p35) == "table" then
				local v40 = p35.GetAttribute
				if type(v40) == "function" then
					v39 = p35:GetAttribute("ToolType")
				else
					v39 = nil
				end
			else
				v39 = nil
			end
			if not v39 then
				if typeof(p35) == "Instance" then
					v39 = p35:GetAttribute("toolType")
				elseif type(p35) == "table" then
					local v41 = p35.GetAttribute
					if type(v41) == "function" then
						v39 = p35:GetAttribute("toolType")
					else
						v39 = nil
					end
				else
					v39 = nil
				end
				if not v39 then
					if typeof(p35) == "Instance" then
						v39 = p35:GetAttribute("ItemType")
					elseif type(p35) == "table" then
						local v42 = p35.GetAttribute
						if type(v42) == "function" then
							v39 = p35:GetAttribute("ItemType")
						else
							v39 = nil
						end
					else
						v39 = nil
					end
					if not v39 then
						if typeof(p35) == "Instance" then
							v39 = p35:GetAttribute("CombatType")
						elseif type(p35) == "table" then
							local v43 = p35.GetAttribute
							if type(v43) == "function" then
								v39 = p35:GetAttribute("CombatType")
							else
								v39 = nil
							end
						else
							v39 = nil
						end
					end
				end
			end
			if type(v39) == "string" then
				local v44 = type(v39) ~= "string" and "" or string.lower(v39):gsub("[%s_%-]", "")
				if v44 == "mace" then
					return v_u_1.MACE
				end
				if v44 == "sword" then
					return v_u_1.SWORD
				end
				if v44 == "pickaxe" then
					return v_u_1.PICKAXE
				end
				if v44 == "axe" then
					return v_u_1.AXE
				end
				if v44 == "shovel" or v44 == "spade" then
					return v_u_1.SHOVEL
				end
				if v44 == "hoe" then
					return v_u_1.HOE
				end
				if v44 == "block" then
					return v_u_1.BLOCK
				end
				if v44 == "throwable" then
					return v_u_1.THROWABLE
				end
				if v44 == "windcharge" then
					return v_u_1.WINDCHARGE
				end
				if v44 == "firecharge" then
					return v_u_1.FIRECHARGE
				end
				if v44 == "consumable" then
					return v_u_1.CONSUMABLE
				end
				if v44 == "bow" then
					return v_u_1.BOW
				end
				if v44 == "bucket" then
					return v_u_1.BUCKET
				end
				if v44 == "splashpotion" then
					return v_u_1.SPLASH_POTION
				end
				if v44 == "tnt" then
					return v_u_1.TNT
				end
				if v44 == "endcrystal" or v44 == "crystal" then
					return v_u_1.END_CRYSTAL
				end
				if v44 == "totem" or v44 == "totemofundying" then
					return v_u_1.TOTEM
				end
			end
			local v45
			if typeof(p35) == "Instance" then
				v45 = p35:GetAttribute("Mace")
			elseif type(p35) == "table" then
				local v46 = p35.GetAttribute
				if type(v46) == "function" then
					v45 = p35:GetAttribute("Mace")
				else
					v45 = nil
				end
			else
				v45 = nil
			end
			if v45 ~= true then
				local v47
				if typeof(p35) == "Instance" then
					v47 = p35:GetAttribute("IsMace")
				elseif type(p35) == "table" then
					local v48 = p35.GetAttribute
					if type(v48) == "function" then
						v47 = p35:GetAttribute("IsMace")
					else
						v47 = nil
					end
				else
					v47 = nil
				end
				if v47 ~= true then
					local v49 = v_u_8
					for _, v50 in ipairs(v49) do
						if v50 == v38 then
							v95 = true
							if v95 then
								return v_u_1.SWORD
							end
							local v51 = v_u_13
							for _, v52 in ipairs(v51) do
								if v52 == v38 then
									v94 = true
									if v94 then
										return v_u_1.MACE
									end
									if string.find(string.lower(v38), "mace", 1, true) then
										return v_u_1.MACE
									end
									local v53 = v_u_9
									for _, v54 in ipairs(v53) do
										if v54 == v38 then
											v93 = true
											if v93 then
												return v_u_1.PICKAXE
											end
											local v55 = v_u_10
											for _, v56 in ipairs(v55) do
												if v56 == v38 then
													v92 = true
													if v92 then
														return v_u_1.AXE
													end
													local v57 = v_u_11
													for _, v58 in ipairs(v57) do
														if v58 == v38 then
															v91 = true
															if v91 then
																return v_u_1.SHOVEL
															end
															local v59 = v_u_12
															for _, v60 in ipairs(v59) do
																if v60 == v38 then
																	v90 = true
																	if v90 then
																		return v_u_1.HOE
																	end
																	if string.find(string.lower(v38), "pickaxe", 1, true) then
																		return v_u_1.PICKAXE
																	end
																	if string.find(string.lower(v38), "axe", 1, true) then
																		return v_u_1.AXE
																	end
																	if string.find(string.lower(v38), "shovel", 1, true) or string.find(string.lower(v38), "spade", 1, true) then
																		return v_u_1.SHOVEL
																	end
																	if string.find(string.lower(v38), "hoe", 1, true) then
																		return v_u_1.HOE
																	end
																	local v61 = v_u_5
																	for _, v62 in ipairs(v61) do
																		if v62 == v38 then
																			v89 = true
																			if v89 then
																				return v_u_1.THROWABLE
																			end
																			local v63 = v_u_6
																			for _, v64 in ipairs(v63) do
																				if v64 == v38 then
																					v88 = true
																					if v88 then
																						return v_u_1.WINDCHARGE
																					end
																					local v65 = v_u_7
																					for _, v66 in ipairs(v65) do
																						if v66 == v38 then
																							v87 = true
																							if v87 then
																								return v_u_1.FIRECHARGE
																							end
																							local v67 = v_u_14
																							for _, v68 in ipairs(v67) do
																								if v68 == v38 then
																									v86 = true
																									if v86 then
																										return v_u_1.BOW
																									end
																									local v69 = v_u_15
																									for _, v70 in ipairs(v69) do
																										if v70 == v38 then
																											v85 = true
																											if v85 then
																												return v_u_1.BUCKET
																											end
																											local v71 = v_u_16
																											for _, v72 in ipairs(v71) do
																												if v72 == v38 then
																													v84 = true
																													if v84 then
																														return v_u_1.TNT
																													end
																													local v73 = v_u_17
																													for _, v74 in ipairs(v73) do
																														if v74 == v38 then
																															v83 = true
																															if v83 or v_u_34(v38, "EndCrystal", "Crystal") then
																																return v_u_1.END_CRYSTAL
																															end
																															local v75 = v_u_18
																															for _, v76 in ipairs(v75) do
																																if v76 == v38 then
																																	v82 = true
																																	if v82 or v_u_34(v38, "TotemOfUndying", "Totem") then
																																		return v_u_1.TOTEM
																																	end
																																	local v77 = v_u_29
																																	for _, v78 in ipairs(v77) do
																																		if v78 == v38 then
																																			v81 = true
																																			if v81 or v38:find("SplashPotion") then
																																				return v_u_1.SPLASH_POTION
																																			end
																																			local v79 = v_u_2:FindFirstChild("Assets")
																																			if v79 then
																																				local v80 = v79:FindFirstChild("Blocks")
																																				if v80 and v80:FindFirstChild(v38) then
																																					return v_u_1.BLOCK
																																				end
																																			end
																																			return nil
																																		end
																																	end
																																	local v81 = false
																																end
																															end
																															local v82 = false
																														end
																													end
																													local v83 = false
																												end
																											end
																											local v84 = false
																										end
																									end
																									local v85 = false
																								end
																							end
																							local v86 = false
																						end
																					end
																					local v87 = false
																				end
																			end
																			local v88 = false
																		end
																	end
																	local v89 = false
																end
															end
															local v90 = false
														end
													end
													local v91 = false
												end
											end
											local v92 = false
										end
									end
									local v93 = false
								end
							end
							local v94 = false
						end
					end
					local v95 = false
				end
			end
			return v_u_1.MACE
		end
	end
	return nil
end
function v_u_1.IsCombatTool(p96) -- name: IsCombatTool
	-- upvalues: (copy) v_u_1
	local v97 = v_u_1.GetType(p96)
	return (v97 == v_u_1.SWORD or (v97 == v_u_1.MACE or (v97 == v_u_1.PICKAXE or (v97 == v_u_1.AXE or v97 == v_u_1.SHOVEL)))) and true or v97 == v_u_1.HOE
end
function v_u_1.IsMiningTool(p98) -- name: IsMiningTool
	-- upvalues: (copy) v_u_1
	local v99 = v_u_1.GetType(p98)
	return (v99 == v_u_1.PICKAXE or v99 == v_u_1.SHOVEL) and true or v99 == v_u_1.HOE
end
function v_u_1.IsPlacementTool(p100) -- name: IsPlacementTool
	-- upvalues: (copy) v_u_1
	return v_u_1.GetType(p100) == v_u_1.BLOCK
end
function v_u_1.IsThrowable(p101) -- name: IsThrowable
	-- upvalues: (copy) v_u_1
	return v_u_1.GetType(p101) == v_u_1.THROWABLE
end
function v_u_1.IsBow(p102) -- name: IsBow
	-- upvalues: (copy) v_u_1
	return v_u_1.GetType(p102) == v_u_1.BOW
end
function v_u_1.IsWindCharge(p103) -- name: IsWindCharge
	-- upvalues: (copy) v_u_1
	return v_u_1.GetType(p103) == v_u_1.WINDCHARGE
end
function v_u_1.IsFireCharge(p104) -- name: IsFireCharge
	-- upvalues: (copy) v_u_1
	return v_u_1.GetType(p104) == v_u_1.FIRECHARGE
end
function v_u_1.IsBucket(p105) -- name: IsBucket
	-- upvalues: (copy) v_u_1
	return v_u_1.GetType(p105) == v_u_1.BUCKET
end
function v_u_1.IsSplashPotion(p106) -- name: IsSplashPotion
	-- upvalues: (copy) v_u_1
	return v_u_1.GetType(p106) == v_u_1.SPLASH_POTION
end
function v_u_1.IsTNT(p107) -- name: IsTNT
	-- upvalues: (copy) v_u_1
	return v_u_1.GetType(p107) == v_u_1.TNT
end
function v_u_1.IsEndCrystal(p108) -- name: IsEndCrystal
	-- upvalues: (copy) v_u_1
	return v_u_1.GetType(p108) == v_u_1.END_CRYSTAL
end
function v_u_1.IsTotem(p109) -- name: IsTotem
	-- upvalues: (copy) v_u_1
	return v_u_1.GetType(p109) == v_u_1.TOTEM
end
v_u_1.THROWABLES = v_u_5
v_u_1.WINDCHARGES = v_u_6
v_u_1.FIRECHARGES = v_u_7
v_u_1.SWORDS = v_u_8
v_u_1.PICKAXES = v_u_9
v_u_1.AXES = v_u_10
v_u_1.SHOVELS = v_u_11
v_u_1.HOES = v_u_12
v_u_1.MACES = v_u_13
v_u_1.BOWS = v_u_14
v_u_1.BUCKETS = v_u_15
v_u_1.SPLASH_POTIONS = v_u_29
v_u_1.TNTS = v_u_16
v_u_1.END_CRYSTALS = v_u_17
v_u_1.TOTEMS = v_u_18
return v_u_1
