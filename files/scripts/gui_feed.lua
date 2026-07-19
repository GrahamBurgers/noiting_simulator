local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
--[[
dofile_once("mods/noiting_simulator/files/scripts/gui_feed.lua")
CallFeedMessage("cute")
]]--

local feed_messages = {
	["first_battle"] = function()
		return {
			icon = "mods/noiting_simulator/files/gui/tips_exclamation.png", color = {185, 90, 90},
			lines = {
				"Welcome to your first ENCOUNTER!",
				"Take some time to prepare yourself with WANDS, SPELLS, and ITEMS!",
				"You'll need them to take down the SHELL that conceals your " .. string.lower(tostring(ModSettingGet("noiting_simulator.crush_name"))) .. "'s HEART!",
				"(It's not their fault. They've never been loved before!)",
				"",
				"Any SPELLS and WANDS you take in will be destroyed after the encounter.",
				"You'll salvage any ITEMS that aren't used up during the encounter.",
				"Enter the PORTAL when you're ready."
			}
		}
	end,
	["cute"] = function()
		return {
			icon = "data/ui_gfx/inventory/icon_damage_melee.png", color = {238, 165, 240},
			lines = {
				"Behold! CUTE damage!",
				"CUTE damage grants bonus critical hit chance.",
				"Each point of CUTE damage = +" .. GlobalsGetValue("CUTE_CRIT_FACTOR", "1") .. "% crit. chance!",
				"Strike them right in the heart!",
			}
		}
	end,
	["charming"] = function()
		return {
			icon = "data/ui_gfx/inventory/icon_damage_slice.png", color = {225, 207, 122},
			lines = {
				"Behold! CHARMING damage!",
				"CHARMING damage increases your " .. string.lower(tostring(ModSettingGet("noiting_simulator.crush_name"))) .. "'s OTHER damage multipliers.",
				"",
				"Each point of CHARMING damage adds +" .. GlobalsGetValue("CHARMING_FACTOR", "1") .. "% to non-CHARMING damage multipliers!",
				"This bonus decays by " .. GlobalsGetValue("CHARMING_DECAY_FACTOR", "1") .. "% for each point of non-CHARMING damage you deal.",
				"(The testing Dummy is immune to the CHARMING damage bonus.)",
				"",
				"Take them down with variety!",
			}
		}
	end,
	["clever"] = function()
		return {
			icon = "data/ui_gfx/inventory/icon_damage_fire.png", color = {165, 190, 240},
			lines = {
				"Behold! CLEVER damage!",
				"CLEVER damage temporarily decreases the TEMPO of the encounter.",
				"But, it'll increase faster until it reaches its normal value again!",
				"Pay attention and take your time!",
			}
		}
	end,
	["comedic"] = function()
		return {
			icon = "data/ui_gfx/inventory/icon_damage_ice.png", color = {120, 217, 145},
			lines = {
				"Behold! COMEDIC damage!",
				"Most COMEDIC projectiles will HEAL you on a successful hit.",
				"However, it'll HURT you instead if you MISS!",
				"",
				"Healing is equal to " .. tostring(tonumber(GlobalsGetValue("COMEDIC_HEAL_FACTOR", "0.50") * 100)) .. "% of the damage dealt.",
				"But, self-damage is equal to " .. tostring(tonumber(GlobalsGetValue("COMEDIC_HURT_FACTOR", "0.66") * 100)) .. "% of the damage dealt!",
				"",
				"Be careful, and don't miss!",
			}
		}
	end,
	["first_wand"] = function()
		dofile("mods/noiting_simulator/files/wands/_list.lua")
		local sum = Rarities[1] + Rarities[2] + Rarities[3] + Rarities[4]
		local new1 = tostring(math.floor((Rarities[1] / sum) * 1000) / 10) .. "%"
		local new2 = tostring(math.floor((Rarities[2] / sum) * 1000) / 10) .. "%"
		local new3 = tostring(math.floor((Rarities[3] / sum) * 1000) / 10) .. "%"
		local new4 = tostring(math.floor((Rarities[4] / sum) * 1000) / 10) .. "%"

		return {
			icon = "mods/noiting_simulator/files/wands/wand_glow_mini.png", color = {136, 75, 176},
			lines = {
				"Each spell has a different RARITY that determines how often it appears.",
				"A wand's colored GLOW is determined by the highest-RARITY spell on the wand.",
				"",
				"Around " .. new1 .. " of spells you find will be GREEN: COMMON.",
				"Around " .. new2 .. " of spells you find will be BLUE: UNCOMMON.",
				"Around " .. new3 .. " of spells you find will be PURPLE: RARE.",
				"Around " .. new4 .. " of spells you find will be RED: ULTIMATE.",
				"",
				"You can also view a spell's rarity as colored pips in the STORAGE BOX."
			}
		}
	end,
	["second_wand"] = function()
		return {
			icon = "mods/noiting_simulator/files/gui/mana_gem.png", color = {63, 235, 255},
			lines = {
				"Pay attention to your CURRENT MANA, MANA RECHARGE SPEED, and MANA MAX!",
				"All of these are now SHARED BETWEEN WANDS!!",
				"",
				"Your natural mana max is " .. GlobalsGetValue("INHERENT_STARTING_MANA_MAX", "???") .. ".",
				"Wands will add to this with their 'Mana Max+' stat.",
				"",
				"Your natural mana charge speed is " .. GlobalsGetValue("INHERENT_STARTING_MANA_CHG", "???") .. " per second.",
				"Wands will add to this with their 'Mana Chg+' stat.",
			}
		}
	end,
	["party_reminder"] = function()
		return {
			icon = "mods/noiting_simulator/files/gui/battle_star.png", color = {185, 109, 40},
			lines = {
				"Look for the STAR icon to enter an ENCOUNTER with someone.",
				"Succeed to take them on a DATE.",
				"Your objective: Go on three DATES with any one character!",
				"Get it done before the party on Sunday night!"
			}
		}
	end,
	["card_alwayscasts"] = function()
		return {
			icon =  "data/ui_gfx/inventory/item_bg_modifier.png", color = {28, 109, 115},
			lines = {
				"TIP:",
				"ALWAYS CASTS will now consume your mana!",
				"Changes to CAST DELAY or RECHARGE TIME will be ignored, as usual."
			}
		}
	end,
	["card_activate"] = function()
		return {
			icon = "data/ui_gfx/inventory/item_bg_other.png", color = {115, 90, 20},
			lines = {
				"TIP:",
				"RIGHT-CLICK to use an ACTIVATE SPELL.",
				"Multiple ACTIVATE SPELLS won't play nice together:",
				"You can only have ONE on each wand. Choose wisely!",
				"Some ACTIVATE spells also act like MODIFIERS or PASSIVES.",
			}
		}
	end,
	["card_passive"] = function()
		return {
			icon = "data/ui_gfx/inventory/item_bg_passive.png", color = {53, 111, 68},
			lines = {
				"TIP:",
				"PASSIVE SPELLS will now activate when on ANY WAND in your inventory!",
				"The wand doesn't need to be in your hand!",
			}
		}
	end,
	["battle_win"] = function()
		return {
			icon = "mods/noiting_simulator/files/gui/smiley.png", color = {194, 136, 209},
			lines = {
				"Congratulations on your first victory in an ENCOUNTER!",
				"...What are you reading this for?! Go enjoy your date!",
				"",
				"",
				"",
				"",
				"",
				"...Hey! Their SHELL's max health will go up after each date!",
				"Be prepared to charm them even better next time!",
			}
		}
	end,
	["battle_lose"] = function()
		return {
			icon = "mods/noiting_simulator/files/gui/frowny.png", color = {226, 94, 134},
			lines = {
				"Too exhausted to finish an ENCOUNTER? Don't sweat it!",
				"Any damage to someone's SHELL will persist to your next ENCOUNTER with them!",
				"Dust yourself off, prepare your finest SPELLS and ITEMS, and try again soon...!"
			}
		}
	end,
}

