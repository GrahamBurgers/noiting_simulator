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
---@param proj_filepath string
---@param target string? PLAYER, NONE
---@param intro_time number?
---@param how_many number?
---@param deg_add number?
---@param deg_between number?
function Shoot(proj_filepath, target, intro_time, how_many, deg_add, deg_between)

end