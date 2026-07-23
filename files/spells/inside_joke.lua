local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local sprite = EntityGetFirstComponent(me, "SpriteComponent")
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local particles = EntityGetFirstComponentIncludingDisabled(me, "ParticleEmitterComponent", "inside_joke_bump")
if not (sprite and vel and proj and particles) then return end
local radius = ComponentGetValue2(proj, "blood_count_multiplier")
local dmg_multiplier = 1.5
if ComponentGetValue2(vel, "updates_velocity") then
    if ComponentGetValue2(proj, "bounces_left") < ComponentGetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame") then
        ComponentSetValue2(vel, "updates_velocity", false)
        ComponentSetValue2(vel, "terminal_velocity", 0)
        ComponentSetValue2(sprite, "rect_animation", "idle")
        EntitySetComponentsWithTagEnabled(me, "inside_joke_go", true)
        ComponentSetValue2(particles, "is_emitting", true)
        EntityRemoveTag(me, "hittable")
    else
        ComponentSetValue2(sprite, "rect_animation", "deploy")
    end
    ComponentSetValue2(GetUpdatedComponentID(), "limit_how_many_times_per_frame", ComponentGetValue2(proj, "bounces_left"))
    return
else
    ComponentSetValue2(sprite, "rect_animation", "")
    ComponentSetValue2(particles, "is_emitting", false)
end
local function thing(bump, i)
    if bump[i] ~= me then
        local x2, y2 = EntityGetTransform(bump[i])
        local vel2 = EntityGetFirstComponentIncludingDisabled(bump[i], "VelocityComponent")
        local cdc = EntityGetFirstComponentIncludingDisabled(bump[i], "CharacterDataComponent")
        local isproj = EntityHasTag(bump[i], "projectile")
        local proj2 = EntityGetFirstComponentIncludingDisabled(bump[i], "ProjectileComponent")
        local var2 = EntityGetFirstComponentIncludingDisabled(bump[i], "VariableStorageComponent", "bumper_cooldown")
        local lastframe = -999
        if var2 then
            lastframe = ComponentGetValue2(var2, "value_int")
        else
            var2 = EntityAddComponent2(bump[i], "VariableStorageComponent", {
                _tags="bumper_cooldown",
                value_int=GameGetFrameNum()
            })
        end

        vel2 = cdc or vel2
        if vel2 and GameGetFrameNum() >= lastframe + 15 then
            ComponentSetValue2(sprite, "rect_animation", "bump")
            EntityRefreshSprite(me, sprite)
            ComponentSetValue2(particles, "is_emitting", true)

            ComponentSetValue2(var2, "value_int", GameGetFrameNum())
            GamePlaySound( "data/audio/Desktop/animals.bank", "animals/mine/beep", x, y )
            local direction = math.pi - math.atan2((y2 - y), (x2 - x))
            local vx, vy = ComponentGetValue2(vel2, "mVelocity")
            local magnitude = math.max(30, math.sqrt(vx^2 + vy^2) * 1.2) + ComponentGetValue2(proj, "knockback_force")

			local target = EntityGetClosestWithTag(x2, y2, "heart")
			if target and target > 0 and not cdc then
				local x3, y3 = EntityGetTransform(target)
				local dir = math.atan2((y3 - y2), (x3 - x2))
				local hx = magnitude * math.cos(dir)
           		local hy = magnitude * math.sin(dir)
				x2 = x2 + hx
				y2 = y2 + hy
				direction = math.pi - math.atan2((y2 - y), (x2 - x))
			end

            vx = magnitude * -math.cos(direction) * (cdc and 3 or 1)
            vy = magnitude * math.sin(direction) * (cdc and 2 or 1)

            -- code stolen from nathan. Might be haunted
            local nx, ny = x2 - x, y2 - y
            local mag = (nx * nx + ny * ny) ^ 0.5
            nx, ny = nx / mag, ny / mag

            local vmag = (vx * vx + vy * vy) ^ 0.5
            vx, vy = vx / vmag, vy / vmag

            local dot = nx * vx + ny * vy
            local rx, ry = 2 * nx * dot, 2 * ny * dot
            rx, ry = rx - vx, ry - vy
            rx, ry = rx * vmag, ry * vmag

            ComponentSetValue2(vel2, "mVelocity", rx, ry)

			-- do the bounce
			local bouncy = EntityGetComponent(bump[i], "LuaComponent", "bounce_effect") or {}
			for j = 1, #bouncy do
				if not ComponentHasTag(bouncy[j], "inside_joke") then
					ComponentSetValue2(bouncy[j], "limit_how_many_times_per_frame", ComponentGetValue2(bouncy[j], "limit_how_many_times_per_frame") + 1)
				end
			end

            if isproj and proj2 then
				local hurt = EntityGetFirstComponentIncludingDisabled(bump[i], "VariableStorageComponent", "comedic_hurt_multiplier") or
					EntityAddComponent2(bump[i], "VariableStorageComponent", {_tags="comedic_hurt_multiplier"})
					ComponentSetValue2(hurt, "value_float", 0)

				-- ComponentSetValue2(proj2, "lifetime", ComponentGetValue2(proj2, "lifetime") + 30)
                ComponentSetValue2(vel2, "air_friction", ComponentGetValue2(vel2, "air_friction") / 2)
				if ComponentGetValue2(proj, "mWhoShot") ~= ComponentGetValue2(proj2, "mWhoShot") then
					ComponentSetValue2(proj2, "friendly_fire", true)
				end

				local q = dofile_once("mods/noiting_simulator/files/scripts/proj_dmg_mult.lua")
        		-- q.add_mult(me, "inside_joke", dmg_multiplier, "dmg_mult_collision,dmg_mult_explosion")
            end
        end
    end
end
local thing1 = EntityGetInRadiusWithTag(x, y, radius, "hittable") or {}
for i = 1, #thing1 do
	thing(thing1, i)
end
local thing2 = EntityGetInRadiusWithTag(x, y, radius, "projectile") or {}
for i = 1, #thing2 do
	thing(thing2, i)
end