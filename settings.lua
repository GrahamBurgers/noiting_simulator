dofile("data/scripts/lib/mod_settings.lua") -- see this file for documentation on some of the features.

CHARACTERS = {
	{id = "SET ALL", default = "Default"},
	-- MAJOR CHARACTERS
	{id = "Kolmi", name = "Kolmisilmä", default = "They/Them", desc = "The knowledgeable one"},
	{id = "Parantajahiisi", default = "She/Her", desc = "The Hiisi healer"},
	{id = "Stendari", default = "She/Her", desc = "The fire mage"},
	{id = "Ukko", default = "He/Him", desc = "The thunder mage"},
	{id = "Stevari", default = "He/Him", desc = "The Holy Mountain's guardian"},
	{id = "Snipuhiisi", default = "He/Him", desc = "The sniper"},
	{id = "Polymage", name = "Muodonmuutosmestari", default = "She/Her", desc = "The healer"},
	{id = "Jattimato", name = "Jättimato", default = "She/Her", desc = "The giant worm"},
	{id = "ThreeHamis", name = "Stranger", default = "They/Them", desc = "The unfamiliar"},
	{id = "Kummitus", default = "It/Its", desc = "The reflection of you"},
	{id = "Squidward", name = "Sauvojen Tuntija", default = "They/Them", desc = "The connoisseur of wands"},
	{id = "Deer", name = "Tapion Vasalli", default = "He/Him", desc = "The vengeance of the helpless"},
	{id = "Leviathan", name = "Syväolento", default = "They/Them", desc = "The creature of the deep"},
	-- MINOR CHARACTERS
	{id = "Kivi", default = "It/Its", desc = "The rock"},
	{id = "Skoude", default = "He/Him", desc = "The guardian's older sibling"},
	{id = "Patsas", default = "It/Its", desc = "The statue"},
	{id = "Raukka", default = "She/Her", desc = "The coward"},
	{id = "Swampling", name = "Märkiäinen", default = "She/Her", desc = "The swampy shambler"},
	{id = "Friend", name = "Toveri", default = "He/Him", desc = "The beloved"},
	{id = "Alchemist", name = "Ylialkemisti", default = "He/Him", desc = "The leader of none"},
	-- {id = "Dragon", name = "Suomuhauki", default = "She/Her", desc = "The "},
	-- {id = "Tiny", name = "Limatoukka", default = "He/Him", desc = "The "},
	{id = "Cabbage", name = "Kolmisilmän Koipi", default = "They/Them", desc = "The undead piece of the whole"},
	{id = "Meat", name = "Kolmisilmän sydän", default = "They/Them", desc = "The fleshy piece of the whole"},
	{id = "Mecha", name = "Kolmisilmän silmä", default = "It/Its", desc = "The mechanical piece of the whole"},
	{id = "Forgotten", name = "Unohdettu", default = "He/Him", desc = "The lost one"},
	{id = "Sunseed", name = "Auringonsiemen", default = "It/Its", desc = "The precursor"},
	{id = "Sun", name = "Uusi Aurinko", default = "She/Her", desc = "The embodiment of light"},
	{id = "Dark Sun", name = "Pimeä Aurinko", default = "He/Him", desc = "The embodiment of dark"},
}

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
	{name = "Default", func = function(id, def) set(id, def) end},
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
	local long, _ = GuiGetTextDimensions(gui, "Muodonmuutosmestari")
	for i = 1, #list do
		GuiLayoutBeginHorizontal(gui, 0, 0, false, 6, 0)
		local t = list[i]
		t.name = (t.name or t.id or "error")
		-- use this in place of HasFlagPersistent: ModSettingSet("noiting_simulator.met_Kolmi", true)
		if not ModSettingGet("noiting_simulator.met_" .. t.id) and t.id ~= "SET ALL" then
			t.name = "???"
		end
		GuiZSet(gui, -300)

		local w, h = GuiGetTextDimensions(gui, t.name)
		GuiColorSetForNextWidget(gui, 0.5, 0.65, 0.5, 1.0)
		if t.id == "SET ALL" then
			GuiColorSetForNextWidget(gui, 0.7, 0.8, 1.0, 1.0)
		end
		GuiText(gui, 4, 0, t.name)
		if t.desc then GuiTooltip(gui, t.desc, "") end
		w = -w + long

		for j = 1, #p do
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
				GuiOptionsAddForNextWidget(gui, 8) -- spammable buttons
				local lmb, rmb = GuiButton(gui, id(), w, 0, p[j].name)
				if lmb and p[j].func then
					p[j].func(t.id, t.default)
				end
			end
			w = 0
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
end

