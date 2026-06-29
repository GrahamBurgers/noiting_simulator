Gui6 = Gui6 or GuiCreate()
local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")

local assets = {
	font_small = "mods/noiting_simulator/files/gui/fonts/font_small_numbers.xml",
	box = "mods/noiting_simulator/files/gui/boxes/box.png",
	box_red = "mods/noiting_simulator/files/gui/boxes/box_red.png",
	button = "mods/noiting_simulator/files/gui/feed_button.png",
	trash = "mods/noiting_simulator/files/gui/trash.png",
	battle_star = "mods/noiting_simulator/files/gui/battle_star.png",
}

return function()
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
	local img_scale = 2

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


	GuiStartFrame(Gui6)
	GuiOptionsAdd(Gui6, 6)
	GuiZSetForNextWidget(Gui6, 30)
	GuiOptionsAdd(Gui6, 4) -- ClickCancelsDoubleClick; ???
	GuiOptionsAdd(Gui6, 8) -- HandleDoubleClickAsClick; spammable buttons
	Feed_index = Feed_index or 0
	if GameIsInventoryOpen() then Feed_index = 0 return end
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
		this.lines = this.lines or {"hello there", "this is a thing", ":)", "yay"}
		this.width = this.width or width
		if this.read == nil then
			this.read = 1
			for j = 1, #this.lines do
				tw, th = GuiGetTextDimensions(Gui6, this.lines[j])
				this.width = math.max(this.width, tw)
			end
			GlobalsSetValue("NS_FEED", smallfolk.dumps(feed))
		end
		local scale_for_this_thing = 2
		local str = "#" .. tostring(Feed_index)
		tw, th = GuiGetTextDimensions(Gui6, str, scale_for_this_thing)

		iw, ih = GuiGetImageDimensions(Gui6, this.icon, img_scale)
		ih = math.max(ih, th * 0.75)
		this.width = this.width + 6
		height = (#this.lines * text_line_height) + ih + 2

		GuiZSetForNextWidget(Gui6, 26)
		GuiColorSetForNextWidget(Gui6, 0.25, 0.25, 0.25, 1)
		GuiText(Gui6, x + (this.width / 2) - tw, y, str, scale_for_this_thing)
		GuiZSetForNextWidget(Gui6, 30)
		GuiImageNinePiece(Gui6, id(), x + (this.width / -2), y, this.width, height, 1, this.read == 2 and assets.box or assets.box_red)
		GuiZSetForNextWidget(Gui6, 29)
		GuiImage(Gui6, id(), x + (iw / -2), y, this.icon, 1, img_scale)
		GuiZSetForNextWidget(Gui6, 28)
		local y2 = y + ih
		for j = 1, #this.lines do
			tw, th = GuiGetTextDimensions(Gui6, this.lines[j])
			GuiColorSetForNextWidget(Gui6, (this.color[1] or 255) / 255, (this.color[2] or 255) / 255, (this.color[3] or 255) / 255, (this.color[4] or 255) / 255)
			GuiText(Gui6, x - tw / 2, y2, this.lines[j], 1)
			y2 = y2 + text_line_height
		end
		y = y + height
	end
end