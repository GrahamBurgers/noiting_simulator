local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local target_player = EntityGetRootEntity(me)
local dmg = target_player and EntityGetFirstComponent(target_player, "DamageModelComponent")

local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
local storage = tostring(GlobalsGetValue("NS_BATTLE_STORAGE", ""))
local v = string.len(storage) > 0 and smallfolk.loads(storage)

if not (dmg and v and ComponentGetValue2(dmg, "hp") < ComponentGetValue2(dmg, "max_hp")) then return end

local add = -0.04
local divider = math.floor(120 * (0.9 ^ v.tempolevel))
local ticks = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
if ((ticks % divider) > ((ticks + 1) % divider)) then
	EntityInflictDamage(target_player, add, "DAMAGE_HEALING", "?!?!", "NORMAL", 0, 0, target_player)
	GamePlaySound("data/audio/Desktop/misc.bank", "game_effect/regeneration/tick", x, y)
end