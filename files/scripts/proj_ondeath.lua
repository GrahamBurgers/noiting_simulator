local comedic_hurt_factor = tonumber(GlobalsGetValue("COMEDIC_HURT_FACTOR", "0"))

local me = GetUpdatedEntityID()
local x, y = EntityGetTransform(me)
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
if not (proj and vel) then return end
local touchinghitbox = dofile_once("mods/noiting_simulator/files/scripts/proj_collision.lua")
local var2 = EntityGetComponentIncludingDisabled(me, "VariableStorageComponent", "proj_cooldown") or {}

local do_explosion = ComponentObjectGetValue2(proj, "config_explosion", "physics_throw_enabled")
local q = dofile_once("mods/noiting_simulator/files/scripts/proj_dmg_mult.lua")
local whoshot = ComponentGetValue2(proj, "mWhoShot")
local radius = ComponentObjectGetValue2(proj, "config_explosion", "explosion_radius")
local search_radius = 128
local heart = EntityGetInRadiusWithTag(x, y, search_radius, "hittable") or {}
for i = 1, #heart do
	local no_cooldown = true
    for j = 1, #var2 do
        if ComponentGetValue2(var2[j], "value_int") == heart[i] then
            no_cooldown = false
        end
    end
    local isproj = EntityHasTag(heart[i], "projectile")
	local collided, multiplier = touchinghitbox(radius, heart[i])
    if heart[i] ~= me and do_explosion and (EntityGetHerdRelation(me, heart[i]) < 50 or isproj) and collided and multiplier > 0 and no_cooldown then
        local x2, y2 = EntityGetTransform(heart[i])
		if EntityHasTag(me, "no_explosion_falloff") then multiplier = 1 end
        multiplier = multiplier * q.get_mult(me, "dmg_mult_explosion")
        if (heart[i] ~= ComponentGetValue2(proj, "mWhoShot")) or (ComponentGetValue2(proj, "explosion_dont_damage_shooter") == false) then
            dofile_once("mods/noiting_simulator/files/scripts/damage_types.lua")
            ProjHit(me, proj, heart[i], multiplier, x, y, whoshot)
        end

        local vel2 = EntityGetFirstComponentIncludingDisabled(heart[i], "VelocityComponent")
        local cdc = EntityGetFirstComponentIncludingDisabled(heart[i], "CharacterDataComponent")
        local proj2 = EntityGetFirstComponentIncludingDisabled(heart[i], "ProjectileComponent")
        vel2 = cdc or vel2
        if vel2 then
            local direction = math.pi - math.atan2((y2 - y), (x2 - x))
            local knockback = (ComponentGetValue2(vel, "mass") / ComponentGetValue2(vel2, "mass")) * ComponentGetValue2(proj, "knockback_force") * multiplier * 0.33
			-- print("FORCE!: " .. tostring(ComponentGetValue2(proj, "knockback_force")))
			-- print("MASS!: " .. tostring(ComponentGetValue2(vel2, "mass")) .. " OVER " .. tostring(ComponentGetValue2(vel, "mass")))
			-- print("KB!: " .. tostring(knockback))
            local vx, vy = ComponentGetValue2(vel2, "mVelocity")
            vx = vx + knockback * -math.cos(direction) * (cdc and 3 or 1) * (isproj and 50 or 1)
            vy = vy + knockback * math.sin(direction) * (cdc and 2 or 1) * (isproj and 50 or 1)

            ComponentSetValue2(vel2, "mVelocity", vx, vy)

            if isproj and proj2 then
                -- add explosion's damage to boosted projectiles
				q.add_mult(heart[i], "boom", 0.5, "dmg_mult_collision,dmg_mult_explosion")
            end
        end
    end
end

local dmg_comedic = ComponentObjectGetValue2(proj, "damage_by_type", "ice") * q.get_mult(me, "dmg_mult_collision") * comedic_hurt_factor
local var = EntityGetFirstComponentIncludingDisabled(me, "VariableStorageComponent", "comedic_hurt_multiplier")
if var then
	dmg_comedic = dmg_comedic * ComponentGetValue2(var, "value_float")
end
local dmg = EntityGetFirstComponent(whoshot, "DamageModelComponent")
if whoshot and whoshot > 0 and dmg_comedic > 0 and dmg then
	EntityInflictDamage(whoshot, math.min(dmg_comedic, ComponentGetValue2(dmg, "hp") - 0.04), "DAMAGE_PROJECTILE", "$inventory_dmg_ice", "NONE", 0, 0, whoshot)
end

local is_real_explosion = ComponentObjectGetValue2(proj, "config_explosion", "physics_throw_enabled")
if ComponentObjectGetValue2(proj, "config_explosion", "explosion_sprite") == "" and (ComponentGetValue2(proj, "on_death_explode") or ComponentGetValue2(proj, "on_lifetime_out_explode")) then
	-- PARTICLE EXPLOSION!! <3
	SetRandomSeed(GameGetFrameNum(), GameGetFrameNum())
	local cute = ComponentObjectGetValue2(proj, "damage_by_type", "melee")
	local charming = ComponentObjectGetValue2(proj, "damage_by_type", "slice")
	local clever = ComponentObjectGetValue2(proj, "damage_by_type", "fire")
	local comedic = ComponentObjectGetValue2(proj, "damage_by_type", "ice")

	local material = "steam"
	if cute > 0 and (cute >= charming and cute >= clever and cute >= comedic) then
		material = "magic_gas_polymorph"
	elseif charming > 0 and (charming >= cute and charming >= clever and charming >= comedic) then
		material = "spark_yellow"
	elseif clever > 0 and (clever >= cute and clever >= charming and clever >= comedic) then
		material = "spark_blue"
	elseif comedic > 0 and (comedic >= cute and comedic >= charming and comedic >= clever) then
		material = "spark_green"
	end
	local gravity_x = ComponentGetValue2(proj, "ragdoll_force_multiplier") / Random(2, 5)
	local gravity_y = ComponentGetValue2(proj, "hit_particle_force_multiplier") / Random(2, 5)

	local e = EntityCreateNew()
	EntityAddComponent2(e, "LifetimeComponent", {lifetime = 3})
	local size = math.max(ComponentObjectGetValue2(proj, "config_explosion", "explosion_radius"), ComponentGetValue2(proj, "blood_count_multiplier"))
	local function particle(is_inner)
		local p = EntityAddComponent2(e, "ParticleEmitterComponent", {
			render_on_grid=true,
			emitted_material_name=is_inner and is_real_explosion and "spark_white" or material,
			emit_cosmetic_particles=true,
			collide_with_grid=false,
			custom_alpha=0.3,
			count_min=size*5,
			count_max=size*5,
			lifetime_min=0.5 + size / 30 + (is_inner and 0.5 or 0),
			lifetime_max=1.5 + size / 30 + (is_inner and 1.5 or 0),
			fade_based_on_lifetime=true,
			emission_interval_min_frames=1,
			emission_interval_max_frames=1,
			velocity_always_away_from_center=size * ((is_inner and not is_real_explosion) and 2 or 7),
			friction=7,
		})
		if (is_inner and not is_real_explosion) then
			ComponentSetValue2(p, "area_circle_radius", 0, size * 0.75)
		else
			ComponentSetValue2(p, "area_circle_radius", size * 0.25, size * 0.25 + (is_inner and 3 or 0))
		end
		ComponentSetValue2(p, "gravity", gravity_x, gravity_y)
	end
	particle(false)
	particle(true)

	EntitySetTransform(e, x, y)
end