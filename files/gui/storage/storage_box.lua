local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local spritecomp = EntityGetFirstComponentIncludingDisabled(me, "SpriteComponent", "box")
local interact = EntityGetFirstComponentIncludingDisabled(me, "InteractableComponent")
if not (spritecomp and interact and ComponentGetValue2(spritecomp, "rect_animation") == "open") then return end

Cursor_pos_x = Cursor_pos_x or 0
Cursor_pos_y = Cursor_pos_y or 0

local Gui = GuiCreate()
local res_x = tonumber(MagicNumbersGetValue("VIRTUAL_RESOLUTION_X")) or 0
local res_y = tonumber(MagicNumbersGetValue("VIRTUAL_RESOLUTION_Y")) or 0
local x, y = EntityGetTransform(me)
local cam_x, cam_y = GameGetCameraPos()
local s_w, s_h = GuiGetScreenDimensions(Gui)
local vx = x - cam_x + res_x / 2
local vy = y - cam_y + res_y / 2
local gui_x = (vx / 2) * s_w / res_x
local gui_y = (vy / 2) * s_h / res_y

Inputs = Inputs or {}
local player = EntityGetWithTag("player_unit")[1]
local controls = EntityGetFirstComponentIncludingDisabled(player, "ControlsComponent")
if controls then
	Inputs.lastleft = Inputs.left
	Inputs.lastright = Inputs.right
	Inputs.lastup = Inputs.up
	Inputs.lastdown = Inputs.down
	Inputs.left = ComponentGetValue2(controls, "mButtonDownDelayLineLeft") == 1
	Inputs.right = ComponentGetValue2(controls, "mButtonDownDelayLineRight") == 1
	Inputs.up = ComponentGetValue2(controls, "mButtonDownDelayLineUp") == 1
	Inputs.down = ComponentGetValue2(controls, "mButtonDownDelayLineDown") == 1

	ComponentSetValue2(controls, "input_latency_frames", 2)
	ComponentSetValue2(controls, "mButtonDownDelayLineLeft", 0)
	ComponentSetValue2(controls, "mButtonDownDelayLineRight", 0)
	ComponentSetValue2(controls, "mButtonDownDelayLineUp", 0)
	ComponentSetValue2(controls, "mButtonDownDelayLineDown", 0)
	ComponentSetValue2(controls, "mButtonDownDelayLineFire", 0)
	ComponentSetValue2(controls, "mButtonDownDelayLineFly", 0)
	ComponentSetValue2(controls, "mButtonDownDelayLineThrow", 0)
	ComponentSetValue2(controls, "mAimingVector", 0, 0)
end

if Inputs.right and not Inputs.lastright then Cursor_x = Cursor_x + 1 end
if Inputs.left and not Inputs.lastleft then Cursor_x = Cursor_x - 1 end
if Inputs.up and not Inputs.lastup then Cursor_y = Cursor_y - 1 end
if Inputs.down and not Inputs.lastdown then Cursor_y = Cursor_y + 1 end

local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
local storage = GlobalsGetValue("NS_STORAGE_BOX_SPELLS", "") or ""
local spellstorage = string.len(storage) > 0 and smallfolk.loads(storage) or {}
local destroystorage = GlobalsGetValue("NS_STORAGE_BOX_DESTROY", "") or ""
local destroy = string.len(destroystorage) > 0 and smallfolk.loads(destroystorage) or nil
local is_destroying = destroy ~= nil

local _id = 34534
local function id()
	_id = _id + 1
	return _id
end
local frame = GameGetFrameNum()
local openframe = tonumber(GlobalsGetValue("NS_STORAGE_BOX_FRAME")) or frame
local anim = math.min(1, (frame - openframe) / 30)
anim = 1 - (0.5 + (math.sin((anim + 0.5) * math.pi) / 2))

