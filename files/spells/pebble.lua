if GlobalsGetValue("SPELL_PEBBLE_ACTIVE", "0") ~= "1" then return end
local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
if not (proj and vel) then return end

local q = dofile_once("mods/noiting_simulator/files/scripts/proj_dmg_mult.lua")
q.add_mult(me, "pebble", 1.25, "dmg_mult_collision")
EntitySetComponentsWithTagEnabled(me, "pebble", true)

local vx, vy = ComponentGetValue2(vel, "mVelocity")

vx = vx * 1.25
vy = vy * 1.25
ComponentSetValue2(vel, "mVelocity", vx, vy)

ComponentSetValue2(proj, "lifetime", ComponentGetValue2(proj, "lifetime") + 30)

EntityRemoveComponent(me, this)