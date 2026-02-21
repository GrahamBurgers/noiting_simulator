local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local x2, y2 = EntityGetTransform(EntityGetClosestWithTag(x, y, "player_unit"))
if not (x and y and x2 and y2) then return end
EntityLoad("data/entities/particles/teleportation_source.xml", x, y - 2)
EntityLoad("data/entities/particles/teleportation_target.xml", x2, y2 - 2)