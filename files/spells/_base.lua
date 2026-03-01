local me = GetUpdatedEntityID()
local c = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
local proj = EntityGetFirstComponentIncludingDisabled(me, "ProjectileComponent")
local vel = EntityGetFirstComponentIncludingDisabled(me, "VelocityComponent")
if not (proj and vel) then return end
local q = dofile_once("mods/noiting_simulator/files/scripts/proj_dmg_mult.lua")
if c <= ComponentGetValue2(proj, "collide_with_shooter_frames") then
    return -- things work weird when hitting too soon
elseif c == ComponentGetValue2(proj, "collide_with_shooter_frames") + 1 then
    SetRandomSeed(me, proj)
    local lifetime = ComponentObjectGetValue2(proj, "damage_by_type", "healing") * 25
    lifetime = lifetime + Random(ComponentGetValue2(proj, "lifetime_randomness"), -ComponentGetValue2(proj, "lifetime_randomness"))
    lifetime = lifetime * (1 + ComponentObjectGetValue2(proj, "damage_by_type", "electricity"))
    ComponentSetValue2(proj, "lifetime", lifetime)
    ComponentSetValue2(proj, "mStartingLifetime", ComponentGetValue2(proj, "lifetime"))
    ComponentObjectSetValue2(proj, "damage_by_type", "healing", 0)
    ComponentObjectSetValue2(proj, "damage_by_type", "electricity", 0)

	ComponentSetValue2(proj, "bounces_left", ComponentGetValue2(proj, "bounces_left") + ComponentObjectGetValue2(proj, "damage_by_type", "holy") * 25)
    ComponentObjectSetValue2(proj, "damage_by_type", "holy", 0)

	ComponentSetValue2(proj, "knockback_force", ComponentGetValue2(proj, "knockback_force") + ComponentObjectGetValue2(proj, "damage_by_type", "curse") * 25)
    ComponentObjectSetValue2(proj, "damage_by_type", "curse", 0)

	local projdmg = ComponentGetValue2(proj, "damage")
	if projdmg ~= 0 then
		q.set_mult(me, "inherent_mult", (projdmg * 25) / 100, "dmg_mult_collision,dmg_mult_explosion")
	end
	-- for shields: sum up damage types into projectile so they subtract correct durability
    ComponentSetValue2(proj, "damage",
		ComponentObjectGetValue2(proj, "damage_by_type", "melee") +
		ComponentObjectGetValue2(proj, "damage_by_type", "slice") +
		ComponentObjectGetValue2(proj, "damage_by_type", "fire") +
		ComponentObjectGetValue2(proj, "damage_by_type", "ice") +
		ComponentObjectGetValue2(proj, "damage_by_type", "drill")
	)

    ComponentSetValue2(proj, "ragdoll_force_multiplier", ComponentGetValue2(vel, "gravity_x"))
    ComponentSetValue2(proj, "hit_particle_force_multiplier", ComponentGetValue2(vel, "gravity_y"))
    ComponentSetValue2(vel, "gravity_x", 0)
    ComponentSetValue2(vel, "gravity_y", 0)
	if not ComponentGetValue2(proj, "on_collision_die") then
		EntityAddTag(me, "pierces")
		ComponentSetValue2(proj, "on_collision_die", true)
	end

    EntitySetComponentsWithTagEnabled(me, "proj_enable", true)
    EntitySetComponentsWithTagEnabled(me, "proj_disable", false)
	if EntityGetFirstComponent(me, "LuaComponent", "holder") then
		EntitySetComponentsWithTagEnabled(me, "not_while_held", false)
	end
    ComponentSetValue2(vel, "updates_velocity", true)
    ComponentSetValue2(proj, "collide_with_world", true)
    EntityAddTag(me, "projectile")
    EntityAddTag(me, "hittable")
    if not EntityHasTag(me, "pusher") then
        EntityAddTag(me, "pushable")
    end

	local spread_deg = EntityGetFirstComponentIncludingDisabled(me, "VariableStorageComponent", "spread_nonrandom_degrees")
	if spread_deg then
		local vx, vy = ComponentGetValue2(vel, "mVelocity")
        local direction = math.pi - math.atan2(vy, vx)
		local magnitude = math.sqrt(vx^2 + vy^2)
		local theta = (math.deg(direction) * math.pi / 180)
		local add = math.rad(ComponentGetValue2(spread_deg, "value_int"))
		theta = theta + add
		ComponentSetValue2(vel, "mVelocity", -math.cos(theta) * magnitude, math.sin(theta) * magnitude)
		ComponentSetValue2(proj, "direction_nonrandom_rad", add)
	end

    local comps = EntityGetComponentIncludingDisabled(me, "LuaComponent", "bounce_effect") or {}
    for i = 1, #comps do
        ComponentSetValue2(comps[i], "limit_how_many_times_per_frame", ComponentGetValue2(proj, "bounces_left"))
        ComponentSetValue2(comps[i], "script_polymorphing_to", "0")
    end

    local cute = ComponentObjectGetValue2(proj, "damage_by_type", "melee")
    local charming = ComponentObjectGetValue2(proj, "damage_by_type", "slice")
    local clever = ComponentObjectGetValue2(proj, "damage_by_type", "fire")
    local comedic = ComponentObjectGetValue2(proj, "damage_by_type", "ice")
    local typeless = ComponentObjectGetValue2(proj, "damage_by_type", "drill")

    local shooter = ComponentGetValue2(proj, "mWhoShot")
	local genome = EntityGetFirstComponentIncludingDisabled(proj, "GenomeDataComponent")
	local genome2 = EntityGetFirstComponentIncludingDisabled(shooter, "GenomeDataComponent")
	if genome and genome2 then
		ComponentSetValue2(genome, "herd_id", ComponentGetValue2(genome, "herd_id"))
	end
    -- don't friendly fire until we've stopped touching our shooter at least once
    EntityAddComponent2(me, "VariableStorageComponent", {
        _tags="proj_cooldown",
        value_int=shooter,
        value_float=9999,
        value_bool=true
    })

	if EntityHasTag(shooter, "player_unit") then
		-- global effects

		local burn_perk_count = tonumber(GlobalsGetValue("SPELL_BURNING_COUNT", "0")) or 0
		local burn_needed = 6 - burn_perk_count
		local counter2 = tonumber(GlobalsGetValue("SPELL_BURNING", "0")) or 0
		if burn_perk_count > 0 then
			if counter2 >= burn_needed then
				GlobalsSetValue("SPELL_BURNING", "0")
				dofile_once("mods/noiting_simulator/files/scripts/burn_projectile.lua")
				local dmg = nil
				local amount = 0
				if cute > 0 and (cute >= charming and cute >= clever and cute >= comedic and cute >= typeless) then
					dmg = "CUTE"
					amount = cute
				elseif charming > 0 and (charming >= cute and charming >= clever and charming >= comedic and charming >= typeless) then
					dmg = "CHARMING"
					amount = charming
				elseif clever > 0 and (clever >= cute and clever >= charming and clever >= comedic and clever >= typeless) then
					dmg = "CLEVER"
					amount = clever
				elseif comedic > 0 and (comedic >= cute and comedic >= charming and comedic >= clever and comedic >= typeless) then
					dmg = "COMEDIC"
					amount = comedic
				elseif typeless > 0 and (typeless >= cute and typeless >= charming and typeless >= clever and typeless >= comedic) then
					dmg = "TYPELESS"
					amount = typeless
				end
				Add_burn(me, dmg, amount)
			else
				GlobalsSetValue("SPELL_BURNING", tostring(counter2 + 1))
			end
		end

		local crit_spell_count = tonumber(GlobalsGetValue("SPELL_CRIT_COUNT", "0")) or 0
		local crits_needed = 21 - (crit_spell_count * 2)
		local counter = tonumber(GlobalsGetValue("SPELL_CRIT", "0")) or 0
		if crit_spell_count > 0 then
			if counter >= crits_needed then
				GlobalsSetValue("SPELL_CRIT", "0")
				ComponentObjectSetValue2(proj, "damage_critical", "chance", 100 + ComponentObjectGetValue2(proj, "damage_critical", "chance"))
				local sprites = EntityGetComponentIncludingDisabled(me, "SpriteComponent")
				if sprites then
					EntityAddComponent2(me, "SpriteComponent", {
						image_file="mods/noiting_simulator/files/spells/crits_field.png",
						emissive=true,
						additive=true,
						special_scale_x=1,
						special_scale_y=1,
						offset_x=5.5,
						offset_y=5.5,
						has_special_scale=true,
						z_index=-6.0,
					})
				end
			else
				GlobalsSetValue("SPELL_CRIT", tostring(counter + 1))
			end
		end

		if GlobalsGetValue("SPELL_ADRENALINE_ACTIVE", "FALSE") == "TRUE" then
			ComponentObjectSetValue2(proj, "damage_by_type", "slice", ComponentObjectGetValue2(proj, "damage_by_type", "slice") + 0.2)
		end

		--[[ velocity inheritance: use this?
		local vel2 = EntityGetFirstComponent(player, "VelocityComponent")
		if vel2 then
			local vx, vy = ComponentGetValue2(vel, "mVelocity")
			local vx2, vy2 = ComponentGetValue2(vel2, "mVelocity")
			vx = vx + vx2 * 50
			vy = vy + vy2 * 50
			ComponentSetValue2(vel, "mVelocity", vx, vy)
		end
		]]--
	end
