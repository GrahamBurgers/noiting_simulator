---@diagnostic disable: undefined-global
dofile("data/scripts/lib/mod_settings.lua") -- see this file for documentation on some of the features.

CHARACTERS = {
	{id = "SET ALL", default = "Default"},
	--[[!!!!!!!!!!!!!!]] {id = "--- Love interests ---", default = "Default", fake = true},
	{major = true, c = true, default = "He/Him",    id = "Parantajahiisi", desc = "The Hiisi healer", color = {334, 38, 73, 255}, icon = "data/ui_gfx/animal_icons/scavenger_heal.png"},
	{major = true, c = true, default = "She/Her",   id = "Stendari",       desc = "The fire mage", color = {204, 94, 49, 255}, icon = "data/ui_gfx/animal_icons/firemage_weak.png"},
	{major = true, c = true, default = "He/Him",    id = "Ukko",           desc = "The thunder mage", color = {92, 136, 191, 255}, icon = "data/ui_gfx/animal_icons/thundermage.png"},
	{major = true, c = true, default = "She/Her",   id = "Kilpihiisi",     desc = "The Hiisi shielder", color = {255, 255, 255, 255}, icon = "data/ui_gfx/animal_icons/scavenger_shield.png"},
	{major = true, c = true, default = "They/Them", id = "Hamis", name = "Stranger", desc = "The stranger", color = {82, 49, 111, 255}, icon = "data/ui_gfx/animal_icons/longleg.png"},
	{major = true, c = true, default = "She/Her",   id = "Munkki", desc = "The hermit", color = {255, 255, 255, 255}, icon = "data/ui_gfx/animal_icons/monk.png"},
	{major = true, c = true, default = "It/Its",    id = "Necrobot", desc = "The resurrector", color = {255, 255, 255, 255}, icon = "data/ui_gfx/animal_icons/necrobot.png"},
	{major = true, c = true, default = "She/Her",   id = "Assassin", name = "Salamurhaajarobotti", desc = "The assassin robot", color = {255, 255, 255, 255}, icon = "data/ui_gfx/animal_icons/assassin.png"},
	{major = true, c = true, default = "He/Him",    id = "Stevari", desc = "The holy guardian", color = {98, 46, 53, 255}, icon = "data/ui_gfx/animal_icons/necromancer_shop.png"},
	{major = true, c = true, default = "He/Him",    id = "Leggy", name = "Jalkamatkatavara", desc = "The leggy mimic", color = {255, 255, 255, 255}, icon = "data/ui_gfx/animal_icons/chest_leggy.png"},
	{major = true, c = true, default = "They/Them", id = "Shapechanger", name = "Hahmonvaihtaja", desc = "The shapeshifter", color = {255, 255, 255, 255}, icon = "data/ui_gfx/animal_icons/necromancer.png"},
	{major = true, c = true, default = "It/Its",    id = "Kummitus", desc = "The reflection of you", color = {54, 45, 57, 255}, icon = "data/ui_gfx/animal_icons/playerghost.png"},
	{id = "--- Minor Characters ---", default = "Default", fake = true},
	{c = true, id = "Kolmi", name = "Kolmisilmä", default = "They/Them", desc = "The knowledgeable one", color = {62, 110, 104, 255}, icon = "data/ui_gfx/animal_icons/boss_centipede.png"},
}
for i = 1, #CHARACTERS do
	local t = CHARACTERS[i]
	if t.c then
		if ModSettingGet("noiting_simulator.met_" .. t.id) then
			t.name = tostring(ModSettingGet("noiting_simulator.nick_" .. t.id) or t.name or t.id)
		else
			t.name = "???"
			t.icon = "data/ui_gfx/icon_unkown_gunaction.png"
			t.desc = t.major and t.desc or "???"
		end
	end
end

function mod_setting_bool_custom( mod_id, gui, in_main_menu, im_id, setting )
	local value = ModSettingGetNextValue( mod_setting_get_id(mod_id,setting) )
	local text = setting.ui_name .. " - " .. GameTextGet( value and "$option_on" or "$option_off" )

	if GuiButton( gui, im_id, mod_setting_group_x_offset, 0, text ) then
		ModSettingSetNextValue( mod_setting_get_id(mod_id,setting), not value, false )
	end

	mod_setting_tooltip( mod_id, gui, in_main_menu, setting )
