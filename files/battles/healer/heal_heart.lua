local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
EntitySetTransform(me, x, y, math.sin(GameGetFrameNum() / 15) / 5)

local p = EntityGetFirstComponent(me, "ParticleEmitterComponent", "pewwwwwww")
if p then
	EntitySetComponentIsEnabled(me, p, false)
end