end

-- gravity (here to work even in walls)
local gravity_x = ComponentGetValue2(proj, "ragdoll_force_multiplier")
local gravity_y = ComponentGetValue2(proj, "hit_particle_force_multiplier")
local vx, vy = ComponentGetValue2(vel, "mVelocity")
vx = vx + gravity_x / 60
vy = vy + gravity_y / 60
ComponentSetValue2(vel, "mVelocity", vx, vy)

-- for shields: sum up damage types into projectile so they subtract correct durability
ComponentSetValue2(proj, "damage",
	ComponentObjectGetValue2(proj, "damage_by_type", "melee") +
	ComponentObjectGetValue2(proj, "damage_by_type", "slice") +
	ComponentObjectGetValue2(proj, "damage_by_type", "fire") +
	ComponentObjectGetValue2(proj, "damage_by_type", "ice") +
	ComponentObjectGetValue2(proj, "damage_by_type", "drill")
)

-- COLLISION DETECTION
if EntityHasTag(me, "nohit") then return end
local var = EntityGetFirstComponentIncludingDisabled(me, "VariableStorageComponent", "cooldown_frames")
local var2 = EntityGetComponentIncludingDisabled(me, "VariableStorageComponent", "proj_cooldown") or {}
-- special: if value_bool in cooldown frames is true, instantly allow a hit again for hearts we're not touching
local px, py = EntityGetTransform(me)

