local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local x, y = EntityGetTransform(me)
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent", "base_component")
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent", "base_component")
if not (proj and vel) then return end
if ComponentGetValue2(this, "mTimesExecuted") == 0 then
	SetRandomSeed(x + GameGetFrameNum(), y + 42598)
	local rnd = Random(1, 4)

	local data = {}
	-- lollipop: stronger arc, more damage
	if rnd == 1 then data = {sprite = "mods/noiting_simulator/files/spells/gfx/candy_lollipop.png", mult = 0.5, bounces = 0, gravity = 1.4, drag = 0} end

	-- wrapped: lower gravity, less damage
	if rnd == 2 then data = {sprite = "mods/noiting_simulator/files/spells/gfx/candy_wrapped.png", mult = -0.25, bounces = 0, gravity = 0.75, drag = -0.1} end

	-- chocolate: awesome damage, drag
	if rnd == 3 then data = {sprite = "mods/noiting_simulator/files/spells/gfx/candy_chocolate.png", mult = 1, bounces = 0, gravity = 1, drag = 0.4} end

	-- gumdrop: extreme arc, bouncy
	if rnd == 4 then data = {sprite = "mods/noiting_simulator/files/spells/gfx/candy_gumdrop.png", mult = 0, bounces = 3, gravity = 5, drag = 0} end

	local sprite = EntityGetFirstComponentIncludingDisabled(me, "SpriteComponent", "base_component")
	if sprite then
		ComponentSetValue2(sprite, "image_file", data.sprite)
		EntityRefreshSprite(me, sprite)
	end

	ComponentObjectSetValue2(proj, "damage_by_type", "holy", ComponentObjectGetValue2(proj, "damage_by_type", "holy") + data.bounces / 25)
	ComponentSetValue2(proj, "angular_velocity", 9)

	ComponentSetValue2(vel, "gravity_y", ComponentGetValue2(vel, "gravity_y") * data.gravity)
	ComponentSetValue2(vel, "air_friction", ComponentGetValue2(vel, "air_friction") + data.drag)

	local q = dofile_once("mods/noiting_simulator/files/scripts/proj_dmg_mult.lua")
	q.add_mult(me, "candy", data.mult or 0, "dmg_mult_collision")
else
	local vx, vy = ComponentGetValue2(vel, "mVelocity")
	if vx < 0 then
		ComponentSetValue2(proj, "angular_velocity", -ComponentGetValue2(proj, "angular_velocity"))
	end
	EntityRemoveComponent(me, this)
end