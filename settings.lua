dofile("data/scripts/lib/mod_settings.lua") -- see this file for documentation on some of the features.

CHARACTERS = {
	{id = "SET ALL", default = "Default"},
	-- MAJOR CHARACTERS
	{id = "Kolmi", name = "Kolmisilmä", default = "They/Them", desc = "The knowledgeable one"},
	{id = "Stendari", default = "She/Her", desc = "The fire mage"},
	{id = "Ukko", default = "He/Him", desc = "The thunder mage"},
	{id = "Stevari", default = "He/Him", desc = "The Holy Mountain's guardian"},
	{id = "Snipuhiisi", default = "He/Him", desc = "The sniper"},
	{id = "Polymage", name = "Muodonmuutosmestari", default = "She/Her", desc = "The healer"},
	{id = "Sunseed", name = "Auringonsiemen", default = "It/Its", desc = "The precursor"},
	{id = "Sun", name = "Uusi Aurinko", default = "She/Her", desc = "The embodiment of light"},
	{id = "Dark Sun", name = "Pimeä Aurinko", default = "He/Him", desc = "The embodiment of dark"},
	{id = "Jattimato", name = "Jättimato", default = "She/Her", desc = "The giant worm"},
	{id = "Parantajahiisi", default = "She/Her", desc = "The Hiisi healer"},
	{id = "ThreeHamis", name = "Stranger", default = "They/Them", desc = "The unfamiliar"},
	{id = "Kummitus", default = "It/Its", desc = "The reflection of you"},
	{id = "Squidward", name = "Sauvojen Tuntija", default = "They/Them", desc = "The connoisseur of wands"},
	{id = "Mecha", name = "Kolmisilmän silmä", default = "It/Its", desc = "The "},
	{id = "Deer", name = "Tapion Vasalli", default = "She/Her", desc = "The vengeance of the helpless"},
	{id = "Leviathan", name = "Syväolento", default = "They/Them", desc = "The creature of the deep"},
	-- MINOR CHARACTERS
	{id = "Kivi", default = "It/Its", desc = "The rock"},
	{id = "Skoude", default = "He/Him", desc = "The guardian's older sibling"},
	{id = "Patsas", default = "It/Its", desc = "The statue"},
	{id = "Raukka", default = "She/Her", desc = "The coward"},
	{id = "Swampling", name = "Märkiäinen", default = "She/Her", desc = "The swampy shambler"},
	{id = "Friend", name = "Toveri", default = "He/Him", desc = "The "},
	{id = "Alchemist", name = "Ylialkemisti", default = "He/Him", desc = "The "},
	{id = "Dragon", name = "Suomuhauki", default = "She/Her", desc = "The "},
	{id = "Tiny", name = "Limatoukka", default = "He/Him", desc = "The "},
	{id = "Cabbage", name = "Kolmisilmän Koipi", default = "They/Them", desc = "The "},
	{id = "Meat", name = "Kolmisilmän sydän", default = "They/Them", desc = "The "},
	{id = "Forgotten", name = "Unohdettu", default = "He/Him", desc = "The "},
}

function mod_setting_bool_custom( mod_id, gui, in_main_menu, im_id, setting )
	local value = ModSettingGetNextValue( mod_setting_get_id(mod_id,setting) )
	local text = setting.ui_name .. " - " .. GameTextGet( value and "$option_on" or "$option_off" )

	if GuiButton( gui, im_id, mod_setting_group_x_offset, 0, text ) then
		ModSettingSetNextValue( mod_setting_get_id(mod_id,setting), not value, false )
	end

	mod_setting_tooltip( mod_id, gui, in_main_menu, setting )
end

function mod_setting_change_callback( mod_id, gui, in_main_menu, setting, old_value, new_value  )
	-- print( tostring(new_value) )
end

local r = {"He/Him", "She/Her", "They/Them", "It/Its"}
local function set(id, value)
	if id == "SET ALL" then
		for i = 1, #CHARACTERS do
			if value == "Default" then
				ModSettingSet("noiting_simulator.p_" .. CHARACTERS[i].id, CHARACTERS[i].default)
			else
				ModSettingSet("noiting_simulator.p_" .. CHARACTERS[i].id, value == "Random" and r[math.random(1, #r)] or value)
			end
		end
	else
		ModSettingSet("noiting_simulator.p_" .. id, (value == "Random" and r[math.random(1, #r)]) or value)
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
local function reset_all()
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
				GuiColorSetForNextWidget(gui, 0.7, 0.7, 1.0, 1.0)
			elseif r[j] and (ModSettingGet("noiting_simulator.p_" .. t.id) == r[j]) then
				GuiColorSetForNextWidget(gui, 0.8, 1.0, 1.0, 1.0)
			else
				GuiColorSetForNextWidget(gui, 0.3, 0.2, 0.3, 1.0)
			end
			GuiOptionsAddForNextWidget(gui, 8)
			local lmb, rmb = GuiButton(gui, id(), w, 0, p[j].name)
			if lmb and p[j].func then
				p[j].func(t.id, t.default)
				dofile("mods/noiting_simulator/files/scripts/characters.lua")
			end
			w = 0
		end

		GuiLayoutEnd(gui)
	end
	return y
end

local mod_id = "noiting_simulator"
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
				scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
				ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
					local spacing = pronouns(gui, im_id, CHARACTERS)
					GuiLayoutAddVerticalSpacing(gui, spacing)
				end
			},
		}
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
}

function ModSettingsUpdate( init_scope )
	local old_version = mod_settings_get_version( mod_id ) -- This can be used to migrate some settings between mod versions.
	mod_settings_update( mod_id, mod_settings, init_scope )
end
function ModSettingsGuiCount()
	return mod_settings_gui_count( mod_id, mod_settings )
end

-- This function is called to display the settings UI for this mod. Your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
function ModSettingsGui( gui, in_main_menu )
	mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )
end