local touchinghitbox = dofile_once("mods/noiting_simulator/files/scripts/proj_collision.lua")

for i = 1, #var2 do
    local current = ComponentGetValue2(var2[i], "value_float")
    ComponentSetValue2(var2[i], "value_float", current - 1)
    local target = ComponentGetValue2(var2[i], "value_int")
    local circle_size = ComponentGetValue2(proj, "blood_count_multiplier")
    if current <= 0 or (ComponentGetValue2(var2[i], "value_bool") and not touchinghitbox(circle_size, target)) then
        EntityRemoveComponent(me, var2[i])
    end
end
var2 = EntityGetComponentIncludingDisabled(me, "VariableStorageComponent", "proj_cooldown") or {}

local whoshot = ComponentGetValue2(proj, "mWhoShot")
local hittable = EntityGetInRadiusWithTag(px, py, 128, "hittable")
for i = 1, #hittable do
    local no_cooldown = true
    for j = 1, #var2 do
        if ComponentGetValue2(var2[j], "value_int") == hittable[i] then
            no_cooldown = false
        end
    end

    local vel2 = EntityGetFirstComponent(hittable[i], "VelocityComponent")
    local circle_size = ComponentGetValue2(proj, "blood_count_multiplier")
    if vel2 and (EntityGetHerdRelation(me, hittable[i]) < 50 or ComponentGetValue2(proj, "friendly_fire")) and no_cooldown then
        if touchinghitbox(circle_size, hittable[i]) then
            if ComponentGetValue2(proj, "play_damage_sounds") then
                local multiplier = q.get_mult_collision(me)
                -- deal knockback
                local knockback = (ComponentGetValue2(vel2, "mass") / ComponentGetValue2(vel, "mass")) * ComponentGetValue2(proj, "knockback_force") * multiplier * 0.33
				-- print("FORCE: " .. tostring(ComponentGetValue2(proj, "knockback_force")))
				-- print("MASS: " .. tostring(ComponentGetValue2(vel2, "mass")) .. " OVER " .. tostring(ComponentGetValue2(vel, "mass")))
				-- print("KB: " .. tostring(knockback))

        		local x2, y2 = EntityGetTransform(hittable[i])
                if knockback ~= 0 and not EntityHasTag(hittable[i], "projectile") then
					if EntityHasTag(hittable[i], "heart") and EntityGetName(me) == "$n_ns_tease" then
						local tease = EntityLoad("mods/noiting_simulator/files/spells/tease_heart.xml", x2, y2)
						vel2 = EntityGetFirstComponentIncludingDisabled(tease, "VelocityComponent") or 0
						knockback = knockback * 2
					end
            		local direction = math.pi - math.atan2(vy, vx)
                    local vx2, vy2 = ComponentGetValue2(vel2, "mVelocity")

					vx2 = vx2 + knockback * -math.cos(direction)
					vy2 = vy2 + knockback * math.sin(direction)

					ComponentSetValue2(vel2, "mVelocity", vx2, vy2)
                end

                -- deal damage
                dofile_once("mods/noiting_simulator/files/scripts/damage_types.lua")
                ProjHit(me, proj, hittable[i], multiplier, px, py, whoshot)
				EntityAddTag(me, "has_hit")

                local cooldown_proj_frames = (var and ComponentGetValue2(var, "value_float")) or 0
				EntityAddComponent2(me, "VariableStorageComponent", {
					_tags="proj_cooldown",
					value_int=hittable[i],
					value_float=cooldown_proj_frames,
					value_bool=(var and ComponentGetValue2(var, "value_bool"))
				})
            end
        end
    end
end