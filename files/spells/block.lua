local me = GetUpdatedEntityID()
local target_player = EntityGetRootEntity(me)
local dmg = target_player and EntityGetFirstComponent(target_player, "DamageModelComponent")

local smallfolk = dofile_once("mods/noiting_simulator/files/scripts/smallfolk.lua")
local storage = tostring(GlobalsGetValue("NS_BATTLE_STORAGE", ""))
local v = string.len(storage) > 0 and smallfolk.loads(storage)

if not (dmg and v) then return end

local add = 0.03
add = add * (1.25 ^ v.tempolevel)
EntityInflictDamage(target_player, -add, "DAMAGE_HEALING", "?!?!", "NORMAL", 0, 0, target_player)