local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
local shooter = proj and ComponentGetValue2(proj, "mWhoShot")
local controls = shooter and EntityGetFirstComponent(shooter, "ControlsComponent")

local eye = EntityGetAllChildren(me, "eye")[1]
local pupil = EntityGetAllChildren(me, "pupil")[1]
local beam = EntityGetAllChildren(me, "beam")[1]
local sprites = EntityGetComponentIncludingDisabled(me, "SpriteComponent", "character") or {}
if not (#sprites > 0 and eye and pupil and beam and controls) then return end
local dx, dy = ComponentGetValue2(controls, "mAimingVectorNormalized")
sprites[#sprites+1] = EntityGetFirstComponent(eye, "SpriteComponent", "character")
sprites[#sprites+1] = EntityGetFirstComponent(pupil, "SpriteComponent", "character")
local heartpupil = EntityGetFirstComponent(me, "VariableStorageComponent", "heart_pupil_frame")

local dir = math.atan2(dy or 0, dx or 0)
local facedir = dir
local is_heart = heartpupil and (ComponentGetValue2(heartpupil, "value_int") < GameGetFrameNum())
local target = is_heart and "mods/noiting_simulator/files/spells/gfx/ult_charming_pupil.xml" or "mods/noiting_simulator/files/spells/gfx/ult_charming_heart.xml"
local current = ComponentGetValue2(sprites[3], "image_file")
if current ~= target then
    ComponentSetValue2(sprites[3], "image_file", target)
    EntityRefreshSprite(pupil, sprites[3])
end

local ticks = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")
if ticks % 2 == 0 then
    local child = Shoot({file = "mods/noiting_simulator/files/spells/ult_charming_shot.xml", stick_frames = 0, count = 1, deg_add = 180 + math.deg(math.pi - dir), deg_random_per = 3, whoshot = shooter})
    EntityAddChild(me, child[1])
end

if ticks > 0 then
    for i = 1, #sprites do
        ComponentSetValue2(sprites[i], "update_transform_rotation", false)
    end

else
    facedir = 0
    for i = 1, #sprites do
        ComponentSetValue2(sprites[i], "update_transform_rotation", true)
        ComponentSetValue2(sprites[i], "visible", true)
        ComponentSetValue2(sprites[i], "additive", false)
        ComponentSetValue2(sprites[i], "emissive", false)
        ComponentSetValue2(sprites[i], "offset_x", 8)
        ComponentSetValue2(sprites[i], "offset_y", 8)
        ComponentSetValue2(sprites[i], "has_special_scale", true)
        ComponentSetValue2(sprites[i], "special_scale_x", 1.0625)
        ComponentSetValue2(sprites[i], "special_scale_y", 1.0625)
    end
    EntityRefreshSprite(me, sprites[1])
    EntityRefreshSprite(eye, sprites[2])
    EntityRefreshSprite(pupil, sprites[3])
end

EntitySetTransform(me, x, y, facedir)
EntitySetTransform(eye,   x + dx * 2, y + dy * 2, facedir)
EntitySetTransform(pupil, x + dx * 3.5, y + dy * 3.5, facedir)
EntitySetTransform(beam, x, y, dir)