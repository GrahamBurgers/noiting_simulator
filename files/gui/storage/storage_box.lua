local me = GetUpdatedEntityID()
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
local grid_buffer = 1 * scale
local gui_height = 200
local spells_per_row = math.floor(gui_height / (spell_w * scale))

local cx, cy = gui_x, gui_y
gui_x = gui_x + ((spell_w * scale + grid_buffer) * math.floor((#actions / spells_per_row)) / -2)
gui_y = gui_y + ((spell_h * scale + grid_buffer) * spells_per_row / -2) - (gui_height / 2) - (40 * anim)

local trigger = ComponentGetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame") == 1

local show_undiscovered = ModSettingGet("noiting_simulator.show_undiscovered") or false
local show_locked = ModSettingGet("noiting_simulator.show_locked") or false
local show_owned = ModSettingGet("noiting_simulator.show_owned") or false
local function hovered(is_hovered, gx, gy, name, data)
    if is_hovered then
        ComponentSetValue2(interact, "ui_text", "")
        Cursor_pos_x = Cursor_pos_x + (gx - Cursor_pos_x) / 3
        Cursor_pos_y = Cursor_pos_y + (gy - Cursor_pos_y) / 3
        local cursorscale = scale * anim * (1 + math.sin(GameGetFrameNum() / 20) / 8)
        local ax = Cursor_pos_x + (type_w - spell_w) + ((type_w * cursorscale - spell_w)) / -2
        local ay = Cursor_pos_y + (type_w - spell_w) + ((type_h * cursorscale - spell_h)) / -2
        GuiZSetForNextWidget(Gui, 520)
        GuiImage(Gui, id(), ax, ay, "mods/noiting_simulator/files/gui/storage/cursor.png", 1, cursorscale, cursorscale, 0)
        GuiZSetForNextWidget(Gui, 534)
        if name == "exit" then
            ComponentSetValue2(interact, "ui_text", "$ns_storage_box_close")
            if trigger then
                GlobalsSetValue("NS_CAM_OVERRIDE_X", "nil")
                GlobalsSetValue("NS_CAM_OVERRIDE_Y", "nil")
                ComponentSetValue2(interact, "ui_text", "$ns_storage_box_open")
                ComponentSetValue2(spritecomp, "rect_animation", "close")
                ComponentSetValue2(interact, "radius", 10)
                EntityRefreshSprite(me, spritecomp)
            end
        elseif name == "locked" then
            if trigger then ModSettingSet("noiting_simulator.show_locked", not data) end
            ComponentSetValue2(interact, "ui_text", data and "$ns_locked_hide" or "$ns_locked_show")
        elseif name == "undiscovered" then
            if trigger then ModSettingSet("noiting_simulator.show_undiscovered", not data) end
            ComponentSetValue2(interact, "ui_text", data and "$ns_undiscovered_hide" or "$ns_undiscovered_show")
        elseif name == "owned" then
            if trigger then ModSettingSet("noiting_simulator.show_owned", not data) end
            ComponentSetValue2(interact, "ui_text", data and "$ns_owned_hide" or "$ns_owned_show")
        end
    end
    return data
end

local count = -spells_per_row + 1
for i = count, #actions do
    local xid = math.floor(((count - 1) / spells_per_row))
    local yid = ((count - 1) % spells_per_row)
    local gx = (gui_x + (spell_w * scale + grid_buffer) * xid)
    local gy = (gui_y + (spell_h * scale + grid_buffer) * yid)
    gx = (gx * anim) + (cx * (1 - anim))
    gy = (gy * anim) + (cy * (1 - anim))

    local is_hovered = Cursor_x == xid and Cursor_y == yid
    if i == -spells_per_row + 1 then
        Cursor_x = Cursor_x or xid
        Cursor_y = Cursor_y or yid
        hovered(is_hovered, gx, gy, "exit")
        GuiImage(Gui, id(), gx, gy, "mods/noiting_simulator/files/gui/storage/exit.png", 1, scale * anim, scale * anim, 0)
    elseif i == -spells_per_row + 2 then
        local img = hovered(is_hovered, gx, gy, "owned", show_owned)
        GuiImage(Gui, id(), gx, gy, img and "mods/noiting_simulator/files/gui/storage/show_owned.png" or "mods/noiting_simulator/files/gui/storage/hide_owned.png", 1, scale * anim, scale * anim, 0)
    elseif i == -spells_per_row + 3 then
        local img = hovered(is_hovered, gx, gy, "undiscovered", show_undiscovered)
        GuiImage(Gui, id(), gx, gy, img and "mods/noiting_simulator/files/gui/storage/show_undiscovered.png" or "mods/noiting_simulator/files/gui/storage/hide_undiscovered.png", 1, scale * anim, scale * anim, 0)
    elseif i == -spells_per_row + 4 then
        local img = hovered(is_hovered, gx, gy, "locked", show_locked)
        GuiImage(Gui, id(), gx, gy, img and "mods/noiting_simulator/files/gui/storage/show_locked.png" or "mods/noiting_simulator/files/gui/storage/hide_locked.png", 1, scale * anim, scale * anim, 0)
    elseif i > 0 then
        local this = actions[i]
        local rot = math.sin((GameGetFrameNum() / 30) + xid / 4 + yid / 2) / 10

        local ignore = false
        local spellimg, frameimg
        if this.is_unlocked == false then
            spellimg = "mods/noiting_simulator/files/gui/storage/locked.png"
            frameimg = "mods/noiting_simulator/files/gui/storage/locked_spell.png"
            if not show_locked then ignore = true end
        elseif this.is_discovered == false then
            spellimg = "mods/noiting_simulator/files/gui/storage/undiscovered.png"
            frameimg = "mods/noiting_simulator/files/gui/storage/undiscovered_spell.png"
            if not show_undiscovered then ignore = true end
        elseif not show_owned then
            ignore = true
        else
            spellimg = this.sprite
            frameimg = type_sprites[(this.type + 1) or 0]
        end

        if ignore then
            count = count - 1
        else
            hovered(is_hovered, gx, gy, "spell", this)
            GuiZSetForNextWidget(Gui, 534)
            GuiImage(Gui, id(), gx + (type_w * scale - spell_w * scale) / -2, gy + (type_h * scale - spell_h * scale) / -2, frameimg, 1, scale * anim, scale * anim, 0)
            GuiZSetForNextWidget(Gui, 533)
            GuiImage(Gui, id(), gx, gy, spellimg, 1, scale * anim, scale * anim, rot)
        end
    end
    count = count + 1
end

ComponentSetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame", 0)