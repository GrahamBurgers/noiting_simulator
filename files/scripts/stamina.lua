--[[
dofile("mods/noiting_simulator/files/scripts/stamina.lua")
SubtractStamina(1)
]]--
local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")

function RefreshStamina()
	local storage = GlobalsGetValue("NS_STAMINA", "") or ""
	local stam = string.len(storage) > 0 and smallfolk.loads(storage) or {}
	GlobalsSetValue("NS_STAMINA", smallfolk.dumps({
		max = stam.max or 5,
		normal = stam.max or 5,
		temp = 0,
		flash = GameGetFrameNum() + 120,
	}))
end

---@param amount number
---@param type "NORMAL"|"TEMP"|"MAX"
function AddStamina(amount, type)
	local storage = GlobalsGetValue("NS_STAMINA", "") or ""
	local stam = string.len(storage) > 0 and smallfolk.loads(storage) or {}
	if type == "NORMAL" then stam.normal = math.min(stam.max, stam.normal + amount) end
	if type == "TEMP" then stam.temp = stam.temp + amount end
	if type == "MAX" then stam.max = stam.max + amount end
	GlobalsSetValue("NS_STAMINA", smallfolk.dumps(stam))
end

---@param type "ANY"|"NORMAL"|"TEMP"|"MAX"
---@param amount number
function SubtractStamina(amount, type)
	local storage = GlobalsGetValue("NS_STAMINA", "") or ""
	local stam = string.len(storage) > 0 and smallfolk.loads(storage) or {}
	type = type or "ANY"

	if type == "ANY" or type == "TEMP" then
		local temp_subtractor = math.min(stam.temp, amount)
		stam.temp = stam.temp - temp_subtractor
		amount = amount - temp_subtractor
	end

	if type == "ANY" or type == "NORMAL" then
		local normal_subtractor = math.min(stam.normal, amount)
		stam.normal = stam.normal - normal_subtractor
		amount = amount - normal_subtractor
	end

	if type == "MAX" then
		stam.max = math.max(1, stam.max - amount)
	end

	stam.flash = GameGetFrameNum() + 15
	GlobalsSetValue("NS_STAMINA", smallfolk.dumps(stam))
end

---@param type "ANY"|"NORMAL"|"TEMP"|"MAX"
---@return number
function GetStamina(type)
	local storage = GlobalsGetValue("NS_STAMINA", "") or ""
	local stam = string.len(storage) > 0 and smallfolk.loads(storage) or {}
	if type == "NORMAL" then return stam.normal end
	if type == "TEMP" then return stam.temp end
	if type == "MAX" then return stam.max end
	return stam.normal + stam.temp
end
