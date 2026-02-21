---@param target "PLAYER"|"UP"|"DOWN"|"LEFT"|"RIGHT"|table
local target_coords = function(x, y, target)
    if target == "PLAYER" then return EntityGetTransform(EntityGetClosestWithTag(x, y, "player_unit"))
	elseif target == "HEART" then return EntityGetTransform(EntityGetClosestWithTag(x, y, "heart"))
    elseif target == "UP" then return x, y - 5
    elseif target == "DOWN" then return x, y + 5
    elseif target == "LEFT" then return x - 5, y
    elseif target == "RIGHT" then return x + 5, y
    elseif type(target) == "table" then return V.arena_x + (V.arena_w * (target.x - 0.5)), V.arena_y + (V.arena_h * (target.y - 0.5)) end
end

--- Move towards a point in the arena. x = 0, y = 0 is top-left. x = 1, y = 1 is bottom-right.
---@param p table
function Move(p)
    local me = GetUpdatedEntityID()
    local x, y = EntityGetTransform(me)
    p.speed = p.speed or 1
    local vel = EntityGetFirstComponent(me, "VelocityComponent")
    if not vel then return end
    local vx, vy = ComponentGetValue2(vel, "mVelocity")

    local x2, y2 = x + 1, y + 1
    x2, y2 = target_coords(x, y, p.target)
    local distance = math.sqrt((x2 - x)^2 + (y2 - y)^2)
    if distance ~= 0 then
        local curb_dist_max = 100
        local curb_max = 0
        local dir = math.atan2((y2 - y), (x2 - x))
        local curbing = math.min(1, curb_max + (1 - curb_max) * (distance / curb_dist_max))
        vx = (vx + (math.cos(dir) * p.speed) * curbing)
        vy = (vy + (math.sin(dir) * p.speed) * curbing)
        ComponentSetValue2(vel, "mVelocity", vx, vy)
    end
end

-- Shoot some bullet! Returns a table of the entity ids that were created.
---@param p table
function Shoot(p)
    local me = GetUpdatedEntityID()
    p.deg_add = math.rad(p.deg_add or 0)
    p.deg_between = math.rad(p.deg_between or 0)
    p.deg_random = math.rad(p.deg_random or 0)
    p.deg_random_per = math.rad(p.deg_random_per or 0)
	p.stick_frames = p.stick_frames or 0
    p.target = p.target or "RIGHT"
    p.whoshot = p.whoshot and (EntityGetIsAlive(p.whoshot) and p.whoshot) or me
    p.count = p.count or 1
    local x, y = EntityGetTransform(me)
    local x2, y2 = target_coords(x, y, p.target)
    x2, y2 = x2 or x + 1, y2 or y + 1

    SetRandomSeed(GameGetFrameNum() + x, y + 234090 + me)

    local projs = {}
    p.deg_random = Random(p.deg_random, -p.deg_random)
    local turn_deg = p.deg_between * -0.5 * (p.count - 1)
    for i = 1, p.count do
        local entity = EntityLoad(p.file, x, y)
        SetRandomSeed(GameGetFrameNum() + x, y + 234090 + me)

        local speed_min, speed_max, turn = 0, 0, 0
        local proj = EntityGetFirstComponentIncludingDisabled(entity, "ProjectileComponent")
        if proj then
            speed_min = ComponentGetValue2(proj, "speed_min")
            speed_max = ComponentGetValue2(proj, "speed_max")
            ComponentSetValue2(proj, "mWhoShot", p.whoshot)
            local herd = EntityGetFirstComponent(p.whoshot, "GenomeDataComponent")
			local herd2 = EntityGetFirstComponent(entity, "GenomeDataComponent")
            if herd and herd2 then
                ComponentSetValue2(proj, "mShooterHerdId", ComponentGetValue2(herd, "herd_id"))
                ComponentSetValue2(herd2, "herd_id", ComponentGetValue2(herd, "herd_id"))
            end
            -- ComponentSetValue2(proj, "collide_with_entities", true)
            ComponentSetValue2(proj, "collide_with_shooter_frames", p.stick_frames)
            turn = ComponentGetValue2(proj, "direction_nonrandom_rad") + ((p.deg_random_per + ComponentGetValue2(proj, "direction_random_rad")) * Random(-360, 360) / 360)
        end

        local speed = Random(speed_min, speed_max)
        local direction = math.pi - math.atan2((y2 - y), (x2 - x)) + turn + p.deg_add + turn_deg + p.deg_random
        local vel_x = 0 - math.cos( direction ) * speed
        local vel_y = math.sin( direction ) * speed

        GameShootProjectile(p.whoshot, x, y, x+vel_x, y+vel_y, entity, false)
        local vel = EntityGetFirstComponentIncludingDisabled(entity, "VelocityComponent")
        if vel then
            ComponentSetValue2(vel, "mVelocity", vel_x, vel_y)
        end

        EntityAddTag(entity, "comedic_nohurt")
        EntityAddTag(entity, "comedic_noheal")
        -- EntityAddTag(entity, "nohit")
		if p.stick_frames > 0 then
			EntityAddComponent2(entity, "LuaComponent", {
				script_source_file="mods/noiting_simulator/files/battles/proj_sticky.lua",
				limit_how_many_times_per_frame=p.whoshot,
				execute_times = p.stick_frames,
				script_material_area_checker_failed=tostring(math.pi - math.atan2(vel_y, vel_x)),
				script_material_area_checker_success=speed,
			})
		end
        turn_deg = turn_deg + p.deg_between
        projs[#projs+1] = entity
    end
    return projs
end