local type_sprites = {
	"data/ui_gfx/inventory/item_bg_projectile.png",
	"data/ui_gfx/inventory/item_bg_static_projectile.png",
	"data/ui_gfx/inventory/item_bg_modifier.png",
	"data/ui_gfx/inventory/item_bg_draw_many.png",
	"data/ui_gfx/inventory/item_bg_material.png",
	"data/ui_gfx/inventory/item_bg_other.png",
	"data/ui_gfx/inventory/item_bg_utility.png",
	"data/ui_gfx/inventory/item_bg_passive.png",
}

GuiStartFrame(Gui)
GuiOptionsAdd(Gui, 2) -- NonInteractive
dofile("mods/noiting_simulator/files/spells/__gun_actions.lua")
local scale = 1.5
local spell_w, spell_h = 16, 16
local type_w, type_h = 20, 20
local grid_buffer_x  = 4 * scale
local grid_buffer_y  = 6 * scale
local numbers_offset = 3 * scale
local rarity_offset  = 1 * scale
local gui_height = 160
local spells_per_row = math.floor(gui_height / (spell_w * scale))
local tween_scale = 6

if Cursor_x then
	Cursor_x = math.max(Cursor_x, -1)
	Cursor_x = math.min(Cursor_x, math.floor(Biggest / spells_per_row) - 1)
end
if Cursor_y then
	Cursor_y = math.max(Cursor_y, 0)
	Cursor_y = math.min(Cursor_y, spells_per_row - 1)
end
Biggest = 0
Biggest_tween = Biggest_tween or 0

local cx, cy = gui_x, gui_y
gui_x = gui_x + ((spell_w * scale + grid_buffer_x) * Biggest_tween / spells_per_row / -2)
gui_y = gui_y + ((spell_h * scale + grid_buffer_y) * spells_per_row / -2) - (gui_height / 2) - (40 * anim)

local target = ((spell_w * scale + grid_buffer_x) * (Cursor_x or -1)) + spell_w / 2
Gui_x_offset = Gui_x_offset or 0
Gui_x_offset = (Gui_x_offset) + (target - Gui_x_offset) / tween_scale

gui_x = gui_x - Gui_x_offset

local imgs = {
	show_locked = "mods/noiting_simulator/files/gui/storage/show_locked.png",
	hide_locked = "mods/noiting_simulator/files/gui/storage/hide_locked.png",
	none_locked = "mods/noiting_simulator/files/gui/storage/no_locked.png",
	show_undiscovered = "mods/noiting_simulator/files/gui/storage/show_undiscovered.png",
	hide_undiscovered = "mods/noiting_simulator/files/gui/storage/hide_undiscovered.png",
	none_undiscovered = "mods/noiting_simulator/files/gui/storage/no_undiscovered.png",
	show_unowned = "mods/noiting_simulator/files/gui/storage/show_unowned.png",
	hide_unowned = "mods/noiting_simulator/files/gui/storage/hide_unowned.png",
	none_unowned = "mods/noiting_simulator/files/gui/storage/no_unowned.png",
	sorter_all = "mods/noiting_simulator/files/gui/storage/sortrarity_all.png",
	sorter_1 = "mods/noiting_simulator/files/gui/storage/sortrarity_1.png",
	sorter_2 = "mods/noiting_simulator/files/gui/storage/sortrarity_2.png",
	sorter_3 = "mods/noiting_simulator/files/gui/storage/sortrarity_3.png",
	sorter_4 = "mods/noiting_simulator/files/gui/storage/sortrarity_4.png",
	empty = "mods/noiting_simulator/files/gui/storage/empty.png",
}
local sorts = {
	{img = imgs.sorter_all, rarity = 0, text = "$ns_sorter1"},
	{img = imgs.sorter_1, rarity = 1, text = "$ns_sorter2"},
	{img = imgs.sorter_2, rarity = 2, text = "$ns_sorter3"},
	{img = imgs.sorter_3, rarity = 3, text = "$ns_sorter4"},
	{img = imgs.sorter_4, rarity = 4, text = "$ns_sorterall"},
}
local types = {
	{id = "CUTE", img = "data/ui_gfx/inventory/icon_damage_melee.png"},
	{id = "CHARMING", img = "data/ui_gfx/inventory/icon_damage_slice.png"},
	{id = "CLEVER", img = "data/ui_gfx/inventory/icon_damage_fire.png"},
	{id = "COMEDIC", img = "data/ui_gfx/inventory/icon_damage_ice.png"},
	{id = "TYPELESS", img = "data/ui_gfx/inventory/icon_damage_drill.png"},
}

