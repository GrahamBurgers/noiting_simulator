local me = GetUpdatedEntityID()
local this = GetUpdatedComponentID()
local stacks = EntityGetComponentIncludingDisabled(me, "LuaComponent", "holder") or {}
if stacks[1] ~= this then return end
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local vel = EntityGetFirstComponent(me, "VelocityComponent")
local particle = EntityGetFirstComponentIncludingDisabled(me, "ParticleEmitterComponent", "holder")
local grow_time = 120 * #stacks
local dmg_add = 0.8 / 120
if not (proj and vel and particle) then return end
local bouncy = EntityGetFirstComponentIncludingDisabled(me, "ParticleEmitterComponent", "holder_bouncy")
local size = ComponentGetValue2(proj, "blood_count_multiplier")
local shooter = ComponentGetValue2(proj, "mWhoShot")
local controls = shooter and EntityGetFirstComponent(shooter, "ControlsComponent")
local inv = EntityGetFirstComponent(shooter, "Inventory2Component")
local wand = inv and ComponentGetValue2(inv, "mActiveItem")
if not wand then return end
local x2, y2 = EntityGetTransform(wand)

local ticks = ComponentGetValue2(this, "mTimesExecuted")
if ticks == 0 then
	-- this essentially does math.abs() on the speed. Backwards projectiles fire forward. Needs balancing?
    local vx, vy = ComponentGetValue2(vel, "mVelocity")
    local magnitude = math.sqrt(vx^2 + vy^2)
    ComponentSetValue2(this, "limit_how_many_times_per_frame", magnitude)
elseif controls then
    local magnitude = ComponentGetValue2(this, "limit_how_many_times_per_frame")
    local dx, dy = ComponentGetValue2(controls, "mAimingVectorNormalized")
    local direction = math.pi - math.atan2(dy, dx)
    local hotspot = EntityGetFirstComponentIncludingDisabled(wand, "HotspotComponent", "shoot_pos")

    if hotspot then
		local hx, hy = ComponentGetValue2(hotspot, "offset")
		hx = hx + 2
		x2 = x2 + hx * -math.cos(direction)
		y2 = y2 + hx * math.sin(direction)
    end

	local spread_deg = EntityGetFirstComponentIncludingDisabled(me, "VariableStorageComponent", "spread_nonrandom_degrees")
	if spread_deg then
		direction = direction + math.rad(ComponentGetValue2(spread_deg, "value_int"))
	end
    local vx, vy = -math.cos(direction) * magnitude, math.sin(direction) * magnitude

    EntitySetTransform(me, x2, y2)
    ComponentSetValue2(vel, "mVelocity", vx, vy)

    local one_liner = EntityGetFirstComponent(me, "VariableStorageComponent", "one_liner_direction")
    if one_liner then
        ComponentSetValue2(one_liner, "value_float", direction)
    end
	if bouncy and ComponentGetValue2(bouncy, "is_emitting") then
		EntityRemoveComponent(me, bouncy)
		bouncy = nil
	end

	local ability = EntityGetFirstComponentIncludingDisabled(wand, "AbilityComponent")
    if ComponentGetValue2(controls, "mButtonDownFire") and ability and not EntityHasTag(me, "has_hit") then
        ComponentSetValue2(particle, "is_emitting", true)
		ComponentSetValue2(proj, "lifetime", ComponentGetValue2(proj, "lifetime") + 1)
		ComponentSetValue2(ability, "mNextFrameUsable", math.max(GameGetFrameNum() + 30, ComponentGetValue2(ability, "mNextFrameUsable")))
		-- local q = dofile_once("mods/noiting_simulator/files/scripts/proj_dmg_mult.lua")
		if ticks > grow_time then
        	ComponentSetValue2(particle, "is_emitting", false)
			if bouncy then ComponentSetValue2(bouncy, "is_emitting", true) end
		else
			-- q.add_mult(me, "punchline", dmg_add, "dmg_mult_collision")
			local comedic = ComponentObjectGetValue2(proj, "damage_by_type", "ice")
			ComponentObjectSetValue2(proj, "damage_by_type", "ice", comedic + dmg_add)
        	ComponentSetValue2(particle, "area_circle_radius", size + 10, size + 10)
		end
	else
		EntitySetComponentsWithTagEnabled(me, "not_while_held", true)
        EntitySetComponentIsEnabled(me, this, false)
        ComponentSetValue2(particle, "is_emitting", false)
    end
end