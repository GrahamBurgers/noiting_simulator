if not GameHasFlagRun("feed_wands") then
	GameAddFlagRun("feed_wands")
	dofile("mods/noiting_simulator/files/wands/_list.lua")
	local sum = Rarities[1] + Rarities[2] + Rarities[3] + Rarities[4]
	local new1 = tostring(math.floor((Rarities[1] / sum) * 1000) / 10) .. "%"
	local new2 = tostring(math.floor((Rarities[2] / sum) * 1000) / 10) .. "%"
	local new3 = tostring(math.floor((Rarities[3] / sum) * 1000) / 10) .. "%"
	local new4 = tostring(math.floor((Rarities[4] / sum) * 1000) / 10) .. "%"

	local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
	local feed = smallfolk.loads(GlobalsGetValue("NS_FEED", "{}")) or {}
	feed[#feed+1] = {icon = "mods/noiting_simulator/files/wands/wand_glow_mini.png", color = {136, 75, 176},
		lines = {
			"Each spell has a different RARITY that determines how often it appears.",
			"A wand's colored GLOW is determined by the highest-RARITY spell on the wand.",
			"Around " .. new1 .. " of spells you find will be GREEN: COMMON.",
			"Around " .. new2 .. " of spells you find will be BLUE: UNCOMMON.",
			"Around " .. new3 .. " of spells you find will be PURPLE: RARE.",
			"Around " .. new4 .. " of spells you find will be RED: ULTIMATE.",
			"You can also view a spell's rarity as colored pips in the STORAGE BOX."
		}
	}
	GlobalsSetValue("NS_FEED", smallfolk.dumps(feed))
end