local trigger = ComponentGetValue2(this, "limit_how_many_times_per_frame") == 1

local show_undiscovered = ModSettingGet("noiting_simulator.show_undiscovered") or false
local show_locked = ModSettingGet("noiting_simulator.show_locked") or false
local show_unowned = ModSettingGet("noiting_simulator.show_unowned") or false
local sort = ModSettingGet("noiting_simulator.sort") or 1
local function hovered(is_hovered, gx, gy, name, data, owned_count)
	if is_hovered then
		ComponentSetValue2(interact, "ui_text", "")
		Cursor_pos_x = Cursor_pos_x + (gx - Cursor_pos_x) / tween_scale
		Cursor_pos_y = Cursor_pos_y + (gy - Cursor_pos_y) / tween_scale
		local cursorscale = scale * anim * (1 + math.sin(GameGetFrameNum() / 20) / 8)
		local ax = Cursor_pos_x + (type_w - spell_w) + ((type_w * cursorscale - spell_w)) / -2
		local ay = Cursor_pos_y + (type_w - spell_w) + ((type_h * cursorscale - spell_h)) / -2
		GuiZSetForNextWidget(Gui, 510)
		GuiImage(Gui, id(), ax, ay, "mods/noiting_simulator/files/gui/storage/cursor.png", 1, cursorscale, cursorscale, 0)
		GuiZSetForNextWidget(Gui, 534)
	end
	if name == "exit" and is_hovered then
		ComponentSetValue2(interact, "ui_text", is_destroying and "$ns_destroyerbox" or "$ns_storage_box_close")
		if trigger then
			GlobalsSetValue("NS_CAM_OVERRIDE_X", "nil")
			GlobalsSetValue("NS_CAM_OVERRIDE_Y", "nil")
			ComponentSetValue2(interact, "ui_text", "$ns_storage_box_open")
			ComponentSetValue2(spritecomp, "rect_animation", "close")
			GlobalsSetValue("NS_STORAGE_BOX_FRAME", "0")
			ComponentSetValue2(interact, "radius", 10)
			EntityRefreshSprite(me, spritecomp)
			if is_destroying then
				GlobalsSetValue("NS_STORAGE_BOX_SPELLS", GlobalsGetValue("NS_STORAGE_BOX_BACKUP") or "")
				EntityKill(me)
				GlobalsSetValue("NS_BOX_FREE", "YES")
				GlobalsSetValue("NS_STORAGE_BOX_DESTROY", "")
			end
		end
	elseif name == "sorter" then
		if is_hovered then
			if trigger then
				sort = (sort % #sorts) + 1
				ModSettingSet("noiting_simulator.sort", sort)
			end
			ComponentSetValue2(interact, "ui_text", sorts[sort].text)
		end
		return sorts[sort].img
	elseif name == "locked" then
		local override = Locked_count2 == 0
		show_locked = (override and true) or show_locked
		if is_hovered then
			if trigger and not override then
				show_locked = not data
				ModSettingSet("noiting_simulator.show_locked", show_locked)
			end
			ComponentSetValue2(interact, "ui_text", (override and "$ns_locked_none") or (data and "$ns_locked_hide") or "$ns_locked_show")
		end
		return (override and imgs.none_locked) or (show_locked and imgs.show_locked) or imgs.hide_locked
	elseif name == "undiscovered" then
		local override = Undiscovered_count2 == 0
		show_undiscovered = (override and true) or show_undiscovered
		if is_hovered then
			if trigger and not override then
				show_undiscovered = not data
				ModSettingSet("noiting_simulator.show_undiscovered", show_undiscovered)
			end
			ComponentSetValue2(interact, "ui_text", (override and "$ns_undiscovered_none") or (data and "$ns_undiscovered_hide") or "$ns_undiscovered_show")
		end
		return (override and imgs.none_undiscovered) or (show_undiscovered and imgs.show_undiscovered) or imgs.hide_undiscovered
	elseif name == "unowned" then
		local override = Unowned_count2 == 0
		show_unowned = (override and true) or show_unowned
		if is_hovered then
			if trigger and not override then
				show_unowned = not data
				ModSettingSet("noiting_simulator.show_unowned", show_unowned)
			end
			ComponentSetValue2(interact, "ui_text", (override and "$ns_unowned_none") or (data and "$ns_unowned_hide") or "$ns_unowned_show")
		end
		return (override and imgs.none_unowned) or (show_unowned and imgs.show_unowned) or imgs.hide_unowned
	elseif name == "spell" and is_hovered then
		local text = "$q_" .. string.lower(data.id)
		if not data.is_discovered then text = "?????" end
		if not data.is_unlocked then text = "$" .. data.unlock_flag end
		local type = data.ns_category
		if trigger then
			local inv = EntityGetFirstComponentIncludingDisabled(player, "Inventory2Component")
			local inv_entity = EntityGetWithName("inventory_full")
			local how_many = (inv_entity and #(EntityGetAllChildren(inv_entity) or {})) or 0
			local inv_size = inv and (ComponentGetValue2(inv, "full_inventory_slots_x") * ComponentGetValue2(inv, "full_inventory_slots_y")) or 0
			if how_many >= inv_size and not is_destroying then
                GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_denied", x, y)
				GamePrint("$ns_invfull")
			elseif owned_count <= 0 then
                GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_denied", x, y)
				GamePrint("$ns_noneowned")
			elseif is_destroying then
				if destroy and destroy[type] and destroy[type] > 0 then
                	GamePlaySound("data/audio/Desktop/ui.bank", "ui/item_remove", x, y)
					destroy[type] = destroy[type] - 1
					GlobalsSetValue("NS_STORAGE_BOX_DESTROY", smallfolk.dumps(destroy))
					spellstorage[data.id] = spellstorage[data.id] - 1
					GlobalsSetValue("NS_STORAGE_BOX_SPELLS", smallfolk.dumps(spellstorage))
					local exit = true
					for i = 1, #types do
						local num = destroy[types[i].id] or 0
						if num > 0 then
							exit = false
						end
					end
					if exit then
						GlobalsSetValue("NS_BOX_FREE", "GOGOGO")
						EntityKill(me)
						GlobalsSetValue("NS_CAM_OVERRIDE_X", "nil")
						GlobalsSetValue("NS_CAM_OVERRIDE_Y", "nil")
						GlobalsSetValue("NS_STORAGE_BOX_FRAME", "0")
					end
				else
                	GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_denied", x, y)
				end
			else
				local entity = CreateItemActionEntity(data.id, x, y)
				GamePickUpInventoryItem(player, entity)
				spellstorage[data.id] = spellstorage[data.id] - 1
				GlobalsSetValue("NS_STORAGE_BOX_SPELLS", smallfolk.dumps(spellstorage))
			end
		end
		ComponentSetValue2(interact, "ui_text", text)
	end
	return data
end

local function empty(count)
	local xid = math.floor(((count - 1) / spells_per_row))
	local yid = ((count - 1) % spells_per_row)
	local gx = (gui_x + (spell_w * scale + grid_buffer_x) * xid)
	local gy = (gui_y + (spell_h * scale + grid_buffer_y) * yid)
	gx = (gx * anim) + (cx * (1 - anim))
	gy = (gy * anim) + (cy * (1 - anim))

	local is_hovered = Cursor_x == xid and Cursor_y == yid
	hovered(is_hovered, gx, gy)

	GuiZSetForNextWidget(Gui, 534)
	GuiImage(Gui, id(), gx + (type_w * scale - spell_w * scale) / -2, gy + (type_h * scale - spell_h * scale) / -2, imgs.empty, 1, scale * anim, scale * anim, 0)
end

if is_destroying and destroy then
	GuiZSet(Gui, 500)
	local divider = 20 * anim
	local spacing = 14 * anim
	local dx = cx + divider * -2
	local txt = GameTextGetTranslatedOrNot("$ns_destroyprompt")
	local ax, ay = GuiGetTextDimensions(Gui, txt, scale * anim)
	GuiText(Gui, cx + ax / -2, cy - spacing, txt, scale * anim)

	for i = 1, #types do
		local num = destroy[types[i].id] or 0
		txt = tostring(num)
		local ix, iy = GuiGetImageDimensions(Gui, types[i].img, scale)
		local tx, ty = GuiGetTextDimensions(Gui, txt, scale * anim)
		GuiImage(Gui, id(), dx + ix / -2, cy, types[i].img, 1, scale * anim, scale * anim, 0)
		if num < 1 then
			GuiColorSetForNextWidget(Gui, 0.60, 0.56, 0.57, 1.00)
		end
		GuiText(Gui, dx + tx / -2, cy + spacing, txt, scale * anim)
		dx = dx + divider
	end
end

Unowned_count2 = Unowned_count or 0
Undiscovered_count2 = Undiscovered_count or 0
Locked_count2 = Locked_count or 0
Unowned_count = 0
Undiscovered_count = 0
Locked_count = 0
ComponentSetValue2(interact, "ui_text", "")
GuiZSet(Gui, 530)
local count = -spells_per_row + 1
for i = count, #actions do
	local xid = math.floor(((count - 1) / spells_per_row))
	local yid = ((count - 1) % spells_per_row)
	local gx = (gui_x + (spell_w * scale + grid_buffer_x) * xid)
	local gy = (gui_y + (spell_h * scale + grid_buffer_y) * yid)
	gx = (gx * anim) + (cx * (1 - anim))
	gy = (gy * anim) + (cy * (1 - anim))

	local is_hovered = Cursor_x == xid and Cursor_y == yid
	if i == -spells_per_row + 1 then
		-- EXIT BUTTON
		Cursor_x = Cursor_x or xid
		Cursor_y = Cursor_y or yid
		hovered(is_hovered, gx, gy, "exit")
		GuiImage(Gui, id(), gx, gy, "mods/noiting_simulator/files/gui/storage/exit.png", 1, scale * anim, scale * anim, 0)
	elseif i == -spells_per_row + 2 then
		-- SORTER BUTTON
		local img = hovered(is_hovered, gx, gy, "sorter", show_unowned)
		GuiImage(Gui, id(), gx, gy, img, 1, scale * anim, scale * anim, 0)
	elseif i == -spells_per_row + 3 then
		-- UNOWNED BUTTON
		local img = hovered(is_hovered, gx, gy, "unowned", show_unowned)
		if Unowned_count2 == 0 then img = imgs.none_unowned end
		GuiImage(Gui, id(), gx, gy, img, 1, scale * anim, scale * anim, 0)
	elseif i == -spells_per_row + 4 then
		-- UNDISCOVERED BUTTON
		local img = hovered(is_hovered, gx, gy, "undiscovered", show_undiscovered)
		if Undiscovered_count2 == 0 then img = imgs.none_undiscovered end
		GuiImage(Gui, id(), gx, gy, img, 1, scale * anim, scale * anim, 0)
	elseif i == -spells_per_row + 5 then
		-- LOCKED BUTTON
		local img = hovered(is_hovered, gx, gy, "locked", show_locked)
		if Undiscovered_count2 == 0 then img = imgs.none_locked end
		GuiImage(Gui, id(), gx, gy, img, 1, scale * anim, scale * anim, 0)
	elseif i > 0 then
		local data = actions[i]
		local rot = math.sin((GameGetFrameNum() / 30) + xid / 4 + yid / 2) / 10
		if ModSettingGet("noiting_simulator.wobblybox") == false then
			rot = 0
		end

		local owned_count = spellstorage[data.id] or 0
		local countimg = "mods/noiting_simulator/files/gui/storage/count_" .. math.min(10, owned_count) .. ".png"

		local ignore = false
		local spellimg, frameimg
		if data.is_unlocked == false then
			Locked_count = Locked_count + 1
			spellimg = "mods/noiting_simulator/files/gui/storage/locked.png"
			frameimg = "mods/noiting_simulator/files/gui/storage/locked_spell.png"
			countimg = ""
			if not show_locked then ignore = true end
		elseif data.is_discovered == false then
			Undiscovered_count = Undiscovered_count + 1
			spellimg = "mods/noiting_simulator/files/gui/storage/undiscovered.png"
			frameimg = "mods/noiting_simulator/files/gui/storage/undiscovered_spell.png"
			countimg = ""
			if not show_undiscovered then ignore = true end
		elseif owned_count == 0 then
			spellimg = data.sprite
			frameimg = type_sprites[(data.type + 1) or 0]
			Unowned_count = Unowned_count + 1
			if not show_unowned then ignore = true end
		else
			spellimg = data.sprite
			frameimg = type_sprites[(data.type + 1) or 0]
		end
		if data.rarity and (sorts[sort].rarity ~= 0) and (data.rarity ~= sorts[sort].rarity) then ignore = true end
		local rarities = {
			"mods/noiting_simulator/files/gui/storage/rarity_1.png",
			"mods/noiting_simulator/files/gui/storage/rarity_2.png",
			"mods/noiting_simulator/files/gui/storage/rarity_3.png",
			"mods/noiting_simulator/files/gui/storage/rarity_4.png",
			"mods/noiting_simulator/files/gui/storage/rarity_5.png",
		}

		if ignore then
			count = count - 1
		else
			hovered(is_hovered, gx, gy, "spell", data, owned_count)
			GuiZSetForNextWidget(Gui, 535)
			GuiImage(Gui, id(), gx + (type_w * scale - spell_w * scale) / -2, gy + (type_h * scale - spell_h * scale) / -2, frameimg, 1, scale * anim, scale * anim, 0)
			if data.rarity then
				GuiZSetForNextWidget(Gui, 534)
				GuiImage(Gui, id(), gx + (type_w * scale - spell_w * scale) / -2, gy + rarity_offset + (type_h * scale - spell_h * scale) / -2, rarities[data.rarity], 0.8, scale * anim, scale * anim, 0)
			end
			if count and countimg ~= "" then
				GuiZSetForNextWidget(Gui, 532)
				GuiImage(Gui, id(), gx + (type_w * scale - spell_w * scale) / -2, gy + numbers_offset + (type_h * scale - spell_h * scale) / -2, countimg, 0.8, scale * anim, scale * anim, 0)
			end
			GuiZSetForNextWidget(Gui, 533)
			GuiImage(Gui, id(), gx, gy, spellimg, 1, scale * anim, scale * anim, rot)
		end
	else
		empty(count)
	end
	count = count + 1
end

while (count - 1) % spells_per_row ~= 0 do
	empty(count)
	count = count + 1
end
Biggest = count
Biggest_tween = Biggest_tween + (Biggest - Biggest_tween) / tween_scale

ComponentSetValue2(this, "limit_how_many_times_per_frame", 0)