end

local pr = {"He/Him", "She/Her", "They/Them", "It/Its"}
local function set(id, value)
	if id == "SET ALL" then
		for i = 1, #CHARACTERS do
			if value == "Default" then
				ModSettingSet("noiting_simulator.p_" .. CHARACTERS[i].id, CHARACTERS[i].default)
			else
				ModSettingSet("noiting_simulator.p_" .. CHARACTERS[i].id, (value == "Random" and pr[math.random(1, #pr)]) or value)
			end
		end
	else
		ModSettingSet("noiting_simulator.p_" .. id, (value == "Random" and pr[math.random(1, #pr)]) or value)
	end
end
local p = {
	{name = "He/Him", func = function(id, def) set(id, "He/Him") end},
	{name = "She/Her", func = function(id, def) set(id, "She/Her") end},
	{name = "They/Them", func = function(id, def) set(id, "They/Them") end},
	{name = "It/Its", func = function(id, def) set(id, "It/Its") end},
	-- {name = "Default", func = function(id, def) set(id, def) end},
	{name = "Random", func = function(id, def) set(id, "Random") end}
}
function Reset_all()
	set("SET ALL", "Default")
	for i = 1, #CHARACTERS do
		ModSettingSet("noiting_simulator.met_" .. CHARACTERS[i].id, false)
	end
end
local function pronouns(gui, im_id, list)
	local _id = 40
	local function id()
		_id = _id + 1
		return _id
	end
	local x, y = 4, 0
	local longest = "Muodonmuutosmestari!!"
	local long, _ = GuiGetTextDimensions(gui, longest)
	for i = 1, #list do
		GuiLayoutBeginHorizontal(gui, 0, 0, false, 6, 0)
		local t = list[i]
		t.name = (t.name or t.id or "error")
		-- use this in place of HasFlagPersistent: ModSettingSet("noiting_simulator.met_Kolmi", true)
		local w = 0
		GuiZSet(gui, -300)

		local alpha = (t.color and 1) or 0
		t.icon = t.icon or "data/ui_gfx/icon_unkown_gunaction.png"
		local img_input_h = 11
		local img_scale = 0.70
		local iw, ih = GuiGetImageDimensions(gui, t.icon, img_scale)
		GuiImage(gui, id(), 6, (img_input_h - ih) * 0.5, t.icon, alpha, img_scale, img_scale, 0)
		local nick = t.name
		if not t.color then
			GuiColorSetForNextWidget(gui, 0.7, 0.8, 1.0, 1.0)
		else
			nick = tostring(ModSettingGet("noiting_simulator.nick_" .. t.id))
			GuiColorSetForNextWidget(gui, t.color[1] / 255, t.color[2] / 255, t.color[3] / 255, t.color[4] / 255)
		end

		if t.c and t.name ~= "???" then
			local ck, rk = GuiGetPreviousWidgetInfo(gui)
			local thing = GuiTextInput(gui, id(), 4, 0, nick or t.name, long, string.len(longest), "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÄäÖö- ")
			local ck2, rk2 = GuiGetPreviousWidgetInfo(gui)
			if t.desc then GuiTooltip(gui, t.desc, "") end
			if rk or rk2 then thing = t.name end
			if nick ~= thing then ModSettingSet("noiting_simulator.nick_" .. t.id, thing) end
			if t.color then GuiColorSetForNextWidget(gui, t.color[1] / 255, t.color[2] / 255, t.color[3] / 255, t.color[4] / 255) end
			GuiZSet(gui, -400)
			GuiText(gui, -long - 8, 0, thing)
			local size = GuiGetTextDimensions(gui, thing)
			w = long - size - 2
		else
			w = long - GuiGetTextDimensions(gui, t.name)
			if t.fake then
				GuiColorSetForNextWidget(gui, 1.0, 1.0, 1.0, 1.0)
				GuiText(gui, 100, 0, t.name)
			else
				GuiText(gui, 4, 0, t.name)
			end
			if t.desc then GuiTooltip(gui, t.desc, "") end
		end
		GuiZSet(gui, -300)

		for j = 1, #p do
			if not t.fake then
				if t.id == "SET ALL" then
					-- top row
					GuiColorSetForNextWidget(gui, 0.7, 0.7, 1.0, 1.0)
				elseif pr[j] and (ModSettingGet("noiting_simulator.p_" .. t.id) == pr[j]) or (pr[j] == t.default and (ModSettingGet("noiting_simulator.p_" .. t.id) == nil)) then
					-- selected option (or default with nil)
					GuiColorSetForNextWidget(gui, 0.8, 1.0, 1.0, 1.0)
				elseif pr[j] == t.default then
					-- default option
					GuiColorSetForNextWidget(gui, 0.5, 0.4, 0.3, 1.0)
				else
					-- not selected
					GuiColorSetForNextWidget(gui, 0.3, 0.2, 0.3, 1.0)
				end
				if p[j].name == "Random" and not (GameGetFrameNum() > 0) then
					-- can't do random when in main menu
					GuiColorSetForNextWidget(gui, 0.2, 0, 0, 1.0)
					GuiText(gui, w, 0, p[j].name)
					GuiTooltip(gui, "Need to be in a run to use random!", "")
				else
					GuiOptionsAddForNextWidget(gui, 8) -- HandleDoubleClickAsClick; spammable buttons
					local lmb, rmb = GuiButton(gui, id(), w, 0, p[j].name)
					if rmb and p[j].func then
						set(t.id, t.default)
					elseif lmb and p[j].func then
						p[j].func(t.id, t.default)
					end
				end
				w = 0
			end
		end

		GuiLayoutEnd(gui)
	end
	return y
end

local mod_id = "noiting_simulator"
Frame1 = Frame1 or 0
Frame2 = Frame2 or 0
-- This function is called to display the settings UI for this mod. Your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
function ModSettingsGui( gui, in_main_menu )
	Frame1 = Frame1 + 1
	mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )
end

local function text(gui)
	local utf8 = dofile_once("mods/noiting_simulator/files/scripts/utf8.lua")
	local size = tonumber(ModSettingGetNextValue("noiting_simulator.text_size"))
	local font = tostring(ModSettingGetNextValue("noiting_simulator.font"))
	if not ModDoesFileExist(font) then
		font = "data/fonts/font_pixel_noshadow.xml"
	end
	local shadow_offset = tonumber(ModSettingGetNextValue("noiting_simulator.shadow_offset"))
	local shadowdark = tonumber(ModSettingGetNextValue("noiting_simulator.shadow_darkness")) or 0.3
	local linebreak = size * ModSettingGetNextValue("noiting_simulator.line_spacing")
	local tickrate = math.floor(tonumber(ModSettingGetNextValue("noiting_simulator.speed")) or 2)

	local texts  = {"Most text will look like this", "And like this if there are multiple lines", "This text is important.", "This text is very important!"}
	---@diagnostic disable-next-line: deprecated
	local rtexts = {unpack(texts)}
	-- animation logic
	if tickrate >= 0 or (Frame1 % (tickrate * -1) == 0) then
		Frame2 = Frame2 + math.max(1, tickrate)
	end
	local frame3 = Frame2

	for i = 1, #texts do
		texts[i] = utf8.sub(texts[i], 1, frame3)
		frame3 = frame3 - utf8.len(texts[i])
	end

	-- draw the actual text here

	local _, _, _, x, y = GuiGetPreviousWidgetInfo(gui)
	y = y + 11
	local add = 0
	GuiLayoutBeginLayer(gui)
		for i = 1, #rtexts do
			local r, g, b, a, hue = 1, 1, 1, 1, nil
			if i == 3 then hue = ModSettingGetNextValue("noiting_simulator.color1") end
			if i == 4 then hue = ModSettingGetNextValue("noiting_simulator.color2") end
			if hue then
				hue = (hue / 360) % 1
				local segment = math.floor(hue * 6) + 1
				local progress = (hue * 6) % 1

				local things = {
					{1, progress, 0},
					{1 - progress, 1, 0},
					{0, 1, progress},
					{0, 1 - progress, 1},
					{progress, 0, 1},
					{1, 0, 1 - progress}
				}
				r, g, b = things[segment][1], things[segment][2], things[segment][3]
			end
			local sr, sg, sb, sa = r * shadowdark, g * shadowdark, b * shadowdark, a
			if i > 2 then
				-- overlay text
				GuiZSetForNextWidget(gui, 1)
				GuiColorSetForNextWidget(gui, 1, 1, 1, 1)
				GuiText(gui, x, y, texts[i]:sub(1, 13), size, font)
				-- overlay shadow
				GuiZSetForNextWidget(gui, 2)
				GuiColorSetForNextWidget(gui, shadowdark, shadowdark, shadowdark, sa)
				GuiText(gui, x + size * shadow_offset, y + size * shadow_offset, texts[i]:sub(1, 13), size, font)
			end
			-- text
			GuiZSetForNextWidget(gui, 3)
			GuiColorSetForNextWidget(gui, r, g, b, a)
			GuiText(gui, x, y, texts[i], size, font)
			-- shadow
			GuiZSetForNextWidget(gui, 4)
			GuiColorSetForNextWidget(gui, sr, sg, sb, sa)
			GuiText(gui, x + size * shadow_offset, y + size * shadow_offset, texts[i], size, font)
			-- text invis
			GuiZSetForNextWidget(gui, 3)
			GuiColorSetForNextWidget(gui, r, g, b, -1)
			GuiText(gui, x, y, rtexts[i], size, font)
			-- shadow invis
			GuiZSetForNextWidget(gui, 4)
			GuiColorSetForNextWidget(gui, sr, sg, sb, -1)
			GuiText(gui, x + size * shadow_offset, y + size * shadow_offset, rtexts[i], size, font)
			y = y + linebreak
			add = add + linebreak
		end
		GuiOptionsAddForNextWidget(gui, 8) -- HandleDoubleClickAsClick; spammable buttons
		GuiColorSetForNextWidget(gui, 0.5, 0.5, 0.5, 1)
		local ck, rk = GuiButton(gui, 98765, x, y, "[Animate text]", 1, font)
		if ck then Frame1 = 0 Frame2 = 0 end
		local w, h = GuiGetTextDimensions(gui, "[Animate text]", 1, 0, font)
		add = add + h
		y = y + h
	GuiLayoutEndLayer(gui)
	GuiLayoutAddVerticalSpacing(gui, add)
end

function mod_setting_change_callback()
	if GameGetFrameNum() > 0 then
		GlobalsSetValue("NS_SETTING_RECALC", "1")
	end
end

mod_settings_version = 1
mod_settings = 
{
	--[[
	{
		id = "name",
		ui_name = "Your name:",
		ui_description = "What you want characters to call you!",
		value_default = "",
		text_max_length = 20,
		allowed_characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÄäÖö- ",
		scope = MOD_SETTING_SCOPE_RUNTIME,
		change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
	},
	]]--
	{
		id = "ui_scale",
		ui_name = "UI scale",
		ui_description = "The scale of various other user interface elements in the mod.",
		value_min = 1.5,
		value_default = 2,
		value_max = 2.5,
		value_display_multiplier = 50,
		value_display_formatting = " $0%",
		scope = MOD_SETTING_SCOPE_RUNTIME,
		change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
	},
	{
		category_id = "pronouns",
		ui_name = "Character data",
		ui_description = "Pronouns and nicknames for characters.\nCharacters that you haven't met yet are hidden.",
		foldable = true,
		_folded = true,
		settings = {
			{
				id = "nonsense",
				ui_name = "Right click a character's nickname or pronouns to reset it to default.",
				ui_description = "",
				not_setting = true,
				scope = MOD_SETTING_SCOPE_RUNTIME,
				category_id = "thingy",
				settings = {},
			},
			{
				id = "pronouns",
				ui_name = "",
				ui_description = "",
				value_default = false,
				not_setting = true,
				scope = MOD_SETTING_SCOPE_RUNTIME,
				ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
					pronouns(gui, im_id, CHARACTERS)
				end
			},
		}
	},
	{
		category_id = "text",
		ui_name = "Text config",
		ui_description = "Configuration for the look of the text in-game.",
		foldable = true,
		_folded = true,
		settings = {
			{
				id = "nonsense",
				ui_name = "Right click any value to reset to default.\nCustom fonts won't display if Spellbound Hearts isn't loaded.\nChanging these values mid-run might cause strange effects.",
				ui_description = "",
				not_setting = true,
				scope = MOD_SETTING_SCOPE_RUNTIME,
				category_id = "thingy",
				settings = {},
			},
			{
				id = "text_size",
				ui_name = "Text size",
				ui_description = "The default size that most text will use.",
				value_min = 0.4,
				value_default = 1.6,
				value_max = 3.6,
				scope = MOD_SETTING_SCOPE_RUNTIME,
				value_display_formatting = " $0",
				value_display_multiplier = 100,
				change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
			},
			{
				id = "font",
				ui_name = "Text font",
				ui_description = "The default font that most text will use.",
				value_default = "mods/noiting_simulator/files/fonts/font_pixel_noshadow.xml",
				values = {
					{"mods/noiting_simulator/files/fonts/font_pixel_noshadow.xml","Pixel"},
					{"data/fonts/font_pixel_huge.xml","Huge pixel"},
					{"data/fonts/ubuntu_condensed_10.xml","Ubuntu Condensed (10px)"},
					{"data/fonts/ubuntu_condensed_18.xml","Ubuntu Condensed (18px)"},
					{"mods/noiting_simulator/files/fonts/font_pixel_runes_noshadow.xml","Glyphs"},
					{"mods/noiting_simulator/files/fonts/font_pixel_noshadow_i.xml", "TEST"}
				},
				scope = MOD_SETTING_SCOPE_RUNTIME,
				change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
			},
			{
				id = "shadow_offset",
				ui_name = "Shadow offset",
				ui_description = "The distance between text and its shadow.",
				value_min = 0,
				value_default = 0.54,
				value_max = 2,
				value_display_multiplier = 10,
				value_display_formatting = " $0px",
				scope = MOD_SETTING_SCOPE_RUNTIME,
				change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
			},
			{
				id = "shadow_darkness",
				ui_name = "Shadow brightness",
				ui_description = "The brightness of text shadows.",
				value_min = 0,
				value_default = 0.3,
				value_max = 1,
				value_display_multiplier = 100,
				value_display_formatting = " $0%",
				scope = MOD_SETTING_SCOPE_RUNTIME,
				change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
			},
			{
				id = "line_spacing",
				ui_name = "Line spacing",
				ui_description = "The distance between vertical lines of text.",
				value_min = 2,
				value_default = 10,
				value_max = 40,
				value_display_multiplier = 10,
				value_display_formatting = " $0%",
				scope = MOD_SETTING_SCOPE_RUNTIME,
				change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
			},
			{
				id = "color1",
				ui_name = "Emphasis A hue",
				ui_description = "The hue color of emphasized text.",
				value_min = 0,
				value_default = 60,
				value_max = 360,
				scope = MOD_SETTING_SCOPE_RUNTIME,
				change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
			},
			{
				id = "color2",
				ui_name = "Emphasis B hue",
				ui_description = "The hue color of very emphasized text.",
				value_min = 0,
				value_default = 337,
				value_max = 360,
				scope = MOD_SETTING_SCOPE_RUNTIME,
				change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
			},
			{
				id = "speed",
				ui_name = "Text tickrate",
				ui_description = [[The default rate at which text draws on the screen.
Some scenes may override this value.
Positive values: How many characters drawn per frame.
Negative values: How many frames to draw a character.]],
				value_min = -3.5,
				value_default = -1,
				value_max = 4,
				scope = MOD_SETTING_SCOPE_RUNTIME,
				change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
			},
			--[[
			{
				id = "max_lines",
				ui_name = "Max rendered lines",
				ui_description = "How many lines of text to render when scrolling up.\nLarge values might cause performance impacts.",
				value_min = 10,
				value_default = 40,
				value_max = 100,
				scope = MOD_SETTING_SCOPE_RUNTIME,
				change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
			},
			]]--
			{
				id = "text",
				ui_name = "",
				ui_description = "",
				not_setting = true,
				scope = MOD_SETTING_SCOPE_RUNTIME,
				ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
					text(gui)
				end
			},
		},
	},
}

function ModSettingsUpdate( init_scope )
	local old_version = mod_settings_get_version( mod_id ) -- This can be used to migrate some settings between mod versions.
	mod_settings_update( mod_id, mod_settings, init_scope )
end
function ModSettingsGuiCount()
	return mod_settings_gui_count( mod_id, mod_settings )
end