local function text(gui)
	local size = tonumber(ModSettingGetNextValue("noiting_simulator.text_size"))
	local font = tostring(ModSettingGetNextValue("noiting_simulator.font"))
	local shadow_offset = tonumber(ModSettingGetNextValue("noiting_simulator.shadow_offset"))
	local shadowdark = tonumber(ModSettingGetNextValue("noiting_simulator.shadow_darkness"))
	local linebreak = size * ModSettingGetNextValue("noiting_simulator.line_spacing")
	local tickrate = math.floor(tonumber(ModSettingGetNextValue("noiting_simulator.speed")) or 2)

	local texts  = {"Most text will look like this", "And like this if there are multiple lines", "This text is blue!"}
	---@diagnostic disable-next-line: deprecated
	local rtexts = {unpack(texts)}
	-- animation logic
	if Frame2 > 200 and Frame1 > 180 then
		Frame1 = 0
		Frame2 = 0
	end
	if tickrate >= 0 or (Frame1 % (tickrate * -1) == 0) then
		Frame2 = Frame2 + math.max(1, tickrate)
	end
	local frame3 = Frame2

	for i = 1, #texts do
		texts[i] = texts[i]:sub(1, frame3)
		frame3 = frame3 - string.len(texts[i])
	end

	-- draw the actual text here

	local c, rc, rh, x, y = GuiGetPreviousWidgetInfo(gui)
	y = y + 11
	GuiLayoutBeginLayer(gui)
		for i = 1, #rtexts do
			local r, g, b, a = 1, 1, 1, 1
			if i == 3 then
				r, g, b, a = 0.3, 0.5, 0.9, 1.00
			end
			local sr, sg, sb, sa = r * shadowdark, g * shadowdark, b * shadowdark, a
			-- text
			GuiZSetForNextWidget(gui, 2)
			GuiColorSetForNextWidget(gui, r, g, b, a)
			GuiText(gui, x, y, texts[i], size, font)
			-- shadow
			GuiZSetForNextWidget(gui, 4)
			GuiColorSetForNextWidget(gui, sr, sg, sb, sa)
			GuiText(gui, x + size * shadow_offset, y + size * shadow_offset, texts[i], size, font)
			-- text invis
			GuiZSetForNextWidget(gui, 2)
			GuiColorSetForNextWidget(gui, r, g, b, -1)
			GuiText(gui, x, y, rtexts[i], size, font)
			-- shadow invis
			GuiZSetForNextWidget(gui, 4)
			GuiColorSetForNextWidget(gui, sr, sg, sb, -1)
			GuiText(gui, x + size * shadow_offset, y + size * shadow_offset, rtexts[i], size, font)
			y = y + linebreak
		end
	GuiLayoutEndLayer(gui)
end

function mod_setting_change_callback()
	if GameGetFrameNum() > 0 then
		GlobalsSetValue("NS_SETTING_RECALC", "1")
	end
end

mod_settings_version = 1
mod_settings = 
{
	{
		id = "name",
		ui_name = "Your name:",
		ui_description = "What you want characters to call you!",
		value_default = "",
		text_max_length = 20,
		allowed_characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz",
		scope = MOD_SETTING_SCOPE_RUNTIME,
		change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
	},
	{
		category_id = "pronouns",
		ui_name = "Character pronouns",
		ui_description = "The words used to refer to characters.\nCharacters that you haven't met yet are hidden.",
		foldable = true,
		_folded = true,
		settings = {
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
				ui_name = "Right click any value to reset to default.",
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
				value_default = "data/fonts/font_pixel_noshadow.xml",
				values = { {"data/fonts/font_pixel_noshadow.xml","Pixel"}, {"data/fonts/font_pixel_huge.xml","Huge pixel"},
				{"data/fonts/ubuntu_condensed_10.xml","Ubuntu Condensed (10px)"}, {"data/fonts/ubuntu_condensed_18.xml","Ubuntu Condensed (18px)"},
				{"data/fonts/font_pixel_runes.xml","Glyphs"}},
				scope = MOD_SETTING_SCOPE_RUNTIME,
				change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
			},
			{
				id = "shadow_offset",
				ui_name = "Shadow offset",
				ui_description = "The distance between text and its shadow.",
				value_min = 0,
				value_default = 0.5,
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
				id = "speed",
				ui_name = "Text tickrate",
				ui_description = [[The default rate at which text draws on the screen.
This may be overridden in some situations.
Positive values: How many characters drawn per frame.
Negative values: How many frames to draw a character.]],
				value_min = -3.5,
				value_default = 1,
				value_max = 4,
				scope = MOD_SETTING_SCOPE_RUNTIME,
				change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
			},
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
		}
	},
}

function ModSettingsUpdate( init_scope )
	local old_version = mod_settings_get_version( mod_id ) -- This can be used to migrate some settings between mod versions.
	mod_settings_update( mod_id, mod_settings, init_scope )
end
function ModSettingsGuiCount()
	return mod_settings_gui_count( mod_id, mod_settings )
end