local assets = {
	font_small = "mods/noiting_simulator/files/gui/fonts/font_small_numbers.xml",
	box = "mods/noiting_simulator/files/gui/boxes/box.png",
	box_red = "mods/noiting_simulator/files/gui/boxes/box_red.png",
	button = "mods/noiting_simulator/files/gui/feed_button.png",
	trash = "mods/noiting_simulator/files/gui/trash.png",
	battle_star = "mods/noiting_simulator/files/gui/battle_star.png",
}

function CallFeedMessage(id)
	if not GameHasFlagRun("feed_message_" .. tostring(id)) then
		GameAddFlagRun("feed_message_" .. tostring(id))
		local feed = smallfolk.loads(GlobalsGetValue("NS_FEED", "{}")) or {}
		feed[#feed+1] = feed_messages[id]()
		GlobalsSetValue("NS_FEED", smallfolk.dumps(feed))
	end
end

return function()
	Gui6 = Gui6 or GuiCreate()

	local width = SCREEN_W * 0.2
	local x, y = SCREEN_W / 2, 0
	local feed = smallfolk.loads(GlobalsGetValue("NS_FEED", "{}")) or {}
	if #feed == 0 then return end
	if ModSettingGet("noiting_simulator.cheatcode_knowitall") == true then return end

    local _id = 11111
    local function id()
        _id = _id + 1
        return _id
    end

	local text_line_height = 10
	local img_scale = 1

	if ModSettingGet("noiting_simulator.cheatcode_cheater") then
		for i = 1, 10 do
			feed[i] = {color = {0, 0, 0, 0}, read = 2}
		end
		local storage = tostring(GlobalsGetValue("NS_BATTLE_STORAGE", ""))
		if storage and storage ~= "" then
			local v = smallfolk.loads(storage)
			v.tempolevel = (Feed_index or 0)
			GlobalsSetValue("NS_BATTLE_STORAGE", smallfolk.dumps(v))
		end
		GlobalsSetValue("NS_FEED", smallfolk.dumps(feed))
	end

	if #feed >= 9 and not ModSettingGet("noiting_simulator.feed_feed_feed") then
		ModSettingSet("noiting_simulator.feed_feed_feed", true)
		feed[#feed+1] = {icon = "data/ui_gfx/inventory/icon_damage_drill.png", color = {153, 143, 147},
			lines = {
				"Getting annoyed by all this helpful information???",
				"Enter CHEAT CODE [knowitall] in the MOD SETTINGS MENU.",
				"But be careful! You might miss something actually important!",
				"Also, this message won't show up in future runs.",
				":)"
			}
		}
		GlobalsSetValue("NS_FEED", smallfolk.dumps(feed))
	end

	local feed_font = DEFAULT_FONT
	local feed_scale = DEFAULT_SIZE * (1 / 1.4)
	local feed_line_spacing = LINE_SPACING * (1 / 10)

	GuiStartFrame(Gui6)
	GuiOptionsAdd(Gui6, 6)
	GuiZSetForNextWidget(Gui6, 30)
	GuiOptionsAdd(Gui6, 4) -- ClickCancelsDoubleClick; ???
	GuiOptionsAdd(Gui6, 8) -- HandleDoubleClickAsClick; spammable buttons
	Feed_index = Feed_index or 0
	if GameIsInventoryOpen() or GlobalsGetValue("NS_STORAGE_BOX_FRAME", "0") ~= "0" then
		Feed_index = 0
		return
	end
	local height = text_line_height
	local iw, ih = GuiGetImageDimensions(Gui6, assets.button, 1)
	local ck, rk = GuiImageButton(Gui6, id(), x - (iw / 2), y, "", assets.button)
	if Feed_index == 0 then GuiTooltip(Gui6, "$ns_notes", "") end
	local t_string = tostring(Feed_index) .. "o" .. tostring(#feed)
	local tw, th = GuiGetTextDimensions(Gui6, t_string, 1, 0, assets.font_small)
	local r, g, b, a = 1, 1, 1, 1
	for i = 1, #feed do
		if Feed_index ~= i and feed[i].read == 1 then
			feed[i].read = 2
			GlobalsSetValue("NS_FEED", smallfolk.dumps(feed))
		elseif feed[i].read == nil then
			g, b = 0.1, 0.1
		end
	end

	GuiColorSetForNextWidget(Gui6, r, g, b, a)
	GuiText(Gui6, x + (tw / -2), y + 2, t_string, 1, assets.font_small)
	if ck then Feed_index = (Feed_index + 1) % (#feed + 1) end
	if rk then Feed_index = (Feed_index - 1) % (#feed + 1) end
	y = y + height + text_line_height - 8

	if feed[Feed_index] then
		local this = feed[Feed_index] or {}
		this.icon = this.icon or assets.battle_star
		this.lines = this.lines or {}
		this.width = this.width or width
		if this.read == nil then
			this.read = 1
			for j = 1, #this.lines do
				tw, th = GuiGetTextDimensions(Gui6, this.lines[j], feed_scale, 0, feed_font)
				this.width = math.max(this.width, tw)
			end
			GlobalsSetValue("NS_FEED", smallfolk.dumps(feed))
		end
		local scale_for_this_thing = 2
		local str = "#" .. tostring(Feed_index)
		tw, th = GuiGetTextDimensions(Gui6, str, scale_for_this_thing * feed_scale, 0, feed_font)

		iw, ih = GuiGetImageDimensions(Gui6, this.icon, img_scale)
		img_scale = 28 / ih
		iw, ih = GuiGetImageDimensions(Gui6, this.icon, img_scale)
		this.width = this.width + 10
		height = (#this.lines * (text_line_height * feed_line_spacing)) + ih + 6

		GuiZSetForNextWidget(Gui6, 26)
		GuiColorSetForNextWidget(Gui6, 0.25, 0.25, 0.25, 1)
		GuiText(Gui6, x + (this.width / 2) - tw, y, str, scale_for_this_thing * feed_scale, feed_font)
		GuiZSetForNextWidget(Gui6, 30)
		GuiImageNinePiece(Gui6, id(), x + (this.width / -2), y, this.width, height, 1, this.read == 2 and assets.box or assets.box_red)
		GuiZSetForNextWidget(Gui6, 29)
		GuiImage(Gui6, id(), x + (iw / -2), y + 2, this.icon, 1, img_scale)
		GuiZSetForNextWidget(Gui6, 28)
		local y2 = y + ih + 4
		for j = 1, #this.lines do
			tw, th = GuiGetTextDimensions(Gui6, this.lines[j], feed_scale, 1, feed_font)
			GuiColorSetForNextWidget(Gui6, (this.color[1] or 255) / 255, (this.color[2] or 255) / 255, (this.color[3] or 255) / 255, (this.color[4] or 255) / 255)
			GuiText(Gui6, x - tw / 2, y2, this.lines[j], feed_scale, feed_font)
			y2 = y2 + (text_line_height * feed_line_spacing)
		end
		y = y + height
	end
end