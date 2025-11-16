--- Move in a basic direction by changing x/y velocity.
---@param mx number?
---@param my number?
function Move(mx, my)
    local me = GetUpdatedEntityID()
    local vel = EntityGetFirstComponent(me, "VelocityComponent")
    if not vel then return end
    local vx, vy = ComponentGetValue2(vel, "mVelocity")

    ComponentSetValue2(vel, "mVelocity", vx + (mx or 0), vy + (my or 0))
end

--- Move towards a point in the arena. x = 0, y = 0 is top-left. x = 1, y = 1 is bottom-right.
---@param mx number
---@param my number
---@param speed number?
function Movetopoint(mx, my, speed)
    local me = GetUpdatedEntityID()
    local x, y = EntityGetTransform(me)
    speed = speed or 1
    local vel = EntityGetFirstComponent(me, "VelocityComponent")
    if not vel then return end
    local vx, vy = ComponentGetValue2(vel, "mVelocity")

    local tx = V.arena_x + (V.arena_w * (mx - 0.5))
    local ty = V.arena_y + (V.arena_h * (my - 0.5))
    local distance = math.sqrt((tx - x)^2 + (ty - y)^2)
    if distance ~= 0 then
        local curb_dist_max = 100
        local curb_max = 0
        local dir = math.atan((ty - y) / (tx - x))
        if tx < x then dir = dir + math.pi end
        local curbing = math.min(1, curb_max + (1 - curb_max) * (distance / curb_dist_max))
        vx = (vx + (math.cos(dir) * speed) * curbing)
        vy = (vy + (math.sin(dir) * speed) * curbing)
        ComponentSetValue2(vel, "mVelocity", vx, vy)
    end
end

-- Shoot some bullet!
---@param p table
function Shoot(p)
    p.deg_add = math.rad(p.deg_add or 0)
    p.deg_between = math.rad(p.deg_between or 0)
    p.deg_random = math.rad(p.deg_random or 0)
    p.deg_random_per = math.rad(p.deg_random_per or 0)
    p.count = p.count or 1
    local me = GetUpdatedEntityID()
    local x, y = EntityGetTransform(me)
        local target_coords = {
        ["PLAYER"] = function() return EntityGetTransform(EntityGetClosestWithTag(x, y, "player_unit")) end,
        ["UP"] = function() return x, y - 5 end,
        ["DOWN"] = function() return x, y + 5 end,
        ["LEFT"] = function() return x - 5, y end,
        ["RIGHT"] = function() return x + 5, y end,
    }
    if not target_coords[p.target] then p.target = "UP" end
    local x2, y2 = target_coords[p.target]()
    x2 = x2 or x + 1
    y2 = y2 or y + 1

    SetRandomSeed(GameGetFrameNum() + x, y + 234090 + me)

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
            ComponentSetValue2(proj, "mWhoShot", me)
            ComponentSetValue2(proj, "mShooterHerdId", StringToHerdId("healer"))
            ComponentSetValue2(proj, "collide_with_entities", true)
            turn = ComponentGetValue2(proj, "direction_nonrandom_rad") + ((p.deg_random_per + ComponentGetValue2(proj, "direction_random_rad")) * Random(-360, 360) / 360)
        end

        local speed = Random(speed_min, speed_max)
        local direction = math.pi - math.atan2((y2 - y), (x2 - x)) + turn + p.deg_add + turn_deg + p.deg_random
        local vel_x = 0 - math.cos( direction ) * speed
        local vel_y = math.sin( direction ) * speed

        local vel = EntityGetFirstComponentIncludingDisabled(entity, "VelocityComponent")
        if vel then
            ComponentSetValue2(vel, "mVelocity", vel_x, vel_y)
        end

        GameShootProjectile(me, x, y, x+vel_x, y+vel_y, entity, false)
        EntityAddTag(entity, "comedic_nohurt")
        EntityAddTag(entity, "comedic_noheal")
        EntityAddTag(entity, "nohit")
        turn_deg = turn_deg + p.deg_between
    end
end