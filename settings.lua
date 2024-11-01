dofile("data/scripts/lib/mod_settings.lua") -- see this file for documentation on some of the features.

function mod_setting_bool_custom( mod_id, gui, in_main_menu, im_id, setting )
	local value = ModSettingGetNextValue( mod_setting_get_id(mod_id,setting) )
	local text = setting.ui_name .. " - " .. GameTextGet( value and "$option_on" or "$option_off" )

	if GuiButton( gui, im_id, mod_setting_group_x_offset, 0, text ) then
		ModSettingSetNextValue( mod_setting_get_id(mod_id,setting), not value, false )
	end

	mod_setting_tooltip( mod_id, gui, in_main_menu, setting )
end

function mod_setting_change_callback( mod_id, gui, in_main_menu, setting, old_value, new_value  )
	print( tostring(new_value) )
end

local mod_id = "noiting_simulator"
mod_settings_version = 1
mod_settings = 
{
	{
		id = "name",
		ui_name = "player name",
		ui_description = "fancy up later",
		value_default = "",
		text_max_length = 20,
		allowed_characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz",
		scope = MOD_SETTING_SCOPE_RUNTIME,
		change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
	},
	{
		id = "pronouns",
		ui_name = "characters pronouns",
		ui_description = "fancy up later",
		value_default = "they",
		values = { {"they","They/Them for all characters"}, {"he","He/Him for all characters"}, {"she","She/Her for all characters"}, {"it","It/Its for all characters"}, {"dev","Developers' Choice"}, {"random","Random"} },
		scope = MOD_SETTING_SCOPE_RUNTIME,
		change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
	},
	{
		id = "max_lines",
		ui_name = "max rendered lines",
		ui_description = "How many lines of text to render for scrolling up in the box.\nLarge values might cause performance impacts.",
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
