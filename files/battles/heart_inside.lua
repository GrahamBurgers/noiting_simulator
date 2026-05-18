local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local p = EntityGetFirstComponentIncludingDisabled(me, "ParticleEmitterComponent")
if p then ComponentSetValue2(p, "is_emitting", false) end
local player = EntityGetClosestWithTag(x, y, "player_unit")
if player == 0 then return end
local x2, y2 = EntityGetTransform(player)
local distance = math.sqrt((x2 - x)^2 + (y2 - y)^2)
local speed = math.max(0, 110 - distance) / 50
local dir = math.atan2((y2 - y), (x2 - x))
x = x + math.cos(dir) * speed
y = y + math.sin(dir) * speed
EntitySetTransform(me, x, y)

local sprite = EntityGetFirstComponent(me, "SpriteComponent")
local sparticle = EntityGetFirstComponent(me, "SpriteParticleEmitterComponent")
if sprite and sparticle then
	local scale = tonumber(ComponentGetValue2(GetUpdatedComponentID(), "script_material_area_checker_success")) or 1
	scale = scale + (0.75 - scale) / 15
	if scale < 0.8 then scale = 1.5 end
	ComponentSetValue2(GetUpdatedComponentID(), "script_material_area_checker_success", tostring(scale))
	ComponentSetValue2(sprite, "has_special_scale", true)
	ComponentSetValue2(sprite, "special_scale_x", scale)
	ComponentSetValue2(sprite, "special_scale_y", scale)
	ComponentSetValue2(sparticle, "scale", scale, scale)
end

dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")
SafeKillAllProjectiles()
if distance > 6 then return end
EntityRemoveTag(me, "battle_not_finished")
if #EntityGetWithTag("battle_not_finished") == 0 then
	GlobalsSetValue("NS_BATTLE_STATE", "WIN")
	GlobalsSetValue("NS_IN_BATTLE", "0")
	GlobalsSetValue("NS_BATTLE_DEATHFRAME", "0")
end

EntityLoad("mods/noiting_simulator/files/spells/comedic_heal.xml", x, y)
EntityKill(me)