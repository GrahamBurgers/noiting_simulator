local me = GetUpdatedEntityID()
local x, y, rot = EntityGetTransform(me)
local proj = EntityGetFirstComponent(me, "ProjectileComponent")
if not proj then return end
dofile_once("mods/noiting_simulator/files/battles/heart_utils.lua")
Shoot({file = "mods/noiting_simulator/files/spells/gear_piece.xml", target = rot, count = 8, deg_between = 360 / 8, deg_add = 360 / 16, displace_px = 4, whoshot = ComponentGetValue2(proj, "mWhoShot")})
